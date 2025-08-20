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
    private Long chat_id;              
    private Long room_id;              
    private Long product_id;           
    
    private Long sender_id;           
    private String nickname;    		
    private String profile_photo;	  
    
    private Long receiver_id;          
    private String message;           
    private String timestamp;         
    
    private Date sent_time;            
	
	
}
