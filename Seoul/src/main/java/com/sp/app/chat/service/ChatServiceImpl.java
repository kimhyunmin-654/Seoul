package com.sp.app.chat.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.chat.mapper.ChatMapper;
import com.sp.app.chat.model.ChatMessage;
import com.sp.app.chat.model.ChatNotification;
import com.sp.app.chat.model.ChatRoom;
import com.sp.app.chat.model.ChatRoomQuery;
import com.sp.app.chat.model.TransactionReview;

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
    				.productId(dto.getProductId())
    				.user1Id(dto.getBuyerId())
    				.build();
    		
    		ChatRoom existing = chatMapper.findByProductAndBuyer(query);
    		if(existing == null) {
    			result = chatMapper.insertChatRoom(dto);
    		} else {
    			log.info("이미 존재하는 채팅방: {}", existing.getRoomId());
    		}
    		
		} catch (Exception e) {
			log.info("createChatRoom : ", e);
		}
        return result;
    }

    @Override
    public ChatRoom getChatRoomById(Long roomId) {
    	ChatRoom room = null;
    	try {
			room = chatMapper.findByRoomId(roomId);
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
    public List<ChatRoom> getMyChatRooms(Long memberId) {
        List<ChatRoom> list = null;
        
        try {
        	list = chatMapper.listRoomsByMemberId(memberId);
        	
        	for(ChatRoom room : list) {
        		ChatMessage lastMessage = chatMapper.findLastMessage(room.getRoomId());
        		if(lastMessage != null) {
        			room.setLastMessage(lastMessage.getMessage());
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
        			.chatId(dto.getChatId())
        			.memberId(dto.getReceiverId())
        			.isRead(false)
        			.build();
        	
        	chatMapper.insertNotification(noti);
		} catch (Exception e) {
			log.info("sendMessage : ", e);	
		}
       
        return result;
    }

    @Override
    public List<ChatMessage> getMessagesByRoomId(Long roomId) {
        List<ChatMessage> list = null;
        try {
        	list = chatMapper.listMessagesByRoomId(roomId);
		} catch (Exception e) {
			log.info("getMessagesByRoomId : ", e);	
		}
        return list;
    }

    @Override
    public ChatMessage getLastMessage(Long roomId) {
        ChatMessage message = null;
        
        try {
        	message = chatMapper.findLastMessage(roomId);
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
    public int markAsRead(Long chatId, Long memberId) {
    	int result = 0;
    	try {
			result = chatMapper.markAsRead(chatId, memberId);
		} catch (Exception e) {
			log.info("markAsRead : ", e);
		}
    	return result;
    } 
    

    @Override
    public int countUnread(Long memberId) {
    	int result = 0;
    	try {
			result = chatMapper.countUnreadByMemberId(memberId);
		} catch (Exception e) {
			log.info("countUnread : ", e);
		}
    	return result;
    }

    @Override
    public List<ChatNotification> getUnreadNotifications(Long memberId) {
        List<ChatNotification> list = null;
        try {
			list = chatMapper.listUnreadByMemberId(memberId);
		} catch (Exception e) {
			log.info("getUnreadNotifications : ", e);
		}
        return list;
    }

    @Override
    public int writeReview(TransactionReview dto) {
    	int result = 0;
    	try {
    		if(chatMapper.existsReviewByChatId(dto.getChatId())) {
    			log.info("이미 작성된 리뷰: chatId={}", dto.getChatId());
    			return 0;
    		}
    		result = chatMapper.insertReview(dto);
		} catch (Exception e) {
			log.info("writeReview : ", e);
		}
    	return result;
        
    }

    @Override
    public TransactionReview getReviewByChatId(Long chatId) {
    	TransactionReview review = null;
    	try {
			review = chatMapper.findReviewByChatId(chatId);
		} catch (Exception e) {
			log.info("getReviewByChatId : ", e);
		}
    	return review;
    }

    @Override
    public boolean hasReview(Long chatId) {
    	boolean result = false;
    	try {
			result = chatMapper.existsReviewByChatId(chatId);
		} catch (Exception e) {
			log.info("hasReview : ", e);
		}
    	return result;
    }

    @Override
    public List<TransactionReview> getReviewsByProductId(Long productId) {
    	List<TransactionReview> list = null;
    	try {
    		list = chatMapper.listReviewByProductId(productId);
		} catch (Exception e) {
			log.info("getReviewsByProductId : ", e);

		}
    	return list;
    }
} 
