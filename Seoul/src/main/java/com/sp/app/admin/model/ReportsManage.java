package com.sp.app.admin.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ReportsManage {
	private long report_num;
	private Long reported_by;
	
	// 신고 대상 정보
	private Long target_num;
	private String target_title;
	private String target_table;
	private String target_type;
	
	// 신고 내용
	private String reason_code;
	private String reason_detail;
	private String report_ip;
	private String report_date;
	
	// 처리 상태
	private int report_status; // 1:접수, 2:완료, 3:기각
	
	// 관리자 처리
	private Long handled_by;
	private String handling_note;
	private String handled_date;
	
	// 처리 관련 정보
	private int reportsCount;
	private String reporter_name;
	private String nickname;
	private String processor_name;
	
	// 신고 대상 게시글 정보
	private String writer_id;
	private String writer;
	private String subject;
	private String content;
	private String region_id;
	private int block;
	
	private String mode;
}
