package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Reports {
	private Long reported_by;
	private Long target_num;
	private String target_title;
	private String target_table;
	private String target_type;
	
	private String reason_code;
	private String reason_detail;
	private String report_ip;
	private String report_date;
	
	private int report_status; // 1:접수, 2:완료, 3:기각
}
