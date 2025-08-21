package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.ProductLike;

@Mapper
public interface ProductLikeMapper {
	public void insertProductLike(Map<String, Object> map) throws SQLException;
	public void deleteProductLike(Map<String, Object> map) throws SQLException;
	public int isLiked(Map<String, Object> map);
	public int LikeCount(Map<String, Object> map);
	public List<ProductLike> findById(Map<String, Object> map);
}
