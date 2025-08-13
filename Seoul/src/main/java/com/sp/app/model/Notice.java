package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Notice {
	private long num;
	private String name;
	private int notice;
	private String subject;
	private String content;
	private int hit_count;
	private String reg_date;
	private int showNotice;
	private String modify_date;
	
	private long fileNum;
	private String original_filename;
	private String save_filename;
	private long filesize;
	private int fileCount;
	private long gap;
}
