package com.sp.app.chat.service;

import java.util.List;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.chat.mapper.ChatMapper;
import com.sp.app.chat.model.ChatMessage;
import com.sp.app.chat.model.ChatNotification;
import com.sp.app.chat.model.ChatRoom;
import com.sp.app.chat.model.ChatRoomQuery;
import com.sp.app.chat.model.TransactionReview;
import com.sp.app.model.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ChatServiceImpl implements ChatService {
    private final ChatMapper chatMapper;

    @Transactional(rollbackFor = {Exception.class})
    @Override
    public int createChatRoom(ChatRoom dto) {
    	int result = 0;
    	try {
    		ChatRoomQuery query = ChatRoomQuery.builder()
    				.product_id(dto.getProduct_id())
    				.user1Id(dto.getBuyer_id())
    				.build();
    		
    		ChatRoom existing = chatMapper.findByProductAndBuyer(query);
    		if(existing == null) {
    			result = chatMapper.insertChatRoom(dto);
    		} else {
    			log.info("이미 존재하는 채팅방: {}", existing.getRoom_id());
    		}
    		
		} catch (Exception e) {
			log.info("createChatRoom : ", e);
		}
        return result;
    }

    @Override
    public ChatRoom getChatRoomById(Long room_id) {
    	ChatRoom room = null;
    	try {
			room = chatMapper.findByRoomId(room_id);
		} catch (Exception e) {
			log.info("getChatRoomById : ", e);
		}
    	
    	return room;
    }

    @Override
    public ChatRoom getChatRoomByProductAndBuyer(ChatRoomQuery query) {
        ChatRoom room = null;
    	try {
			room = chatMapper.findByProductAndBuyer(query);
		} catch (Exception e) {
			log.info("getChatRoomByProductAndBuyer : ", e);
		}
    	
    	return room;
    }

    @Override
    public List<ChatRoom> getMyChatRooms(Long member_id) {
        List<ChatRoom> list = null;
        
        try {
        	list = chatMapper.listRoomsByMemberId(member_id);
        	
        	if(list != null) {
	        	for(ChatRoom room : list) {
	        		if(room == null || room.getRoom_id() == null) {
	        			continue;
	        		}
	        		
	        		ChatMessage lastMessage = chatMapper.findLastMessage(room.getRoom_id());
	        		if(lastMessage != null) {
	        			room.setLastMessage(lastMessage.getMessage());
	        			
	        			room.setLastTime(lastMessage.getSent_time());
	        			
	        			log.info("🔍 room_id: {}, lastTime: {}", room.getRoom_id(), room.getLastTime()); 

	                    Long opponentId = member_id.equals(room.getBuyer_id()) ? room.getSeller_id() : room.getBuyer_id();
	
	                    String nickname = chatMapper.findNicknameById(opponentId); 
	
	                    room.setNickname(nickname);
	        			
	        		}
	        	}
        	}
		} catch (Exception e) {
			log.info("getMyChatRooms : ", e);
		}       
        return list;
    }

    @Transactional(rollbackFor = {Exception.class})
    @Override
    public int sendMessage(ChatMessage dto) {
        int result = 0;
        try {
        	result = chatMapper.insertChatMessage(dto);
        	
        	ChatNotification noti = ChatNotification.builder()
        			.chat_id(dto.getChat_id())
        			.member_id(dto.getReceiver_id())
        			.is_read(false)
        			.build();
        	
        	chatMapper.insertNotification(noti);
		} catch (Exception e) {
			log.info("sendMessage : ", e);	
		}
       
        return result;
    }

    @Override
    public List<ChatMessage> getMessagesByRoomId(Long room_id) {
        List<ChatMessage> list = null;
        try {
        	list = chatMapper.listMessagesByRoomId(room_id);
		} catch (Exception e) {
			log.info("getMessagesByRoomId : ", e);	
		}
        return list;
    }

    @Override
    public ChatMessage getLastMessage(Long room_id) {
        ChatMessage message = null;
        
        try {
        	message = chatMapper.findLastMessage(room_id);
		} catch (Exception e) {
			log.info("getLastMessage : ", e);	
		}
    	
    	return message;
    }

    @Transactional(rollbackFor = {Exception.class})
    @Override
    public int createNotification(ChatNotification dto) {
    	int result = 0;
    	try {
			result = chatMapper.insertNotification(dto);
		} catch (Exception e) {
			log.info("createNotification : ", e);
		}
    	return result;
    }

    @Override
    public int markAsRead(Long chat_id, Long member_id) {
    	int result = 0;
    	try {
			result = chatMapper.markAsRead(chat_id, member_id);
		} catch (Exception e) {
			log.info("markAsRead : ", e);
		}
    	return result;
    } 
    

    @Override
    public int countUnread(Long member_id) {
    	int result = 0;
    	try {
			result = chatMapper.countUnreadByMemberId(member_id);
		} catch (Exception e) {
			log.info("countUnread : ", e);
		}
    	return result;
    }

    @Override
    public List<ChatNotification> getUnreadNotifications(Long member_id) {
        List<ChatNotification> list = null;
        try {
			list = chatMapper.listUnreadByMemberId(member_id);
		} catch (Exception e) {
			log.info("getUnreadNotifications : ", e);
		}
        return list;
    }
    
    @Override
    public int markAllAsRead(Long member_id) {
    	int result = 0;
    	try {
			result = chatMapper.markAllAsRead(member_id);
		} catch (Exception e) {
			log.info("markAllAsRead : ", e);
		}
    	
        return result;
    }
    
    @Transactional(rollbackFor = {Exception.class})
    @Override
    public int writeReview(TransactionReview dto) {
    	int result = 0;
    	try {
    		if(chatMapper.existsReviewByChatId(dto.getChat_id())) {
    			log.info("이미 작성된 리뷰: chat_id={}", dto.getChat_id());
    			return 0;
    		}
    		result = chatMapper.insertReview(dto);
		} catch (Exception e) {
			log.info("writeReview : ", e);
		}
    	return result;
        
    }

    @Override
    public TransactionReview getReviewByChatId(Long chat_id) {
    	TransactionReview review = null;
    	try {
			review = chatMapper.findReviewByChatId(chat_id);
		} catch (Exception e) {
			log.info("getReviewByChatId : ", e);
		}
    	return review;
    }

    @Override
    public int hasReview(Long chat_id) {
    	int count = 0;
    	try {
    		count = chatMapper.existsReviewByChatId(chat_id) ? 1 : 0;
		} catch (Exception e) {
			log.info("hasReview : ", e);
		}
    	return count;
    }

    @Override
    public List<TransactionReview> getReviewsByProductId(Long product_id) {
    	List<TransactionReview> list = null;
    	try {
    		list = chatMapper.listReviewByProductId(product_id);
		} catch (Exception e) {
			log.info("getReviewsByProductId : ", e);

		}
    	return list;
    }

	@Override
	public Member getMemberById(Long member_id) {
		Member dto = null;
		try {
			dto = chatMapper.findById(member_id);
		} catch (Exception e) {
			log.info("getMemberById : ", e);
		}
		
		return dto;
	}

	@Transactional(rollbackFor = {Exception.class})
	@Override
	public void deleteChatRoom(Long room_id) throws Exception{
		try {
			ChatRoom dto = Objects.requireNonNull(findByRoomId(room_id));
			
			chatMapper.deleteChatRoom(room_id);
		} catch (Exception e) {
			log.info("deleteChatRoom : ", e);
			
			throw e;
		}		
	}

	@Override
	public ChatRoom findByRoomId(Long room_id) {
		ChatRoom dto = null;
		
		try {
			dto = chatMapper.findByRoomId(room_id);
		} catch (Exception e) {
			log.info("findByRoomId : ", e);
		}
		
		return dto;
	}

} 
