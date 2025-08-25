package com.sp.app.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sp.app.model.BuyerCandidate;
import com.sp.app.model.Product;
import com.sp.app.model.ProductTransaction;
import com.sp.app.model.PurchaseItem;
import com.sp.app.model.ReviewView;
import com.sp.app.model.TransactionReview;

@Mapper
public interface TransactionMapper {
	public List<Product> listProductBySeller(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	public int updateProductStatus(Map<String, Object> map);
	
	public List<BuyerCandidate> listBuyersForProduct(Map<String, Object> map);
	public int insertTransaction(ProductTransaction dto);
	public Product findProductById(@Param("product_id") Long product_id);
	
	public List<PurchaseItem> listPurchasesByBuyer(Map<String, Object> map);
	public int dataCount2(Map<String, Object> map);
	
	// Transaction Review
	public int insertReview(TransactionReview dto);
	public TransactionReview findReviewByChatId(Long chat_id);
	public int existsReviewByChatId(Long chat_id);
	public List<TransactionReview> listReviewByProductId(Long product_id);
	
	public int countReviewByWriter(Map<String, Object> map);
	public List<ReviewView> listReviewByWriter(Map<String, Object> map);
	 
	public int countReviewBySeller(Map<String, Object> map);
	public List<ReviewView> listReviewBySeller(Map<String, Object> map);
}
