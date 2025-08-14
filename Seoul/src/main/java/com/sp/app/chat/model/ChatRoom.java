package com.sp.app.chat.model;

import java.util.Date;

import org.apache.ibatis.type.Alias;

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
@Alias("ChatRoom")
public class ChatRoom {
	private Long roomId;
	private Long productId;
	private Long buyerId;
	private Long sellerId;
	private Date createdAt;
	private String lastMessage;
}
