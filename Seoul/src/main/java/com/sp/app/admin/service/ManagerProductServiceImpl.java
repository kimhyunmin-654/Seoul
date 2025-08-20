package com.sp.app.admin.service;

import java.util.HashMap;
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
            dto.setProductNum(product_num);

            mapper.insertProduct(dto);

            if (dto.getAddFiles() != null && !dto.getAddFiles().isEmpty()) {
                insertProductFile(dto, uploadPath);
            }
        } catch (Exception e) {
            log.info("insertProduct : ", e);
            throw e;
        }
    }

    private void insertProductFile(ManagerProduct dto, String uploadPath) throws Exception {
        for (MultipartFile mf : dto.getAddFiles()) {
            try {
                if (mf == null || mf.isEmpty()) continue;
                String saveFilename = Objects.requireNonNull(storageService.uploadFileToServer(mf, uploadPath));
                dto.setFilename(saveFilename);
                dto.setFilesize(mf.getSize());
                mapper.insertProductFile(dto);
            } catch (NullPointerException | StorageException e) {
                log.info("insertProductFile (skip one file) : ", e);
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
                if (dto.getThumbnail() != null && !dto.getThumbnail().isBlank()) {
                    deleteUploadFile(uploadPath, dto.getThumbnail());
                }
                dto.setThumbnail(filename);
            }

            mapper.updateProduct(dto);

            if (dto.getAddFiles() != null && !dto.getAddFiles().isEmpty()) {
                insertProductFile(dto, uploadPath);
            }
        } catch (Exception e) {
            log.info("updateProduct : ", e);
            throw e;
        }
    }

    @Override
    public void updateProductDisplayOrder(Map<String, Object> map) throws Exception {
        try {
            mapper.updateProductDisplayOrder(map);
        } catch (Exception e) {
            log.info("updateProductDisplayOrder : ", e);
            throw e;
        }
    }

    @Transactional(rollbackFor = {Exception.class})
    @Override
    public void deleteProduct(long productNum, String uploadPath) throws Exception {
        try {
            ManagerProduct cur = mapper.findById(productNum);
            if (cur != null && cur.getThumbnail() != null && !cur.getThumbnail().isBlank()) {
                deleteUploadFile(uploadPath, cur.getThumbnail());
            }

            List<ManagerProduct> files = mapper.listProductFile(productNum);
            for (ManagerProduct f : files) {
                if (f.getFilename() != null && !f.getFilename().isBlank()) {
                    deleteUploadFile(uploadPath, f.getFilename());
                }
            }

            mapper.deleteProduct(productNum);
        } catch (Exception e) {
            log.info("deleteProduct : ", e);
            throw e;
        }
    }

    @Override
	public void deleteProductFile(long fileNum, String pathString) throws Exception {
		try {
			if (pathString != null && ! pathString.isBlank()) {
				storageService.deleteFile(pathString);
			}

			mapper.deleteProductFile(fileNum);
		} catch (Exception e) {
			log.info("deleteProductFile : ", e);
			
			throw e;
		}
	}

    @Override
    public void deleteOptionDetail(long detailNum) throws Exception {
        try {
            mapper.deleteOptionDetail(detailNum);
        } catch (Exception e) {
            log.info("deleteOptionDetail : ", e);
            throw e;
        }
    }

    @Override
    public int dataCount(Map<String, Object> map) {
        int result = 0;
        try {
            result = mapper.dataCount(map);
        } catch (Exception e) {
            log.info("dataCount : ", e);
        }
        return result;
    }

    @Override
    public List<ManagerProduct> listProduct(Map<String, Object> map) {
        List<ManagerProduct> list = null;
        try {
            list = mapper.listProduct(map);
        } catch (Exception e) {
            log.info("listProduct : ", e);
        }
        return list;
    }

    @Override
    public ManagerProduct findById(long productNum) {
        ManagerProduct dto = null;
        try {
            dto = mapper.findById(productNum);
        } catch (Exception e) {
            log.info("findById : ", e);
        }
        return dto;
    }

    @Override
    public ManagerProduct findByPrev(Map<String, Object> map) {
       return null;
    }

    @Override
    public ManagerProduct findByNext(Map<String, Object> map) {
    	return null;
    }

    @Override
    public List<ManagerProduct> listProductFile(long productNum) {
        List<ManagerProduct> list = null;
        try {
            list = mapper.listProductFile(productNum);
        } catch (Exception e) {
            log.info("listProductFile : ", e);
        }
        return list;
    }

    @Override
    public List<ManagerProduct> listProductOption(long productNum) {
        List<ManagerProduct> list = null;
        try {
            list = mapper.listProductOption(productNum);
        } catch (Exception e) {
            log.info("listProductOption : ", e);
        }
        return list;
    }

    @Override
    public List<ManagerProduct> listOptionDetail(long optionNum) {
        List<ManagerProduct> list = null;
        try {
            list = mapper.listOptionDetail(optionNum);
        } catch (Exception e) {
            log.info("listOptionDetail : ", e);
        }
        return list;
    }

    @Override
    public ManagerProduct findByCategory(long categoryNum) {
        ManagerProduct dto = null;
        try {
            dto = mapper.findByCategory(categoryNum);
        } catch (Exception e) {
            log.info("findByCategory : ", e);
        }
        return dto;
    }

    @Override
    public List<ManagerProduct> listCategory() {
        List<ManagerProduct> list = null;
        try {
            list = mapper.listCategory();
        } catch (Exception e) {
            log.info("listCategory : ", e);
        }
        return list;
    }

    @Override
    public List<ManagerProduct> listSubCategory(long parentNum) {
        List<ManagerProduct> list = null;
        try {
            list = mapper.listSubCategory(parentNum);
        } catch (Exception e) {
            log.info("listSubCategory : ", e);
        }
        return list;
    }

    @Override
    public void updateProductStock(ManagerProductStock dto) throws Exception {
        try {
            mapper.updateProductStock(dto);
        } catch (Exception e) {
            log.info("updateProductStock : ", e);
            throw e;
        }
    }

    @Override
    public List<ManagerProductStock> listProductStock(long productNum) {
        List<ManagerProductStock> list = null;
        try {
            Map<String, Object> map = new HashMap<>();
            map.put("productNum", productNum);
            list = mapper.listProductStock(map);
        } catch (Exception e) {
            log.info("listProductStock : ", e);
        }
        return list;
    }

    @Override
    public boolean deleteUploadFile(String uploadPath, String filename) {
        boolean result = false;
        try {
            result = storageService.deleteFile(uploadPath, filename);
        } catch (Exception e) {
            log.info("deleteUploadFile : ", e);
        }
        return result;
    }
}