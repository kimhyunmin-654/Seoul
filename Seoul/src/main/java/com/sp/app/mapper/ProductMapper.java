package com.sp.app.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Category;
import com.sp.app.model.Product;
import com.sp.app.model.ProductImage;
import com.sp.app.model.Region;
import com.sp.app.model.SearchCondition;

@Mapper
public interface ProductMapper {
	
	public void insertProduct(Product dto) throws Exception;
	public void insertProductFile(ProductImage dto) throws Exception;
	public void updateProduct(Product dto) throws Exception;
	public void deleteProduct(long product_id) throws Exception;
	public void deleteProductImage(long image_id) throws Exception;
	public void deleteProductAllImages(long product_id) throws Exception;
	
	public List<Product> listProduct(SearchCondition cond);	
	public Product findById(long product_id);
	public ProductImage findImageById(long image_id);
	public int dataCount(SearchCondition cond);
		
	public List<ProductImage> listProductImages(long product_id);
	public List<Category> listCategory();
	public List<Region> listRegion();
	
	public void updateHitCount(long product_id);
	
}
