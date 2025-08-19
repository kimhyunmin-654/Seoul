package com.sp.app.chat.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sp.app.chat.model.ChatMessage;
import com.sp.app.chat.model.ChatNotification;
import com.sp.app.chat.model.ChatRoom;
import com.sp.app.chat.model.ChatRoomQuery;
import com.sp.app.chat.model.TransactionReview;
import com.sp.app.model.Member;

@Mapper
public interface ChatMapper {
	// Chat Room
	public int insertChatRoom(ChatRoom dto);
	public ChatRoom findByRoomId(Long roomId);
	public ChatRoom findByProductAndBuyer(ChatRoomQuery query);
	public List<ChatRoom> listRoomsByMemberId(Long member_id);
	public void deleteChatRoom(Long room_id) throws Exception;
	
	// Chat Message
	public int insertChatMessage(ChatMessage dto);
	public List<ChatMessage> listMessagesByRoomId(Long room_id);
	public ChatMessage findLastMessage(Long room_id);
	public String findNicknameById(@Param("memberId") Long member_id);
	
	// Chat Notification
	public int insertNotification(ChatNotification dto);
	public int markAsRead(Long chat_id, Long member_id);
	public int countUnreadByMemberId(Long member_id);
	public List<ChatNotification> listUnreadByMemberId(Long member_id);
	public int markAllAsRead(Long member_id);
	
	// Transaction Review
	public int insertReview(TransactionReview dto);
	public TransactionReview findReviewByChatId(Long chat_id);
	public boolean existsReviewByChatId(Long chat_id);
	public List<TransactionReview> listReviewByProductId(Long product_id);
	
	public Member findById(Long member_id);
}
