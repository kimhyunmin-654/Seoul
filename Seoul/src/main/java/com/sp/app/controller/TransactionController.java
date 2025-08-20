package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;
import com.sp.app.model.BuyerCandidate;
import com.sp.app.model.Product;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.TransactionService;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/transaction/*")
public class TransactionController {
	private final TransactionService transactionService;
	
	private final PaginateUtil paginateUtil;
	private final StorageService storageService;
	private final MyUtil myUtil;
	
	private String uploadPath;
	
	@PostConstruct
	public void init() {
		uploadPath = this.storageService.getRealPath("/uploads/product");
	}
	
	@GetMapping("salelist")
	public String list(
			@RequestParam(name="page", defaultValue = "1") int current_page,
			Model model,
			HttpSession session,
			HttpServletRequest req) throws Exception{
	
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			if(info == null) {
				return "redirect:/member/login";
			}
			
			Long member_id = info.getMember_id();
			
			int size = 10;
			int total_page = 0;
			int dataCount = 0;
			
			Map<String, Object> map = new HashMap<>();
			map.put("member_id", member_id);
			
			dataCount = transactionService.dataCount(map);
			if(dataCount > 0) {
				total_page = paginateUtil.pageCount(dataCount, size);
			} else {
				total_page = 1;
			}
			
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;
			map.put("offset", offset);
			map.put("size", size);
			
			List<Product> list = transactionService.listProductBySeller(map);
			if(list == null) list = List.of();
			
			log.info("salelist - member_id={}, dataCount={}, page={}, offset={}, listSize={}",
	                 member_id, dataCount, current_page, offset, list.size());
			
			String cp = req. getContextPath();
			String listUrl = cp + "/transaction/salelist";
			String articleUrl = cp + "/transaction/article?page=" + current_page;
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			
	        model.addAttribute("list", list);
	        model.addAttribute("articleUrl", articleUrl);
	        model.addAttribute("dataCount", dataCount);
	        model.addAttribute("page", current_page);
	        model.addAttribute("total_page", total_page);
	        model.addAttribute("size", size);
	        model.addAttribute("paging", paging);
						
			
		} catch (Exception e) {
			log.info("list : ", e);
		}
		
		return "transaction/salelist";
		
	}
	
	@PostMapping("updateStatus")
	@ResponseBody
	public Map<String,Object> updateStatus(
	        @RequestParam("product_id") Long product_id,
	        @RequestParam("status") String status,
	        HttpSession session) {

	    Map<String,Object> resp = new HashMap<>();
	    try {
	        SessionInfo info = (SessionInfo) session.getAttribute("member");
	        if (info == null) {
	            resp.put("success", false);
	            resp.put("message", "로그인 필요");
	            return resp;
	        }
	        Long member_id = info.getMember_id();

	        Product prod = transactionService.findProductById(product_id);
	        if (prod == null) {
	            resp.put("success", false);
	            resp.put("message", "상품을 찾을 수 없습니다.");
	            return resp;
	        }
	        if ("판매완료".equals(prod.getStatus())) {
	            resp.put("success", false);
	            resp.put("message", "이미 판매완료 상태입니다. 수정 불가.");
	            return resp;
	        }

	        if (status != null) status = status.trim();
	        List<String> ALLOWED = List.of("판매중","예약중");
	        if (!ALLOWED.contains(status)) {
	            resp.put("success", false);
	            resp.put("message", "유효하지 않은 상태입니다.");
	            return resp;
	        }

	        Map<String,Object> map = new HashMap<>();
	        map.put("product_id", product_id);
	        map.put("member_id", member_id);
	        map.put("status", status);

	        int updated = transactionService.updateProductStatus(map);
	        resp.put("success", updated > 0);
	        if (updated <= 0) resp.put("message", "변경 권한이 없거나 상품을 찾을 수 없습니다.");
	    } catch (Exception e) {
	        log.info("updateStatus : ", e);
	        resp.put("success", false);
	        resp.put("message", "서버 오류");
	    }
	    return resp;
	}
	
	@GetMapping("buyers")
	@ResponseBody
	public Map<String, ?> buyers(@RequestParam("product_id") long product_id, 
			HttpSession session) {
		
		Map<String, Object> resp = new HashMap<>();
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			if(info == null) {				
				resp.put("success", false);
				resp.put("messge", "로그인 필요");
				return resp;
			}
			
			long seller_id = info.getMember_id();
			
			Map<String, Object> map = new HashMap<>();
			map.put("product_id", product_id);
			map.put("seller_id", seller_id);
			
			List<BuyerCandidate> buyers = transactionService.listBuyersForProduct(map);
			
			resp.put("success", true);
			resp.put("buyers", buyers == null ? List.of() : buyers);
			
		} catch (Exception e) {
			log.info("buyers : ", e);
			resp.put("success", false);
			resp.put("message", "서버 오류");
		}
		return resp;	
	}
	
	
	@PostMapping("completeSale")
	@ResponseBody
	public Map<String, ?> completeSale(@RequestParam("product_id") long product_id,
			@RequestParam("room_id") long room_id,
			@RequestParam("buyer_id") long buyer_id,
			HttpSession session) {
		
		Map<String, Object> resp = new HashMap<>();
		SessionInfo info = (SessionInfo) session.getAttribute("member");
		if(info == null) {
			resp.put("success", false);
			resp.put("message", "로그인 필요");
			return resp;
		}
		
		long seller_id = info.getMember_id();
		
		try {
			boolean ok = transactionService.completeSale(product_id, room_id, seller_id, buyer_id);
			if(ok) {
				resp.put("success", true);
				resp.put("message", "거래가 확정되었습니다.");
			} else {
				resp.put("success", false);
				resp.put("message", "거래 확정에 실패했습니다.");
			}
		} catch (Exception e) {
			log.info("completeSale : ", e);
			resp.put("success", false);
			resp.put("messge", "서버 오류");
		}
		return resp;
	}
 	
}














