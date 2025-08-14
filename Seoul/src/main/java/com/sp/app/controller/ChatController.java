package com.sp.app.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.chat.model.ChatMessage;
import com.sp.app.chat.model.ChatRoom;
import com.sp.app.chat.model.ChatRoomQuery;
import com.sp.app.chat.model.TransactionReview;
import com.sp.app.chat.service.ChatService;
import com.sp.app.model.SessionInfo;

import jakarta.servlet.http.HttpServletRequest;
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
			
			dto.setBuyerId(info.getMember_id());
			
			int result = chatService.createChatRoom(dto);
			
			ChatRoom room = chatService.getChatRoomByProductAndBuyer(
					 ChatRoomQuery.builder()
					 	.productId(dto.getProductId())
					 	.user1Id(dto.getBuyerId())
					 	.build()
					);
			
			if(room != null) {
				return "redirect:/chat/message?roomId=" + room.getRoomId(); 
 			}
					
		} catch (Exception e) {
			log.info("createChatRoom : ", e);
		}
		
		return "redirect:/chat/myRooms";
	}
	
	// 내 채팅방 목록
	@GetMapping("myRooms")
	public String myChatRooms(@RequestParam("memberId") Long memberId, Model model) {
		try {
			List<ChatRoom> list = chatService.getMyChatRooms(memberId);
			model.addAttribute("chatRooms", list);
		} catch (Exception e) {
			log.info("myChatRooms : ", e);
		}
		return "chat/myRooms";
	}
	
	// 채팅 메시지 목록
	@GetMapping("messages")
	public String messageList(@RequestParam("roomId") Long roomId, Model model, HttpServletResponse resp) {
		try {
			List<ChatMessage> messages = chatService.getMessagesByRoomId(roomId);
			model.addAttribute("message", messages);
			
		} catch (Exception e) {
			log.info("messageList : ", e);
			try {
				resp.sendError(406);
			} catch (Exception e2) {
			}
		}
		return "chat/messages";
	}
	
	// 리뷰 작성
	@PostMapping("review")
	public String writeReview(TransactionReview dto, Model model) {
		try {
			int result = chatService.writeReview(dto);
			model.addAttribute("result", result);
		} catch (Exception e) {
			log.info("writeReview", e);
		}
		return "redirect:/chat/review?chatId=" + dto.getChatId();
	}
	
	// 리뷰 조회
	@GetMapping("review")
	public String review(@RequestParam("chatId") Long chatId, Model model) {
		try {
			TransactionReview review = chatService.getReviewByChatId(chatId);
			model.addAttribute("review", review);
		} catch (Exception e) {
			log.info("review", e);
		}
		return "chat/review";
	}
	
}





















