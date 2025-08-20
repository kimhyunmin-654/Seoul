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
public class ProductTransaction {
	private long transaction_id;
	private long product_id;
	private long seller_id;
	private long buyer_id;
	private Long room_id;
	private String status;
	private String created_at;
}
