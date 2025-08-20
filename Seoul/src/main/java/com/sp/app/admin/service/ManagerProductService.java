package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import com.sp.app.admin.model.ManagerProduct;
import com.sp.app.admin.model.ManagerProductStock;

public interface ManagerProductService {
    void insertProduct(ManagerProduct dto, String uploadPath) throws Exception;
    void updateProduct(ManagerProduct dto, String uploadPath) throws Exception;
    void deleteProduct(long product_num, String uploadPath) throws Exception;

    void deleteProductFile(long file_num, String uploadPath) throws Exception;
    void deleteOptionDetail(long detail_num) throws Exception;

    void updateProductDisplayOrder(Map<String, Object> map) throws Exception;

    int dataCount(Map<String, Object> map);
    List<ManagerProduct> listProduct(Map<String, Object> map);

    ManagerProduct findById(long product_num);
    ManagerProduct findByPrev(Map<String, Object> map);
    ManagerProduct findByNext(Map<String, Object> map);

    List<ManagerProduct> listProductFile(long product_num);
    List<ManagerProduct> listProductOption(long product_num);
    List<ManagerProduct> listOptionDetail(long option_num);

    ManagerProduct findByCategory(long category_num);
    List<ManagerProduct> listCategory();
    List<ManagerProduct> listSubCategory(long parent_num);

    void updateProductStock(ManagerProductStock dto) throws Exception;
    List<ManagerProductStock> listProductStock(long productNum);

    boolean deleteUploadFile(String uploadPath, String filename);
}