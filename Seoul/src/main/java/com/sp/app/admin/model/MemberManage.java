package com.sp.app.admin.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class MemberManage {
	private long member_id;
	private String login_id;
	private String password;
	private String sns_provider;
	private String sns_id;
	private int userLevel;
	private int enabled;
	private String created_at;
	private String update_at;
	private String last_login;
	private int failure_cnt;
	private String name;
	private String email;
	private String nickname;
	private String profile_photo;
	
	private long status_id;
	private int status_code;
	private String memo;
	private long register_id;
	private String login_register;
	private String registerName;
	private String reg_date;
	
}
