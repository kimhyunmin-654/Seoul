package com.sp.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.sp.app.common.FileManager;
import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;
import com.sp.app.mapper.AuctionMapper;
import com.sp.app.mapper.ProductMapper;
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

    private final FileManager fileManager;

    private final PaginateUtil paginateUtil;
	private final ProductMapper productMapper;
	private final AuctionMapper auctionMapper;
	private final StorageService storageService;

	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public void insertProduct(Product dto, List<MultipartFile> addFiles, String path) throws Exception {
		
		try {
			
			String thumbnailFilename = null;
			if(addFiles != null && !addFiles.isEmpty()) {
				
				MultipartFile firstFile = addFiles.get(0);
				if(!firstFile.isEmpty()) {
					thumbnailFilename = storageService.uploadFileToServer(firstFile, path);
					dto.setThumbnail(thumbnailFilename);
				}
			}
			
			productMapper.insertProduct(dto);
			
			if(addFiles != null && addFiles.size() > 1) {
				for(int i=1; i< addFiles.size(); i++) {
					MultipartFile mf = addFiles.get(i);
					if(mf.isEmpty()) {
						continue;
					}
					
					String filename = storageService.uploadFileToServer(mf, path);
					
					ProductImage imageDto = new ProductImage();
					imageDto.setProduct_id(dto.getProduct_id());
					imageDto.setFilename(filename);
					imageDto.setFilesize(mf.getSize());
					imageDto.setImage_order(i);
					
					productMapper.insertProductFile(imageDto);
				}
			}
			
			if(dto.getType().equalsIgnoreCase("auction")) {
				Auction auctionDto = new Auction();
				auctionDto.setStart_price(dto.getStart_price());
				auctionDto.setCurrent_price(dto.getStart_price());
				auctionDto.setEnd_time(dto.getEnd_time());
				auctionDto.setStatus("IN_PROGRESS");
				auctionDto.setBidCount(0);
				auctionDto.setProduct_id(dto.getProduct_id());
				auctionDto.setProduct_name(dto.getProduct_name());
				auctionDto.setThumbnail(dto.getThumbnail());
				auctionDto.setSeller_id(dto.getMember_id());
				auctionDto.setSeller_nickName(dto.getNickName());
				
				auctionMapper.insertAuction(auctionDto);
			}
			
		} catch (Exception e) {
			log.info("insertProduct : ", e);
		}
		
	}


	@Override
	@Transactional(rollbackFor = Exception.class)
	public void updateProduct(Product dto, List<MultipartFile> addFiles, List<Long> deleteImageIds, List<String> deleteFilename, String oldThumbnailToMove, Long imageIdToPromote, String path) throws Exception {
		
		try {
			Product oldDto = productMapper.findById(dto.getProduct_id());
			if(oldDto == null) {
				throw new RuntimeException("수정할 상품이 존재하지 않습니다.");
			}
			
			if(imageIdToPromote != null && oldThumbnailToMove != null && !oldThumbnailToMove.isEmpty()) {
				productMapper.deleteProductImage(imageIdToPromote);
				
				ProductImage oldThumbnailImage = new ProductImage();
				oldThumbnailImage.setProduct_id(dto.getProduct_id());
				oldThumbnailImage.setFilename(oldThumbnailToMove);
				oldThumbnailImage.setFilesize(0L);
				oldThumbnailImage.setImage_order(99);
				
				productMapper.insertProductFile(oldThumbnailImage);
			}
			
			
			if(deleteImageIds != null && deleteFilename != null && deleteImageIds.size() == deleteFilename.size()) {
				
				for(int i = 0; i < deleteImageIds.size(); i++) {
					long image_id = deleteImageIds.get(i);
					String filename = deleteFilename.get(i);
					
					storageService.deleteFile(path, filename);
					
					productMapper.deleteProductImage(image_id);
				}
				
			}
			
			if(addFiles != null && !addFiles.isEmpty()) {
				
				for(int i=0; i< addFiles.size(); i++) {
					
					MultipartFile mf = addFiles.get(i);
					
					if(mf.isEmpty()) {
						continue;
					}
									
					String filename = storageService.uploadFileToServer(mf, path);
					ProductImage imageDto = new ProductImage();
					imageDto.setProduct_id(dto.getProduct_id());
					imageDto.setFilename(filename);
					imageDto.setFilesize(mf.getSize());
					imageDto.setImage_order(i);	
					
					productMapper.insertProductFile(imageDto);
				}
			}
			
			productMapper.updateProduct(dto);
			
				
		} catch (Exception e) {
			throw e;
		}
		
	}


	@Override
	@Transactional(rollbackFor = Exception.class)
	public void deleteProduct(long product_id, long member_id, String pathname) throws Exception {
		
		try {
			Product dto = productMapper.findById(product_id);
			
			if(dto == null) {
				throw new RuntimeException("존재하지 않는 상품입니다.");
			}
			
			if(member_id != dto.getMember_id()) {
				throw new RuntimeException("삭제 권한이 없습니다.");
			}
			
			List<ProductImage> imageList = productMapper.listProductImages(product_id);
			
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
			
			productMapper.deleteProductAllImages(product_id);
			productMapper.deleteProduct(product_id);
			
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

			productMapper.deleteProductImage(image_id);
		} catch (Exception e) {
			log.info("deleteProductFile : ", e);
			
			throw e;
		}
	}


	@Override
	public Map<String, Object> listProduct(SearchCondition cond) {
		
		Map<String, Object> map = new HashMap<>();

		try {
				
			int size = cond.getSize();
			int dataCount = this.dataCount(cond);
			int total_page = paginateUtil.pageCount(dataCount, size);
			int current_page = cond.getPage();
			
			if(current_page > total_page) current_page = total_page;

			int offset = (current_page - 1) * size;
			cond.setOffset(offset);
			
			
			String listUrl = "/product/list";
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
					
			List<Product> list = productMapper.listProduct(cond);
			
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
	public List<Auction> listAuction(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}


	@Override
	public Product findById(long product_id) {
		Product dto = null;
		
		try {
			
			dto = Objects.requireNonNull(productMapper.findById(product_id));
			
			if(dto != null && dto.getContent() != null) {
				dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
			}
			
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("findById : ", e);
		}
		
		return dto;
	}


	@Override
	public int dataCount(SearchCondition cond) {
		
		return productMapper.dataCount(cond);
	}


	@Override
	public List<ProductImage> listProductImage(long product_id) {
		List<ProductImage> list = null;
		
		try {
			list = productMapper.listProductImages(product_id);
		} catch (Exception e) {
			log.info("listProductImage : ", e);
		}
		
		return list;
	}


	@Override
	public List<Category> listCategories() {
		return productMapper.listCategory();
	}


	@Override
	public List<Region> listRegion() {
		return productMapper.listRegion();
	}


	@Override
	public void updateHitCount(long product_id) {
		
		try {
			productMapper.updateHitCount(product_id);
			
		} catch (Exception e) {
			log.info("updateHitCount : ", e);
		}
		
	}


	


	


}
