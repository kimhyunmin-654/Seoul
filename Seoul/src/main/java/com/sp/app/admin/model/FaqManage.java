package com.sp.app.admin.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
public class FaqManage {
	private long faq_id;
	private long member_id;
	private String question;
	private String content;
	private String reg_date;
	private int hit_count;
	private String nickname;
	private String update_date;
}

