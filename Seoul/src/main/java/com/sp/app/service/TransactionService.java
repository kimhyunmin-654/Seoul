package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.sp.app.model.BuyerCandidate;
import com.sp.app.model.Product;

public interface TransactionService {
    public List<Product> listProductBySeller(Map<String, Object> map);
    public int dataCount(Map<String, Object> map);
    public int updateProductStatus(Map<String, Object> map);
    
    public List<BuyerCandidate> listBuyersForProduct(Map<String, Object> map);
    public boolean completeSale(long product_id, long room_id, long seller_id, long buyer_id);
    public Product findProductById(@Param("product_id") Long product_id);
    
}
