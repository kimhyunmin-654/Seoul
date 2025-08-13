package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.admin.mapper.ManagerProductMapper;
import com.sp.app.admin.model.ManagerProduct;
import com.sp.app.admin.model.ManagerProductStock;
import com.sp.app.common.StorageService;
import com.sp.app.exception.StorageException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ManagerProductServiceImpl implements ManagerProductService {
	private final ManagerProductMapper mapper;
	private final StorageService storageService;
	
	@Transactional(rollbackFor = {Exception.class})
	@Override
	public void insertProduct(ManagerProduct dto, String uploadPath) throws Exception {
		try {
			String filename = storageService.uploadFileToServer(dto.getThumbnailFile(), uploadPath);
			dto.setThumbnail(filename);
			
			long product_num = mapper.productSeq();
			dto.setProduct_num(product_num);
			mapper.insertProduct(dto);
			
			// 추가 이미지 저장
			if (! dto.getAddFiles().isEmpty()) {
				insertProductFile(dto, uploadPath);
			}
			
		} catch (Exception e) {
			log.info("insertProduct: ", e);
			
			throw e;
		}
	}
	
	private void insertProductFile(ManagerProduct dto, String uploadPath) throws Exception {
		for (MultipartFile mf : dto.getAddFiles()) {
			try {
				String saveFilename = Objects.requireNonNull(storageService.uploadFileToServer(mf, uploadPath));
				dto.setFilename(saveFilename);
				
				mapper.insertProductFile(dto);
			} catch (NullPointerException e) {
			} catch (StorageException e) {
			} catch (Exception e) {
				throw e;
			}
		}
	}

	@Transactional(rollbackFor = {Exception.class})
	@Override
	public void updateProduct(ManagerProduct dto, String uploadPath) throws Exception {
		try {
			String filename = storageService.uploadFileToServer(dto.getThumbnailFile(), uploadPath);
			if (filename != null) {
				if (! dto.getThumbnail().isBlank()) {
					deleteUploadFile(uploadPath, dto.getThumbnail());
				}
				
				dto.setThumbnail(filename);
			}
			
			mapper.updateProduct(dto);
			
			if (! dto.getAddFiles().isEmpty()) {
				insertProductFile(dto, uploadPath);
			}
			
		} catch (Exception e) {
			log.info("updateProduct: ", e);
		}
		
	}

	@Override
	public void updateProductDisplayOrder(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteProduct(long product_num, String uploadPath) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteProductFile(long file_num, String pathString) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteOptionDetail(long detail_num) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<ManagerProduct> listProduct(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ManagerProduct findById(long product_num) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ManagerProduct findByPrev(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ManagerProduct findByNext(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ManagerProduct> listProductFile(long product_num) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ManagerProduct> listProductOption(long product_num) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ManagerProduct> listOptionDetail(long option_num) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ManagerProduct findByCategory(long category_num) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ManagerProduct> listCategory() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ManagerProduct> listSubCategory(long parent_num) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateProductStock(ManagerProductStock dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<ManagerProductStock> listProductStock(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean deleteUploadFile(String uploadPath, String filename) {
		// TODO Auto-generated method stub
		return false;
	}

}