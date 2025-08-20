package com.sp.app.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sp.app.model.BuyerCandidate;
import com.sp.app.model.Product;
import com.sp.app.model.ProductTransaction;

@Mapper
public interface TransactionMapper {
	public List<Product> listProductBySeller(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	public int updateProductStatus(Map<String, Object> map);
	
	public List<BuyerCandidate> listBuyersForProduct(Map<String, Object> map);
	public int insertTransaction(ProductTransaction dto);
	public Product findProductById(@Param("product_id") Long product_id);
	
}
