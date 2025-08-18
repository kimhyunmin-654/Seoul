package com.sp.app.admin.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class InquiryManage {
	private long inquiry_id;
	private Long member_id;
	private String login_id;
	private String name;
	private String title;
	private String content;
	private String created_at;
	
	private long answer_id;
	private String answer;
	private String answerName;
	private String answered_at;
}
