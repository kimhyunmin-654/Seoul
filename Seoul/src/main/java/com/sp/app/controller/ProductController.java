package com.sp.app.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;
import com.sp.app.model.Category;
import com.sp.app.model.Product;
import com.sp.app.model.ProductImage;
import com.sp.app.model.Region;
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
	public String insertForm(HttpSession session, Model model) {
		
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		if(info == null) {
			return "redirect:/member/login";
		}
		
		List<Category> categoryList = productService.listCategories();
		List<Region> regionList = productService.listRegion();
		
		model.addAttribute("mode", "write");
		model.addAttribute("categoryList", categoryList);
		model.addAttribute("regionList", regionList);
		
		return "product/write";
	}
	
	@PostMapping("write")
	public String insertSubmit(Product dto, @RequestParam("addFiles") List<MultipartFile> addFiles,
			@RequestParam(name = "thumbnailIndex", defaultValue = "0") Integer thumbnailIndex,
			HttpSession session) throws Exception {
	
		
		try {
			
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			if(info == null) {
				return "redirect:/member/login";
			}
			
			dto.setMember_id(info.getMember_id());
			
			String root = storageService.getRootRealPath();
			String path = root + "uploads" + File.separator + "product";
			
			productService.insertProduct(dto, addFiles, thumbnailIndex, path);
		} catch (Exception e) {
			log.info("insertSubmit : ", e);
			return "redirect:/product/write";
		}
		
		return "redirect:/product/list";
	}
	
	@GetMapping("update")
	public String updateForm( @RequestParam("product_id") long product_id, 
			HttpSession session, Model model,
			RedirectAttributes ra) {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			if(info == null) {
				return "redirect:/member/login";
			}
			
			Product dto = productService.findById(product_id);
			
			if(info.getMember_id() != dto.getMember_id()) {
				ra.addFlashAttribute("message", "수정 권한이 없습니다.");
				
				return "redirect:/product/detail?product_id=" + product_id;
			}
			
			
			List<ProductImage> imageList = productService.listProductImage(product_id); 
			List<Category> categoryList = productService.listCategories();
			List<Region> regionList = productService.listRegion();
			
			model.addAttribute("dto", dto);
			model.addAttribute("imageList", imageList);
			model.addAttribute("mode", "update");			
			model.addAttribute("categoryList", categoryList);
			model.addAttribute("regionList", regionList);
					
			
		} catch (Exception e) {
			log.info("updateForm : ", e);
			return "redirect:/product/detail?product_id=" + product_id;
		}
		
		return "product/write";
	}
	
	@PostMapping("update")
	public String updateSubmit(
			Product dto,
			@RequestParam(name = "addFiles", required = false) List<MultipartFile> addFiles,
			@RequestParam(name = "deleteImageIds", required = false) List<Long> deleteImageIds,
			@RequestParam(name = "deleteFilename", required = false) List<String> deleteFilename,
			@RequestParam(name = "newThumbnailFilename", required = false) String newThumbnailFilename,
			@RequestParam(name = "oldThumbnailToMove", required = false) String oldThumbnailToMove,
			@RequestParam(name = "imageIdToPromote", required = false) Long imageIdToPromote,
			@RequestParam(name = "thumbnailIndex", required = false, defaultValue = "0") int thumbnailIndex,
			HttpSession session,
			RedirectAttributes ra 
			) {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			if(info == null) {
				return "redirect:/member/login";
			}
			
			String root = storageService.getRootRealPath();
			String path = root + "uploads" + File.separator + "product";
			
			dto.setThumbnail(newThumbnailFilename);
			
			productService.updateProduct(dto, addFiles, deleteImageIds, deleteFilename, oldThumbnailToMove, imageIdToPromote, path, thumbnailIndex);
			
		} catch (Exception e) {
			log.info("updateSubmit : ", e);
			ra.addFlashAttribute("message", "상품 수정에 실패했습니다.");
			return "redirect:/product/update?product_id=" + dto.getProduct_id();
		}
		
		return "redirect:/product/detail?product_id=" + dto.getProduct_id();
		
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
			model.addAttribute("cond", cond);
			
						
		} catch (Exception e) {
			log.info("ProductList : ", e);
		}
		
		return "product/list";
	}
	
	@GetMapping("list/ajax")
	@ResponseBody
	public Map<String, Object> loadAjaxRequest( SearchCondition cond) throws Exception {
		
		try {
			
			Map<String, Object> map = productService.listProduct(cond);
			
			return map;
			
		} catch (Exception e) {
			log.info("loadMoreProducts : ", e);
		}
		
		return null;
	}
	
	@GetMapping("detail")
	public String detailRequest(@RequestParam("product_id") long product_id,
			HttpSession session, Model model) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			Product dto = Objects.requireNonNull(productService.findById(product_id));
			
			productService.updateHitCount(product_id);
			
			// 찜 여부(미완성)
			
			List<ProductImage> listFile = productService.listProductImage(product_id);
			
			model.addAttribute("dto", dto);
			model.addAttribute("listFile", listFile);
			model.addAttribute("currentMenu", "product/list");
			
			return "product/detail";
			
		} catch (Exception e) {
			log.info("detail : ", e);
		}
		
		return "redirect:/product/list";
	}
	
	@PostMapping("delete")
	public String deleteProduct(
			@RequestParam("product_id") long product_id,
			HttpSession session,
			RedirectAttributes ra
			) throws Exception {

		SessionInfo info = (SessionInfo)session.getAttribute("member");
		String root = storageService.getRootRealPath();
		String pathname = root + "uploads" + File.separator + "product";
		
		try {
			
			productService.deleteProduct(product_id, info.getMember_id(), pathname);
			
	
		} catch (Exception e) {
			log.info("deleteProduct : ", e);
			ra.addFlashAttribute("message", "상품 삭제 중 오류가 발생했습니다. 다시 시도해주세요.");
			ra.addFlashAttribute("messageId", System.currentTimeMillis());
			return "redirect:/product/detail?product_id=" + product_id;
		}
		
		ra.addFlashAttribute("message", "상품이 성공적으로 삭제되었습니다.");
		ra.addFlashAttribute("messageId", System.currentTimeMillis());
		return "redirect:/product/list";
	}
	
	@ResponseBody
	@PostMapping("deleteImage")
	public Map<String, ?> deleteImage(@RequestParam(name = "image_id") long image_id, 
			@RequestParam(name = "filename") String filename) throws Exception {
		Map<String, Object> model = new HashMap<>();

		String state = "false";
		try {
			String root = storageService.getRootRealPath();
			String pathString = root + File.separator + filename;
			productService.deleteProductImage(image_id, pathString);
			
			state = "true";
		} catch (Exception e) {
		}
		
		model.put("state", state);
		return model;
	}
	
	
}
