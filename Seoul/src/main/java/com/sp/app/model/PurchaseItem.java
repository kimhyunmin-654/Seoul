package com.sp.app.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PurchaseItem {
	private Long transaction_id;
	private Long product_id;
	private String product_name;
	private String thumbnail;
	private Long room_id;
	private String seller_nickname;
	private String buyer_nickname;
	private String created_at;
	
}
