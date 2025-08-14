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
public class TransactionReview {
	private Long reviewId;
	private Long chatId;
	private Long productId;
	private int rating;
	private String content;
	private Date createdAt;
}
