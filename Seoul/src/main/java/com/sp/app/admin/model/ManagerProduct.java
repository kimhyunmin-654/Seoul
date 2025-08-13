package com.sp.app.admin.model;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ManagerProduct {
	private long product_num;
	private String product_name;
	private int price;
	private int delivery;
	private int product_show;
	private int orderby_category;
	private String content;
	private String thumbnail;
	private String reg_date;
	private String update_date;
	private String product_state;
	
	private MultipartFile thumbnailFile;
	
	private long category_num;
	private String category_name;
	private int use;
	private long parent_num;

	private long file_num;
	private String filename;
	private long filesize;
	private List<MultipartFile> addFiles;
	
	private Long option_num;
	private String option_name;
	private Long parent_option;
	// private int optionCount; ?

	private Long detail_num;
	private String option_value;
	private List<Long> detail_nums;
	private List<String> option_values;
	
	private int total_stock;
	
	private long prevOptionNum;
}
