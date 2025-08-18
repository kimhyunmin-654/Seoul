package com.sp.app.model;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Board {
	private long num;
	private String region_id;
	private Long member_id;
	private String nickname;
	private String subject;
	private String content;
	private int hit_count;
	private String reg_date;
	private int block;
	private long filesize;
	
	private String saveFilename;
	private String originalFilename;
	private MultipartFile selectFile;

	private int replyCount;
	private int communityLikeCount;

}
