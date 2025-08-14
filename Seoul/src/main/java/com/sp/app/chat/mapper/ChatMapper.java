package com.sp.app.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.chat.model.ChatMessage;
import com.sp.app.chat.model.ChatNotification;
import com.sp.app.chat.model.ChatRoom;
import com.sp.app.chat.model.ChatRoomQuery;
import com.sp.app.chat.model.TransactionReview;

@Mapper
public interface ChatMapper {
	// Chat Room
	int insertChatRoom(ChatRoom dto);
	ChatRoom findByRoomId(Long roomId);
	ChatRoom findByProductAndBuyer(ChatRoomQuery query);
	List<ChatRoom> listRoomsByMemberId(Long memberId);
	
	// Chat Message
	int insertChatMessage(ChatMessage dto);
	List<ChatMessage> listMessagesByRoomId(Long roomId);
	ChatMessage findLastMessage(Long roomId);
	
	// Chat Notification
	int insertNotification(ChatNotification dto);
	int markAsRead(Long chatId, Long memberId);
	int countUnreadByMemberId(Long memberId);
	List<ChatNotification> listUnreadByMemberId(Long memberId);
	
	// Transaction Review
	int insertReview(TransactionReview dto);
	TransactionReview findReviewByChatId(Long chatId);
	boolean existsReviewByChatId(Long chatId);
	List<TransactionReview> listReviewByProductId(Long productId);
}
