package com.sp.app.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ProductImage {

	private long image_id;
	private long product_id;
	private String filename;
	private String filesize;
	private int image_order;
}
