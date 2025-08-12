package com.sp.app.controller;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;
import com.sp.app.model.Product;
import com.sp.app.model.SearchCondition;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.ProductService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/product/*")
public class ProductController {

    private final MyUtil myUtil;
	private final ProductService productService;
	private final StorageService storageService;
	private final PaginateUtil paginateUtil;
	
	@GetMapping("write")
	public String insertForm(HttpSession session) {
		
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		if(info == null) {
			return "redirect:/member/login";
		}
		
		return "product/write";
	}
	
	@PostMapping("write")
	public String insertSubmit(Product dto, @RequestParam("selectFile") List<MultipartFile> selectFile,
			HttpSession session) throws Exception {
	
		
		try {
			
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			if(info == null) {
				return "redirect:/member/login";
			}
			
			dto.setMember_id(info.getMember_id());
			
			String root = storageService.getRootRealPath();
			String path = root + "uploads" + File.separator + "product";
			
			if(selectFile != null && !selectFile.isEmpty()) {
				String newFilename = storageService.uploadFileToServer(selectFile.get(0), path);
				dto.setThumbnail(newFilename);
			}
			
			productService.insertProduct(dto, selectFile, path);
		} catch (Exception e) {
			return "redirect:/product/write";
		}
		
		return "redirect:/product/list";
	}
	
	@GetMapping("list")
	public String ProductList( SearchCondition cond, Model model) throws Exception {
		
		try {
			
			Map<String, Object> map = productService.listProduct(cond);
			
			model.addAttribute("list", map.get("list"));
			model.addAttribute("paging", map.get("paging"));
			model.addAttribute("page", map.get("page"));
			model.addAttribute("totalPage", map.get("totalPage"));
			model.addAttribute("dataCount", map.get("dataCount"));
						
		} catch (Exception e) {
			log.info("ProductList : ", e);
		}
		
		return "product/list";
	}
	
	@GetMapping("list/more")
	@ResponseBody
	public Map<String, Object> loadMoreProducts( SearchCondition cond) throws Exception {
		
		try {
			
			Map<String, Object> map = productService.listProduct(cond);
			
			return map;
			
		} catch (Exception e) {
			log.info("loadMoreProducts : ", e);
		}
		
		return null;
	}
	
	
}
