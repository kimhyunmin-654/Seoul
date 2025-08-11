package com.sp.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

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

    private final PaginateUtil paginateUtil;
	private final ProductMapper productMapper;
	private final AuctionMapper auctionMapper;
	private final StorageService storageService;

	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public void insertProduct(Product dto, List<MultipartFile> selectFile, String path) throws Exception {
		
		try {
			
			String thumbnailFilename = null;
			if(selectFile != null && !selectFile.isEmpty()) {
				
				MultipartFile firstFile = selectFile.get(0);
				if(!firstFile.isEmpty()) {
					thumbnailFilename = storageService.uploadFileToServer(firstFile, path);
					dto.setThumbnail(thumbnailFilename);
				}
			}
			
			productMapper.insertProduct(dto);
			
			if(selectFile != null && selectFile.size() > 1) {
				for(int i=1; i< selectFile.size(); i++) {
					MultipartFile mf = selectFile.get(i);
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
	public void updateProduct(Product dto) throws Exception {
		// TODO Auto-generated method stub
		
	}


	@Override
	public void deleteProduct(long product_id) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public void deleteProductImage(long image_id) {
		// TODO Auto-generated method stub
		
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


}
