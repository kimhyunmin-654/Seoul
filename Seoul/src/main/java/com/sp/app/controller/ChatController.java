package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.chat.model.ChatMessage;
import com.sp.app.chat.model.ChatRoom;
import com.sp.app.chat.model.ChatRoomQuery;
import com.sp.app.chat.service.ChatService;
import com.sp.app.model.Member;
import com.sp.app.model.SessionInfo;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/chat/*")
public class ChatController {
	private final ChatService chatService;
	
	// 채팅방 생성
	@PostMapping("createRoom")
	public String createChatRoom(ChatRoom dto, HttpSession session) {
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			if(info == null) {
				return "redirect:/member/login"; // 비로그인 시 로그인 페이지로
			}
			
			dto.setBuyer_id(info.getMember_id());
			
			int result = chatService.createChatRoom(dto);
			
			ChatRoom room = chatService.getChatRoomByProductAndBuyer(
					 ChatRoomQuery.builder()
					 	.product_id(dto.getProduct_id())
					 	.user1Id(dto.getBuyer_id())
					 	.build()
					);
			
			if(room != null) {
				return "redirect:/chat/message?room_id=" + room.getRoom_id(); 
 			}
					
		} catch (Exception e) {
			log.info("createChatRoom : ", e);
		}
		
		return "redirect:/chat/myRooms";
	}
	
	// 내 채팅방 목록
	@GetMapping("myRooms")
	public String myChatRooms(HttpSession session, Model model) {
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			if(info == null) {
				return "redirect:/member/login";
			}
			
			Long memberId = info.getMember_id();
			List<ChatRoom> list = chatService.getMyChatRooms(memberId);
			model.addAttribute("chatRooms", list);
			
		} catch (Exception e) {
			log.info("myChatRooms : ", e);
		}
		return "chat/myRooms";
	}
	
	// 채팅 메시지 목록
	@GetMapping("messages")
	public String messageList(@RequestParam("room_id") Long room_id, Model model, HttpServletResponse resp) {
		try {
			List<ChatMessage> messages = chatService.getMessagesByRoomId(room_id);
			model.addAttribute("messages", messages);
			
		} catch (Exception e) {
			log.info("messageList : ", e);
			try {
				resp.sendError(406);
			} catch (Exception e2) {
			}
		}
		return "chat/messages";
	}
	
	@GetMapping("list")
	public String chatList(HttpSession session, Model model) {
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			if(info == null) {
				return "chat/myRooms";
			}
			
			List<ChatRoom> list = chatService.getMyChatRooms(info.getMember_id());
			model.addAttribute("chatRooms", list);
		} catch (Exception e) {
			log.info("chatList", e);
		}
		return "chat/myRooms"; 
			
	}	
	
    // 읽음 처리
    @PostMapping("/markAllAsRead")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> markAllAsRead(HttpSession session) {
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) {
            Map<String, Object> resp = new HashMap<>();
            resp.put("success", false);
            resp.put("error", "not_logged_in");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(resp);
        }

        int result = 0;
        try {
            result = chatService.markAllAsRead(info.getMember_id());
        } catch (Exception e) {
            log.info("markAllAsRead: ", e);
        }

        Map<String, Object> map = new HashMap<>();
        map.put("success", result > 0);
        return ResponseEntity.ok(map);
    }
    
    @PostMapping("createRoomAjax")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createRoomAjax(
            @RequestParam("product_id") Long product_id,
            @RequestParam("seller_id") Long seller_id,
            HttpSession session) {

        Map<String, Object> map = new HashMap<>();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) {
            map.put("success", false);
            map.put("error", "not_logged_in");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(map);
        }

        Long buyerId = info.getMember_id();

        if (product_id == null || seller_id == null || product_id <= 0 || seller_id <= 0) {
            map.put("success", false);
            map.put("error", "invalid_parameters");
            return ResponseEntity.badRequest().body(map);
        }

        if (seller_id.equals(buyerId)) {
            map.put("success", false);
            map.put("error", "cannot_chat_with_self");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(map);
        }

        try {
            ChatRoom dto = ChatRoom.builder()
                    .product_id(product_id)
                    .seller_id(seller_id)
                    .buyer_id(buyerId)
                    .build();

            chatService.createChatRoom(dto);

            ChatRoom room = chatService.getChatRoomByProductAndBuyer(
                    ChatRoomQuery.builder()
                            .product_id(product_id)
                            .user1Id(buyerId)
                            .build()
            );

            if (room == null || room.getRoom_id() == null) {
                map.put("success", false);
                map.put("error", "room_creation_failed");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(map);
            }

            map.put("success", true);
            map.put("room_id", room.getRoom_id());
            map.put("product_id", product_id);
            map.put("seller_id", seller_id);

            Member seller = chatService.getMemberById(seller_id);
            if (seller != null) {
                map.put("sellerNick", seller.getNickname());
            }

            return ResponseEntity.ok(map);

        } catch (Exception e) {
            log.info("createRoomAjax error", e);
            map.put("success", false);
            map.put("error", "server_error");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(map);
        }
    }
    
    @PostMapping("deleteroomAjax")
    @ResponseBody
    public Map<String,Object> deleteRoomAjax(@RequestBody Map<String,Long> body, HttpSession session) {
        Map<String,Object> resp = new HashMap<>();
        SessionInfo info = (SessionInfo) session.getAttribute("member");
        if (info == null) {
            resp.put("result","error");
            resp.put("message","로그인이 필요합니다.");
            return resp;
        }
        Long roomId = body.get("room_id");
        try {
            chatService.deleteChatRoom(roomId);
            resp.put("result","success");
        } catch (Exception e) {
            log.info("deleteroomAjax error", e);
            resp.put("result","error");
            resp.put("message","삭제 중 오류가 발생했습니다.");
        }
        return resp;
    }
	
}





















