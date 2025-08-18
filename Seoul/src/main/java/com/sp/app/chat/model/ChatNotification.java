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
public class ChatNotification {
	private Long noti_id;
	private Long chat_id;
	private Long member_id;
	private boolean is_read;
	private Date created_at;
}
