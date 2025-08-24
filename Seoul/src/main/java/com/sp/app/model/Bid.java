package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class Bid {
	
	private long bid_id;
	private long auction_id;
	private long bidder_id;
	private String bidder_nickname;
	private int bid_amount;
	private String created_at;
	
}
