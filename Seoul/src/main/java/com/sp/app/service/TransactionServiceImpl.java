package com.sp.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.common.StorageService;
import com.sp.app.mapper.TransactionMapper;
import com.sp.app.model.BuyerCandidate;
import com.sp.app.model.Product;
import com.sp.app.model.ProductImage;
import com.sp.app.model.ProductTransaction;
import com.sp.app.model.PurchaseItem;
import com.sp.app.model.ReviewView;
import com.sp.app.model.TransactionReview;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class TransactionServiceImpl implements TransactionService {
	private final TransactionMapper transactionMapper;
	private final StorageService storageService;
		
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

	@Override
	public List<PurchaseItem> listPurchasesByBuyer(Map<String, Object> map) {
		List<PurchaseItem> list = null;
		try {
			list = transactionMapper.listPurchasesByBuyer(map);
		} catch (Exception e) {
			log.info("listPurchasesByBuyer", e);
		}
		
		return list;
	}

	@Override
	public int dataCount2(Map<String, Object> map) {
		int result = 0;
		try {
			result = transactionMapper.dataCount2(map);
		} catch (Exception e) {
			log.info("dataCount2", e);
		}
		
		return result;
	}
	
	
	@Transactional(rollbackFor = {Exception.class})
	@Override
	public int writeReview(TransactionReview dto) {
	    int result = 0;
	    try {
	        if (dto == null || dto.getChat_id() == null) {
	            log.info("writeReview: invalid dto or missing chat_id");
	            return 0;
	        }

	        if (transactionMapper.existsReviewByChatId(dto.getChat_id()) > 0) {
	            log.info("이미 작성된 리뷰: chat_id={}", dto.getChat_id());
	            return 0;
	        }

	        result = transactionMapper.insertReview(dto);
	    } catch (Exception e) {
	        log.info("writeReview : ", e);
	    }
	    return result;
	}

    @Override
    public TransactionReview getReviewByChatId(Long chat_id) {
    	TransactionReview review = null;
    	try {
			review = transactionMapper.findReviewByChatId(chat_id);
		} catch (Exception e) {
			log.info("getReviewByChatId : ", e);
		}
    	return review;
    }

    @Override
    public int hasReview(Long chat_id) {
    	int count = 0;
    	try {
    		count = transactionMapper.existsReviewByChatId(chat_id);
		} catch (Exception e) {
			log.info("hasReview : ", e);
		}
    	return count;
    }

    @Override
    public List<TransactionReview> getReviewsByProductId(Long product_id) {
    	List<TransactionReview> list = null;
    	try {
    		list = transactionMapper.listReviewByProductId(product_id);
		} catch (Exception e) {
			log.info("getReviewsByProductId : ", e);

		}
    	return list;
    }

	@Override
	public int countReviewByWriter(Map<String, Object> map) {
		int result = 0;
		try {
			result = transactionMapper.countReviewByWriter(map);
		} catch (Exception e) {
			log.info("countReviewByWriter : ", e);
		}
		
		return result;
	}

	@Override
	public List<ReviewView> listReviewByWriter(Map<String, Object> map) {
		List<ReviewView> list = null;
		try {
			list = transactionMapper.listReviewByWriter(map);
		} catch (Exception e) {
			log.info("listReviewByWriter : ", e);
		}
		
		return list;
	}

	@Override
	public int countReviewBySeller(Map<String, Object> map) {
		int result = 0;
		try {
			result = transactionMapper.countReviewBySeller(map);
		} catch (Exception e) {
			log.info("countReviewBySeller : ", e);
		}
		return result;
	}

	@Override
	public List<ReviewView> listReviewBySeller(Map<String, Object> map) {
			List<ReviewView> list = null;
			try {
				list = transactionMapper.listReviewBySeller(map);
			} catch (Exception e) {
				log.info("listReviewBySeller : ", e);
			}
		return list;
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void deleteProductImages(long product_id, String pathString) throws Exception {
	    try {
	        List<ProductImage> imageList = transactionMapper.listProductImages(product_id);

	        transactionMapper.deleteProductImages(product_id);

	        if (imageList != null && !imageList.isEmpty() && pathString != null && !pathString.isBlank()) {
	            for (ProductImage img : imageList) {
	                if (img == null) continue;
	                String fname = img.getFilename();
	                if (fname == null || fname.isBlank()) continue;
	                try {
	                    storageService.deleteFile(pathString, fname);
	                } catch (Exception e) {
	                }
	            }
	        }
	    } catch (Exception e) {
	        log.info("deleteProductImages : ", e);
	        throw e;
	    }
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void deleteProduct(long product_id, long member_id, String uploadPath) throws Exception {
	    try {
	        Product dto = transactionMapper.findProductById(product_id);
	        if (dto == null) {
	            throw new RuntimeException("존재하지 않는 상품입니다.");
	        }
	        if (!Objects.equals(dto.getMember_id(), member_id)) {
	            throw new RuntimeException("삭제 권한이 없습니다.");
	        }

	        List<ProductImage> imageList = transactionMapper.listProductImages(product_id);

	        transactionMapper.deleteProductImages(product_id);
	        transactionMapper.deleteProduct(product_id);

	        if (dto.getThumbnail() != null && !dto.getThumbnail().isEmpty()
	                && uploadPath != null && !uploadPath.isBlank()) {
	            try {
	                storageService.deleteFile(uploadPath, dto.getThumbnail());
	            } catch (Exception e) {
	            }
	        }

	        if (imageList != null && !imageList.isEmpty()
	                && uploadPath != null && !uploadPath.isBlank()) {
	            for (ProductImage image : imageList) {
	                if (image == null) continue;
	                try {
	                    storageService.deleteFile(uploadPath, image.getFilename());
	                } catch (Exception e) {
	                }
	            }
	        }

	    } catch (Exception e) {
	        log.info("deleteProduct : ", e);
	        throw e;
	    }
	}
	

}
