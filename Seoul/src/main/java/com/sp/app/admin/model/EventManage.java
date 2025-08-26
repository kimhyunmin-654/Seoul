package com.sp.app.admin.model;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class EventManage {
	private long event_num;
	private Long member_id;
	private String login_id;
	private String nickname;
	private String title;
	private String content;
	private String event_type; // NOTICE, ENTRY
	private String startDate;
	private String sday;
	private String stime;
	private String endDate;
	private String eday;
	private String etime;
	private String winningDate;
	private String wday;
	private String wtime;
	private int winner_number;
	private int show_event;
	private int hit_count;
	private Long update_id;
	private String login_update;
	private String update_nickname;
	private String update_date;
	private String reg_date;
	
	// 파일(관리자 썸네일)
	private String saveFilename;
	private String originalFilename;
	private MultipartFile selectFile;
	private long filesize;
	
	private int rank;
	
	private int applyCount; 
	private int winnerCount;
	
	// 당첨자 발표
	private int winEvent; // 1:순위없음, 2:순위있음
	private List<Integer> rankNum;
	private List<Integer> rankCount;
}
