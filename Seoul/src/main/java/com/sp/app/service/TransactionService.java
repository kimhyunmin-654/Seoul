package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.sp.app.model.BuyerCandidate;
import com.sp.app.model.Member;
import com.sp.app.model.Product;
import com.sp.app.model.PurchaseItem;
import com.sp.app.model.ReviewView;
import com.sp.app.model.TransactionReview;

public interface TransactionService {
    public List<Product> listProductBySeller(Map<String, Object> map);
    public int dataCount(Map<String, Object> map);
    public int updateProductStatus(Map<String, Object> map);
    
    public List<BuyerCandidate> listBuyersForProduct(Map<String, Object> map);
    public boolean completeSale(long product_id, long room_id, long seller_id, long buyer_id);
    public Product findProductById(@Param("product_id") Long product_id);
    
	public List<PurchaseItem> listPurchasesByBuyer(Map<String, Object> map);
	public int dataCount2(Map<String, Object> map);
    
    // ===== 후기 =====
    public int writeReview(TransactionReview dto);
    public TransactionReview getReviewByChatId(Long chat_id);
    public int hasReview(Long chat_id);
    public List<TransactionReview> getReviewsByProductId(Long product_id);	
    
	public int countReviewByWriter(Map<String, Object> map);
	public List<ReviewView> listReviewByWriter(Map<String, Object> map);
	
	public int countReviewBySeller(Map<String, Object> map);
	public List<ReviewView> listReviewBySeller(Map<String, Object> map);
	
	
}
