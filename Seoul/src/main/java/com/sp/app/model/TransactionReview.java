package com.sp.app.model;

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
	private Long review_id;
	private Long chat_id;
	private Long product_id;
	private Integer rating;
	private String content;
	private Date created_at;
	
	private Long writer_id;
}
