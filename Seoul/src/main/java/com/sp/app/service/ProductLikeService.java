package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.model.ProductLike;

public interface ProductLikeService {

	public List<ProductLike> listProductLike(Map<String, Object> map) throws Exception;
	
	public boolean insertProductLike(Map<String, Object> map) throws Exception;
	
	public void deleteProductLike(Map<String, Object> map) throws Exception;
	
	public boolean isLiked(Map<String, Object> map) throws Exception;
	
}
