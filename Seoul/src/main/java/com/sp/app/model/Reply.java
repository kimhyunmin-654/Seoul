package com.sp.app.model;

import org.springframework.beans.factory.annotation.Value;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Reply {
	private long reply_num;
	private Long member_id;
	private long num;
	private String nickname;
	private String profile_photo;
	private String content;
	private String reg_date;
	private long parent_num;
	private int show_reply;
	private int block;
	
	private int answerCount;
	private int likeCount;
	private int disLikeCount;
	
	@Value("-1")
	private int userReplyLiked;

	private boolean userBlocked;
	private boolean managerBlocked;
}
