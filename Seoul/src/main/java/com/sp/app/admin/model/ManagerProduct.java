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
    private long productNum;        // product_num
    private String productName;     // product_name
    private int price;
    private int delivery;
    private int productShow;        // product_show
    private int orderbyCategory;    // orderby_category
    private int optionCount;
    private String content;
    private String thumbnail;
    private String regDate;
    private String updateDate;
    private String productState;

    private MultipartFile thumbnailFile;

    private long categoryNum;       // category_num
    private String categoryName;    // category_name
    private int use;
    private long parentNum;         // parent_num

    private long fileNum;           // file_num
    private String filename;
    private long filesize;
    private List<MultipartFile> addFiles;

    private Long optionNum;         // option_num
    private String optionName;      // option_name
    private Long parentOption;      // parent_option

    private Long detailNum;         // detail_num
    private String optionValue;     // option_value
    private List<Long> detailNums;
    private List<String> optionValues;

    private int totalStock;

    private long prevOptionNum;
}