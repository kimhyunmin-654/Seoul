package com.sp.app.chat.model;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatMessage {
    private Long chat_id;              // DB 저장용 PK (선택)
    private Long room_id;              // 채팅방 ID (필수)
    private Long product_id;           // 중고상품 ID (선택)
    
    private Long sender_id;            // 보낸 사람 ID
    private String nickname;    		// 보낸 사람 닉네임 (화면 표시용)
    private String profile_photo;	  // 보낸 사람 프로필 (화면 표시용)
    
    private Long receiver_id;          // 받는 사람 ID
    private String message;           // 메시지 내용
    private String timestamp;         // 전송 시간 (클라이언트 표시용)
    
    private Date sent_time;            // DB 저장용 전송 시간 (선택)
	
	
}
