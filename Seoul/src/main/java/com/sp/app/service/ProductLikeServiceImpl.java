package com.sp.app.service;

 import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sp.app.mapper.ProductLikeMapper;
import com.sp.app.mapper.ProductMapper;
import com.sp.app.model.ProductLike;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductLikeServiceImpl implements ProductLikeService {
	private final ProductLikeMapper mapper;
	private final ProductMapper productMapper;

	@Override
	public List<ProductLike> listProductLike(Map<String, Object> map) {
		List<ProductLike> list = null;
		
		try {
			list = mapper.findById(map);
		} catch (Exception e) {
			log.info("listProductLike : ", e);
		}
		return list;
	}

	@Override
	public boolean insertProductLike(Map<String, Object> map) throws Exception {
		boolean result = false;
		try {
			
			int isLiked = mapper.isLiked(map);
			
			if(isLiked > 0) {
				mapper.deleteProductLike(map);
				result = false;
			} else {
				mapper.insertProductLike(map);
				result = true;
			}
			
		} catch (Exception e) {
			log.info("insertProductLike : ", e);
			throw e;
		}
		
		return result;
	}

	@Override
	public void deleteProductLike(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteProductLike(map);
			productMapper.updateLikeCount(map);
		} catch (Exception e) {
			log.info("deleteProductLike : ", e);
			throw e;
		}
		
	}

	@Override
	public boolean isLiked(Map<String, Object> map) throws Exception {
		return mapper.isLiked(map) > 0;
	}

}
