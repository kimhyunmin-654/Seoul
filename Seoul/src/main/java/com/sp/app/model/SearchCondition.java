package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class SearchCondition {
	private String kwd;
	private String category_id;
	private String region_id;
	private int page = 1;
	private String type;
	private String status;
	
	private int offset;
	private int size = 8;
}
