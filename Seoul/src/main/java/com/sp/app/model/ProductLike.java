package com.sp.app.model;


import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ProductLike {
	
    private int member_id;
    private int product_id;
    private String liked_date;
    private String thumbnail;
    private String product_name;
    private String status;
    private int price;
    private int likecount;


}
