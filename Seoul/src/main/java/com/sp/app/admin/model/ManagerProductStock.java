package com.sp.app.admin.model;

import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ManagerProductStock {
	private long stock_num;
	private long product_num;
	private Long detail_num;
	private int total_stock;
	
	private List<Long> stockNums;
	private List<Long> detailNums;
	private List<Integer> totalStocks;
	
	private String product_name;
	private String option_name;
	private String option_value;
}
