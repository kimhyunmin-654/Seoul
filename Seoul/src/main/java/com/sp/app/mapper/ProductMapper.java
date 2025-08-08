package com.sp.app.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Product;

@Mapper
public interface ProductMapper {
	
	public void insertProduct(Product dto) throws Exception;
	public void insertProductFile(Product dto) throws Exception;
	public void updateProduct(Product dto) throws Exception;
	public void deleteProduct(long product_id) throws Exception;
	public void deleteProductFile(long image_id) throws Exception;
	
	public List<Product> listProduct(Map<String, Object> map);	
	public Product findById(long product_id);
	public int dataCount(Map<String, Object> map);
		
	public List<Product> listProductImages(long product_id);
	public List<Product> listCategory();
	
}
