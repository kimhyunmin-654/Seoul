package com.sp.app.model;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Member {
	private Long member_id;
	private String login_id;
	private String email;
	private String password;
	private String name;
	private String nickname;
	private String sns_provider;
	private String sns_id;
	private int userLevel;
	private String created_at;
	private String update_at;
	private String profile_photo;
	private int enabled;
	private String last_login;
	private int failure_cnt;
	
	private MultipartFile selectFile;
}
