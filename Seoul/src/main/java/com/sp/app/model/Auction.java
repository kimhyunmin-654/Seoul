package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Auction {
	// 경매 정보
	private long auction_id;
	private int start_price;
	private int current_price;
	private String end_time;
	private String status;
	private int bidCount;
	private String current_winner;
	private Long winner_id;
	private String winner_nickname;
	private String remainingTime;
	private boolean hot;
	private boolean urgent;
	
	// 상품 정보 
	private long product_id;
	private String product_name;
	private String thumbnail;
	private String content;
	private long seller_id;
	private String seller_nickname;
	private String sellerAvatar;
	private int hitCount;
	private int likeCount;
	
}
