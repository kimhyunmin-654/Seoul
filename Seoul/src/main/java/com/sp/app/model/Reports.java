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
	private String target_table;
	private int target_type;  // 1:게시글, 2:댓글, 3:거래
	private String target_content;
	private String reason_code; // 1:스팸/광고, 2:음란물, 3:욕설/비방/차별적 표현, 4:개인정보 노출, 5:불법거래, 6:기타
	private String reason_detail;
	private String report_ip;
	private String report_date;
	private int report_status; // 1:접수, 2:완료, 3:기각
}
