package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.sp.app.model.Auction;
import com.sp.app.model.Category;
import com.sp.app.model.Product;
import com.sp.app.model.ProductImage;
import com.sp.app.model.Region;
import com.sp.app.model.SearchCondition;

public interface ProductService {
	public void insertProduct(Product dto, List<MultipartFile> selectFile, String path) throws Exception;
	public void updateProduct(Product dto) throws Exception;
	public void deleteProduct(long product_id);
	public void deleteProductImage(long image_id);
	public Map<String, Object> listProduct(SearchCondition cond) throws Exception;
	public List<ProductImage> listProductImage(long product_id);
	public List<Auction> listAuction(Map<String, Object> map);
	public Product findById(long product_id);
	public int dataCount(SearchCondition cond);
	public List<Category> listCategories();
	public List<Region> listRegion();
}
