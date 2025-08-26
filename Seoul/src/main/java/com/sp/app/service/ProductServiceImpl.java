package com.sp.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;
import com.sp.app.mapper.AuctionMapper;
import com.sp.app.mapper.TradeMapper;
import com.sp.app.model.Auction;
import com.sp.app.model.Category;
import com.sp.app.model.Product;
import com.sp.app.model.ProductImage;
import com.sp.app.model.Region;
import com.sp.app.model.SearchCondition;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ProductServiceImpl implements ProductService {

    private final PaginateUtil paginateUtil;
	private final TradeMapper tradeMapper;
	private final AuctionMapper auctionMapper;
	private final StorageService storageService;
	private final MyUtil myUtil;
	private final TradeMapper mapper;

	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Long> insertProduct(Product dto, List<MultipartFile> addFiles, Integer thumbnailIndex, String path) throws Exception {
		Map<String, Long> idMap = new HashMap<>();
		
		try {
			String thumbnailFilename = null;
			if(addFiles != null && !addFiles.isEmpty()) {
				
				int index = (thumbnailIndex != null) ? thumbnailIndex.intValue() : 0;
				if(index < 0 || index >= addFiles.size()) index = 0;
				
				MultipartFile thumbFile = addFiles.get(index);
				if(thumbFile != null && !thumbFile.isEmpty()) {
					thumbnailFilename = storageService.uploadFileToServer(thumbFile, path);
					dto.setThumbnail(thumbnailFilename);
				}
			}
			
			tradeMapper.insertProduct(dto);
			idMap.put("product_id", dto.getProduct_id());
			
			if(addFiles != null && addFiles.size() > 1) {
				int cnt = 1;
				for(int i=0; i< addFiles.size(); i++) {
					MultipartFile mf = addFiles.get(i);
					if(thumbnailIndex != null && i == thumbnailIndex) {
						continue;
					}
					
					String filename = storageService.uploadFileToServer(mf, path);
					
					ProductImage imageDto = new ProductImage();
					imageDto.setProduct_id(dto.getProduct_id());
					imageDto.setFilename(filename);
					imageDto.setFilesize(mf.getSize());
					imageDto.setImage_order(cnt++);
					
					tradeMapper.insertProductFile(imageDto);
				}
			}
			
			if(dto.getType().equalsIgnoreCase("auction")) {
				
				Auction auctionDto = new Auction();
				auctionDto.setStart_price(dto.getStart_price());
				auctionDto.setCurrent_price(dto.getStart_price());
				auctionDto.setEnd_time(dto.getEnd_time());
				auctionDto.setStatus("IN_PROGRESS");
				auctionDto.setProduct_id(dto.getProduct_id());
						
				auctionMapper.insertAuction(auctionDto);
				idMap.put("auction_id", auctionDto.getAuction_id());
			}
			
			return idMap;
		} catch (Exception e) {
			log.info("insertProduct : ", e);
			throw e;
		}
		
	}


	@Override
	@Transactional(rollbackFor = Exception.class)
	public void updateProduct(Product dto, List<MultipartFile> addFiles, List<Long> deleteImageIds, List<String> deleteFilename, String oldThumbnailToMove, Long imageIdToPromote, String path, int thumbnailIndex) throws Exception {
		
		try {
			Product oldDto = tradeMapper.findById(dto.getProduct_id());
			if(oldDto == null) {
				throw new RuntimeException("수정할 상품이 존재하지 않습니다.");
			}
			
			String newThumbnail = dto.getThumbnail();
			
			
			if(addFiles != null && !addFiles.isEmpty()) {
				
				for(int i=0; i< addFiles.size(); i++) {
					
					MultipartFile mf = addFiles.get(i);
					
					if(mf.isEmpty()) {
						continue;
					}
									
					String filename = storageService.uploadFileToServer(mf, path);
					
					if(i == thumbnailIndex && thumbnailIndex >= 0 && imageIdToPromote == null) {
						newThumbnail = filename;
						
						continue;
					}
					
					ProductImage imageDto = new ProductImage();
					imageDto.setProduct_id(dto.getProduct_id());
					imageDto.setFilename(filename);
					imageDto.setFilesize(mf.getSize());
					imageDto.setImage_order(i);	
					
					tradeMapper.insertProductFile(imageDto);
				}
			}
			
			
			if(imageIdToPromote != null) {
				
				ProductImage promotedImage = tradeMapper.findImageById(imageIdToPromote);
				
				if(promotedImage != null) {
					newThumbnail = promotedImage.getFilename();
					
					tradeMapper.deleteProductImage(imageIdToPromote);
					
					if(oldThumbnailToMove != null && !oldThumbnailToMove.isEmpty()) {
						
						ProductImage oldThumbnailImage = new ProductImage();
						oldThumbnailImage.setProduct_id(dto.getProduct_id());
						oldThumbnailImage.setFilename(oldThumbnailToMove);
						oldThumbnailImage.setFilesize(0L);
						oldThumbnailImage.setImage_order(99);
						
						tradeMapper.insertProductFile(oldThumbnailImage);
					}
					
				}
			
			} else if(thumbnailIndex >= 0 && oldThumbnailToMove != null && !oldThumbnailToMove.isEmpty()) {
				ProductImage oldThumbnailImage = new ProductImage();
				oldThumbnailImage.setProduct_id(dto.getProduct_id());
				oldThumbnailImage.setFilename(oldThumbnailToMove);
				oldThumbnailImage.setFilesize(0L);
				oldThumbnailImage.setImage_order(99);
				
				tradeMapper.insertProductFile(oldThumbnailImage);
		
			}
			
			
			if(deleteImageIds != null && deleteFilename != null) {
				
				for(int i = 0; i < deleteImageIds.size() && i < deleteFilename.size(); i++) {
					String filename = deleteFilename.get(i);
					
					if(filename.equals(newThumbnail)) {
						continue;
					}

					long image_id = deleteImageIds.get(i);
					
					storageService.deleteFile(path, filename);
					
					tradeMapper.deleteProductImage(image_id);
				}
				
			}
			
			if(deleteFilename != null) {
				for(String filename : deleteFilename) {
					
					if(filename.equals(newThumbnail)) {
						continue;
					}
					
					boolean alreadyProcessed = false;
					if(deleteImageIds != null) {
						for(int i = 0; i < deleteImageIds.size() && i < deleteFilename.size(); i++) {
							if(filename.equals(deleteFilename.get(i))) {
								alreadyProcessed = true;
								break;								
							}
						}
					}
					
					if(!alreadyProcessed) {
						storageService.deleteFile(path, filename);
					}
				}
			}
			
			dto.setThumbnail(newThumbnail);
			tradeMapper.updateProduct(dto);
			
				
		} catch (Exception e) {
			throw e;
		}
		
	}


	@Override
	@Transactional(rollbackFor = Exception.class)
	public void deleteProduct(long product_id, long member_id, String pathname) throws Exception {
		
		try {
			Product dto = tradeMapper.findById(product_id);
			
			if(dto == null) {
				throw new RuntimeException("존재하지 않는 상품입니다.");
			}
			
			if(member_id != dto.getMember_id()) {
				throw new RuntimeException("삭제 권한이 없습니다.");
			}
			
			List<ProductImage> imageList = tradeMapper.listProductImages(product_id);
			
			tradeMapper.deleteProductAllImages(product_id);
			tradeMapper.deleteProduct(product_id);

			// 썸네일을 서버에서 삭제
			if(dto.getThumbnail() != null && !dto.getThumbnail().isEmpty()) {
				storageService.deleteFile(pathname, dto.getThumbnail());
			}
			
			// 추가이미지를 서버에서 삭제
			if(imageList != null && !imageList.isEmpty()) {				
				for(ProductImage image : imageList) {
					storageService.deleteFile(pathname, image.getFilename());
				}
			}
			
			
		} catch (Exception e) {
			log.info("deleteProduct : ", e);
			throw e;
		}
		
	}

	// 추가 이미지 선택 삭제
	@Override
	public void deleteProductImage(long image_id, String path) throws Exception {
		try {
			if (path != null && ! path.isBlank()) {
				storageService.deleteFile(path);
			}

			tradeMapper.deleteProductImage(image_id);
		} catch (Exception e) {
			log.info("deleteProductFile : ", e);
			
			throw e;
		}
	}


	@Override
	public Map<String, Object> listProduct(SearchCondition cond) {
		
		Map<String, Object> map = new HashMap<>();

		try {
			
			cond.setType("NORMAL");
			
			int size = cond.getSize();
			int dataCount = this.dataCount(cond);
			int total_page = paginateUtil.pageCount(dataCount, size);
			int current_page = cond.getPage();
			
			if (total_page == 0) total_page = 1;
			if(current_page > total_page) current_page = total_page;

			int offset = (current_page - 1) * size;
			cond.setOffset(offset);
			
			
			String listUrl = "/product/list";
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
					
			List<Product> list = tradeMapper.listProduct(cond);
			
			map.put("list", list);
			map.put("paging", paging);
			map.put("dataCount", dataCount);
			map.put("totalPage", total_page);
			map.put("page", current_page);
			

		} catch (Exception e) {
			log.info("listProduct : ", e);
		}
			return map;
	}


	@Override
	public Product findById(long product_id) {
		Product dto = null;
		
		try {
			
			dto = Objects.requireNonNull(tradeMapper.findById(product_id));
			
			dto.setContent(myUtil.htmlSymbols(dto.getContent()));
			
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("findById : ", e);
		}
		
		return dto;
	}


	@Override
	public int dataCount(SearchCondition cond) {
		return tradeMapper.dataCount(cond);
	}


	@Override
	public List<ProductImage> listProductImage(long product_id) {
		List<ProductImage> list = null;
		
		try {
			list = tradeMapper.listProductImages(product_id);
		} catch (Exception e) {
			log.info("listProductImage : ", e);
		}
		
		return list;
	}


	@Override
	public List<Category> listCategories() {
		return tradeMapper.listCategory();
	}


	@Override
	public List<Region> listRegion() {
		return tradeMapper.listRegion();
	}


	@Override
	public void updateHitCount(long product_id) {
		
		try {
			tradeMapper.updateHitCount(product_id);
			
		} catch (Exception e) {
			log.info("updateHitCount : ", e);
		}
		
	}


	@Override
	public List<Product> findByMemberId(long member_id) {
        return mapper.findByMemberId(member_id);
    }


	

}
