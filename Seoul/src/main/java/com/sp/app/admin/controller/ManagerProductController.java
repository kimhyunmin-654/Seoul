package com.sp.app.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.admin.model.ManagerProduct;
import com.sp.app.admin.model.ManagerProductStock;
import com.sp.app.admin.service.ManagerProductService;
import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/admin/product/*")
public class ManagerProductController {
	private final ManagerProductService service;
	private final PaginateUtil paginateUtil;
	private final StorageService storageService;
	
	private String uploadPath;
	
	@PostConstruct
	public void init() {
		uploadPath = this.storageService.getRealPath("/uploads/product");		
	}	
	
	// @GetMapping(value = {})
	public String list() throws Exception {
		try {
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		return "";
	}
	
	// @GetMapping()
	public Map<String, ?> listSubCategory() throws Exception {
		Map<String, Object> model = new HashMap<String, Object>();
		try {
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return model;
	}
	
	@GetMapping("write")
	public String writeForm(Model model) {
		try {
			List<ManagerProduct> listCategory = service.listCategory();
			List<ManagerProduct> listSubCategory = null;
			long parent_num = 0;
			
			if (listCategory.size() > 0) {
				parent_num = listCategory.get(0).getCategory_num();
			}
			listSubCategory = service.listSubCategory(parent_num);
			
			model.addAttribute("mode", "write");
			model.addAttribute("listCategory", listCategory);
			model.addAttribute("listSubCategory", listSubCategory);
		} catch (Exception e) {
			log.info("writeForm: ", e);
		}
		
		return "admin/product/write";
	}
	
	@PostMapping("write")
	public String writeSubmit(ManagerProduct dto, Model model) {
		try {
			service.insertProduct(dto, uploadPath);
		} catch (Exception e) {
			log.info("writeSubmit: ", e);
		}
		
		return "redirect:/admin/product/main/parentNum=" + dto.getParent_num() + "&categoryNum=" + dto.getCategory_num();
	}
	
	// @GetMapping()
	public String article() {
		try {
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return "";
	}
	
	// @GetMapping()
	public String updateForm() {
		try {
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return "";
	}
	
	// @PostMapping()
	public String updateSubmit() {
		try {
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return "";
	}
	
	// @PostMapping()
	public Map<String, ?> deleteFile() throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		try {
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return model;
	}
	
	// AJAX-Text
	@GetMapping("listProductStock")
	public String listProductStock() throws Exception {
		try {
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return "";
	}
	
	@ResponseBody
	@PostMapping("updateProductStock")
	public Map<String, ?> updateProductStock(ManagerProductStock dto) throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		try {
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		return model;
	}
}