package com.sp.app.admin.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.admin.model.ManagerProduct;
import com.sp.app.admin.model.ManagerProductStock;

@Mapper
public interface ManagerProductMapper {
	public long productSeq();
	public void insertProduct(ManagerProduct dto) throws SQLException;
	public void insertProductFile(ManagerProduct dto) throws SQLException;
	
	public long optionSeq();
	public void insertProductOption(ManagerProduct dto) throws SQLException;

	public long detailSeq();
	public void insertOptionDetail(ManagerProduct dto) throws SQLException;

	public ManagerProduct findByCategory(long category_num);
	public List<ManagerProduct> listCategory();
	public List<ManagerProduct> listSubCategory(long parent_num);
	
	public int dataCount(Map<String, Object> map);
	public List<ManagerProduct> listProduct(Map<String, Object> map);
	public ManagerProduct findById(long productNum);
	public List<ManagerProduct> listProductFile(long product_num);
	public List<ManagerProduct> listProductOption(long product_num);
	public List<ManagerProduct> listOptionDetail(long option_num);
	
	public void updateProduct(ManagerProduct dto) throws SQLException;
	public void deleteProduct(long product_num) throws SQLException;
	public void deleteProductFile(long file_num) throws SQLException;
	public void updateProductOption(ManagerProduct dto) throws SQLException;
	public void deleteProductOption(long option_num) throws SQLException;
	public void updateOptionDetail(ManagerProduct dto) throws SQLException;
	public void deleteOptionDetail(long detail_num) throws SQLException;
	public void updateProductDisplayOrder(Map<String, Object> map) throws SQLException;
	
	public void insertProductStock(ManagerProductStock dto) throws SQLException;
	public void updateProductStock(ManagerProductStock dto) throws SQLException;
	public List<ManagerProductStock> listProductStock(Map<String, Object> map);	
}
