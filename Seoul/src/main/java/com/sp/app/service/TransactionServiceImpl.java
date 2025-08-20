package com.sp.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.mapper.TransactionMapper;
import com.sp.app.model.BuyerCandidate;
import com.sp.app.model.Product;
import com.sp.app.model.ProductTransaction;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class TransactionServiceImpl implements TransactionService {
	private final TransactionMapper transactionMapper;
		
	@Override
	public List<Product> listProductBySeller(Map<String, Object> map) {
		List<Product> list = null;
		
		try {
			list = transactionMapper.listProductBySeller(map);
		} catch (Exception e) {
			log.info("listProductBySeller : ", e);
		}
		
		return list;
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		int result = 0;
		try {
			result = transactionMapper.dataCount(map);
		} catch (Exception e) {
			log.info("dataCount : ", e);
		}
		
		return result;
	}

	@Transactional(rollbackFor = {Exception.class})
	@Override
	public int updateProductStatus(Map<String, Object> map) {
	    try {
	        return transactionMapper.updateProductStatus(map);
	    } catch (Exception e) {
	        log.info("updateProductStatus", e);
	        return 0;
	    }
	}

	@Override
	public List<BuyerCandidate> listBuyersForProduct(Map<String, Object> map) {
		List<BuyerCandidate> list = null;
		try {
			list = transactionMapper.listBuyersForProduct(map);
		} catch (Exception e) {
			log.info("listBuyersForProduct", e);
		}
		return list;
	}
	
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean completeSale(long product_id, long room_id, long seller_id, long buyer_id) {
        try {
            Product p = transactionMapper.findProductById(product_id);
            if (p == null) {
                log.info("completeSale", product_id);
                return false;
            }
            if (p.getMember_id() != seller_id) {
                log.info("completeSale", p.getMember_id(), seller_id);
                return false;
            }

            Map<String, Object> map = new HashMap<>();
            map.put("product_id", product_id);
            map.put("seller_id", seller_id);
            List<BuyerCandidate> candidates = transactionMapper.listBuyersForProduct(map);

            boolean match = candidates.stream().anyMatch(b ->
                b != null
                && b.getBuyer_id() != null
                && b.getRoom_id() != null
                && Objects.equals(b.getBuyer_id().longValue(), buyer_id)
                && Objects.equals(b.getRoom_id().longValue(), room_id)
            );

            if (!match) {
                log.info("completeSale", product_id, room_id, buyer_id);
                return false;
            }

            ProductTransaction tx = ProductTransaction.builder()
                    .product_id(product_id)
                    .room_id(room_id)
                    .seller_id(seller_id)
                    .buyer_id(buyer_id)
                    .status("확정")
                    .build();

            transactionMapper.insertTransaction(tx);

            Map<String, Object> upd = new HashMap<>();
            upd.put("product_id", product_id);
            upd.put("member_id", seller_id);
            upd.put("status", "판매완료");

            int updated = transactionMapper.updateProductStatus(upd);
            if (updated == 0) {
                throw new RuntimeException("상품 상태 변경 실패 (업데이트된 행 없음)");
            }

            return true;

        } catch (DuplicateKeyException dke) {
            return false;
        } catch (RuntimeException re) {
            throw re;
        } catch (Exception e) {
            log.info("completeSale", e);
            throw new RuntimeException(e);
        }
    }

	@Override
	public Product findProductById(Long product_id) {
		Product dto = null;
		try {
			dto = transactionMapper.findProductById(product_id);
		} catch (Exception e) {
			log.info("findProductById", e);
		}
		
		return dto;
	}

}
