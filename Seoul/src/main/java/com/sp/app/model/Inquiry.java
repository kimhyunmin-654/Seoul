package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Inquiry {
	private long inquiry_id;
	private Long member_id;
	private String name;
	private String title;
	private String content;
	private String created_at;
	private String answerName;
	private String answer;
	private String answered_at;
	private int listnum;
	

}
