package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Product {
	// 상품 정보
	private long product_id;
	private long member_id;
	private String category_id;
	private String region_id;
	private String product_name;
	private String content;
	private int price;
	private String type;
	private String status;
	private int hitCount;
	private int likeCount;
	private String reg_date;
	private String thumbnail;
	
	// 상품 카테고리
	private String categoryName;
	private Long parentNum;
	
}
