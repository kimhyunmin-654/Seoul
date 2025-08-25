package com.sp.app.chat.service;

import java.util.List;

import com.sp.app.chat.model.ChatMessage;
import com.sp.app.chat.model.ChatNotification;
import com.sp.app.chat.model.ChatRoom;
import com.sp.app.chat.model.ChatRoomQuery;
import com.sp.app.model.Member;

public interface ChatService {
    // ===== 채팅방 =====
    public int createChatRoom(ChatRoom dto);
    public ChatRoom getChatRoomById(Long room_id);
    public ChatRoom getChatRoomByProductAndBuyer(ChatRoomQuery query);
    public List<ChatRoom> getMyChatRooms(Long member_id);
    public void deleteChatRoom(Long room_id) throws Exception;
    public ChatRoom findByRoomId(Long room_id);

    // ===== 메시지 =====
    public int sendMessage(ChatMessage dto);
    public List<ChatMessage> getMessagesByRoomId(Long room_id);
    public ChatMessage getLastMessage(Long room_id);

    // ===== 알림 =====
    public int createNotification(ChatNotification dto);
    public int markAsRead(Long chat_id, Long member_id);
    public int countUnread(Long member_id);
    public List<ChatNotification> getUnreadNotifications(Long member_id);
    public int markAllAsRead(Long member_id);

      
    public Member getMemberById(Long member_id);
    
}
