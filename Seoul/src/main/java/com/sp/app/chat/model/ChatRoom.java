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
public class ChatRoom {
	private Long room_id;
	private Long product_id;
	private Long buyer_id;
	private Long seller_id;
	private Date created_at;
	private String nickname;
	private String product_name;
	private String lastMessage;
	private Date lastTime;
}
