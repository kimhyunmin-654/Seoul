package com.sp.app.admin.model;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class NoticeManage {
	private long num;
	private long member_id;
	private int notice;
	private String subject;
	private String content;
	private int hit_count;
	private String reg_date;
	private String modify_date;
	private int showNotice;
	
	private long fileNum;
	private String save_filename;
	private String original_filename;
	private long filesize;
	private int fileCount;
	
	private List<MultipartFile> selectFile;
	private long gap;
}
