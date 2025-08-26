package com.sp.app.model;

import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Event {
	private long event_num;
	private Long member_id;
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
	private String update_date;
	
	private String saveFilename;
	
	private int rank;
	private String reg_date;
	private String login_id;
	
	private int applyCount;
	private int winnerCount;
	
	// 당첨자 발표
	private int winEvent; // 1:순위없음, 2:순위있음
	private List<Integer> rankNum;
	private List<Integer> rankCount;
	
	// 마감기한
	private String labelDDay;

}
