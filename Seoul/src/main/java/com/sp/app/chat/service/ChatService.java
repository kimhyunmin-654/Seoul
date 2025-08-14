package com.sp.app.chat.service;

import java.util.List;

import com.sp.app.chat.model.ChatMessage;
import com.sp.app.chat.model.ChatNotification;
import com.sp.app.chat.model.ChatRoom;
import com.sp.app.chat.model.ChatRoomQuery;
import com.sp.app.chat.model.TransactionReview;

public interface ChatService {
    // ===== 채팅방 =====
    int createChatRoom(ChatRoom dto);
    ChatRoom getChatRoomById(Long roomId);
    ChatRoom getChatRoomByProductAndBuyer(ChatRoomQuery query);
    List<ChatRoom> getMyChatRooms(Long memberId);

    // ===== 메시지 =====
    int sendMessage(ChatMessage dto);
    List<ChatMessage> getMessagesByRoomId(Long roomId);
    ChatMessage getLastMessage(Long roomId);

    // ===== 알림 =====
    int createNotification(ChatNotification dto);
    int markAsRead(Long chatId, Long memberId);
    int countUnread(Long memberId);
    List<ChatNotification> getUnreadNotifications(Long memberId);

    // ===== 리뷰 =====
    int writeReview(TransactionReview dto);
    TransactionReview getReviewByChatId(Long chatId);
    boolean hasReview(Long chatId);
    List<TransactionReview> getReviewsByProductId(Long productId);	
}
