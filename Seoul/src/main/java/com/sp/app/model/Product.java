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
	private String nickName;
	private String sellerAvatar;
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
	private String region_name;
	
	// 상품 카테고리
	private String category_name;
	private Long parentNum;
	
	// 경매 정보
	private long auction_id;
	private int start_price;
	private int current_price;
	private String end_time;
	private int bidCount;
	
	// 유저의 상품 찜 여부
	private int userWish;

}
