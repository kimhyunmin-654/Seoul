package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import com.sp.app.admin.model.ManagerProduct;
import com.sp.app.admin.model.ManagerProductStock;

public interface ManagerProductService {
	public void insertProduct(ManagerProduct dto, String uploadPath) throws Exception;
	public void updateProduct(ManagerProduct dto, String uploadPath) throws Exception;
	public void updateProductDisplayOrder(Map<String, Object> map) throws Exception;
	public void deleteProduct(long product_num, String uploadPath) throws Exception;
	public void deleteProductFile(long file_num, String pathString) throws Exception;
	public void deleteOptionDetail(long detail_num) throws Exception;
	
	public int dataCount(Map<String, Object> map);
	public List<ManagerProduct> listProduct(Map<String, Object> map);
	
	public ManagerProduct findById(long product_num);
	public ManagerProduct findByPrev(Map<String, Object> map);
	public ManagerProduct findByNext(Map<String, Object> map);
	
	public List<ManagerProduct> listProductFile(long product_num);
	public List<ManagerProduct> listProductOption(long product_num);
	public List<ManagerProduct> listOptionDetail(long option_num);
	
	public ManagerProduct findByCategory(long category_num);
	public List<ManagerProduct> listCategory();
	public List<ManagerProduct> listSubCategory(long parent_num);
	
	public void updateProductStock(ManagerProductStock dto) throws Exception;
	public List<ManagerProductStock> listProductStock(Map<String, Object> map);
	
	public boolean deleteUploadFile(String uploadPath, String filename);
}