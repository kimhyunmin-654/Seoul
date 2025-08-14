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
	private Long notiId;
	private Long chatId;
	private Long memberId;
	private boolean isRead;
	private Date createdAt;
}
