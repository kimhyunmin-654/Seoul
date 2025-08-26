package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.sp.app.model.Category;
import com.sp.app.model.Product;
import com.sp.app.model.ProductImage;
import com.sp.app.model.Region;
import com.sp.app.model.SearchCondition;

public interface ProductService {
	public Map<String, Long> insertProduct(Product dto, List<MultipartFile> addFiles, Integer thumbnailIndex, String path) throws Exception;
	public void updateProduct(Product dto, List<MultipartFile> addFiles, List<Long> deleteImageIds, List<String> deleteFilename, String oldThumbnailToMove, Long imageIdToPromote, String path, int thumbnailIndex) throws Exception;
	public void deleteProduct(long product_id, long member_id, String path) throws Exception;
	public void deleteProductImage(long image_id, String pathString) throws Exception;
	public Map<String, Object> listProduct(SearchCondition cond) throws Exception;
	public List<ProductImage> listProductImage(long product_id);
	public Product findById(long product_id);
	public int dataCount(SearchCondition cond);
	public List<Category> listCategories();
	public List<Region> listRegion();
	public void updateHitCount(long product_id);
	public List<Product> findByMemberId(long member_id);
}
