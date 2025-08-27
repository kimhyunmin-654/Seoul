package com.sp.app.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sp.app.common.StorageService;
import com.sp.app.model.Auction;
import com.sp.app.model.Bid;
import com.sp.app.model.Category;
import com.sp.app.model.Product;
import com.sp.app.model.ProductImage;
import com.sp.app.model.Region;
import com.sp.app.model.SearchCondition;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.AuctionService;
import com.sp.app.service.ProductService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value =  "/auction/*")
public class AuctionController {
	
	private final AuctionService auctionService;
	private final ProductService productService;
	private final StorageService storageService;
	
	@GetMapping("update")
	public String updateAuction(
			@RequestParam(name = "auction_id") long auction_id,
			@RequestParam(name = "product_id") long product_id,
			HttpSession session, Model model,
			RedirectAttributes ra) {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			if(info == null) {
				return "redirect:/member/login";
			}
			
			if(auctionService.isBidded(auction_id)) {
				ra.addFlashAttribute("message", "입찰이 진행된 경매는 수정할 수 없습니다.");
				ra.addFlashAttribute("messageId", System.currentTimeMillis());
				return "redirect:/auction/detail/" + auction_id;
			}
			
			Product dto = productService.findById(product_id);
			
			if(info.getMember_id() != dto.getMember_id()) {
				ra.addFlashAttribute("message", "수정 권한이 없습니다.");
				ra.addFlashAttribute("messageId", System.currentTimeMillis());
				return "redirect:/auction/detail/" + auction_id;
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
			log.info("updateAuction : ", e);
			ra.addFlashAttribute("message", "오류가 발생했습니다. 다시 시도해주세요.");
			ra.addFlashAttribute("messageId", System.currentTimeMillis());
			return "redirect:/auction/detail/" + auction_id;
		}
		
		return "product/write";
	}
	

	@PostMapping("delete")
	public String deleteAuction(
			@RequestParam(name = "product_id") long product_id,
			@RequestParam(name = "auction_id") long auction_id,
			HttpSession session,
			RedirectAttributes ra) throws Exception {
		
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		String root = storageService.getRootRealPath();
		String pathname = root + "uploads" + File.separator + "product";
		
		try {
			
			if(auctionService.isBidded(auction_id)) {
				ra.addFlashAttribute("message", "입찰이 진행된 경매는 삭제할 수 없습니다.");
				ra.addFlashAttribute("messageId", System.currentTimeMillis());
				return "redirect:/auction/detail/" + auction_id;
			}
			
			productService.deleteProduct(product_id, info.getMember_id(), pathname);
			
		} catch (Exception e) {
			log.info("deleteAuction : ", e);
			ra.addFlashAttribute("message", "경매 삭제 중 오류가 발생했습니다. 다시 시도해주세요.");
			ra.addFlashAttribute("messageId", System.currentTimeMillis());
			return "redirect:/auction/detail/" + auction_id;
		}
		ra.addFlashAttribute("message", "경매가 성공적으로 삭제되었습니다.");
		ra.addFlashAttribute("messageId", System.currentTimeMillis());
		return "redirect:/auction/list"; 
	}
	
	@GetMapping("list")
	public String auctionList(SearchCondition cond, Model model) throws Exception {
		
		try {
			Map<String, Object> map = auctionService.listAuction(cond);
			
			model.addAttribute("featuredAuction", map.get("featuredAuction"));
			model.addAttribute("list", map.get("list"));
			model.addAttribute("dataCount", map.get("dataCount"));
			model.addAttribute("totalPage", map.get("totalPage"));
			model.addAttribute("page", map.get("page"));
			model.addAttribute("cond", cond);
			model.addAttribute("currentMenu", "auction/list");
//			model.addAttribute("categoryList", map.get("categoryList"));
			
			
		} catch (Exception e) {
			log.info("auctionList : ", e);
		}
		
		return "auction/list";
	}
	
	@GetMapping("detail/{auction_id}")
	public String auctionDetail(
			@PathVariable("auction_id") long auction_id,
			Model model,
			HttpServletRequest req) {

		Map<String, Object> map = new HashMap<>();
		
		try {
			map = auctionService.detailAuction(auction_id);
			
			if(map == null) {
				return "redirect:/auction/list";
			}
									
			List<Bid> bidList = (List<Bid>)map.get("bidList");
			ObjectMapper objectMapper = new ObjectMapper();
			String bidHistoryJson = objectMapper.writeValueAsString(bidList);
			
			String serverName = req.getServerName();
			int serverPort = req.getServerPort();
			
						
			model.addAttribute("dto", map.get("dto"));
			model.addAttribute("imageList", map.get("imageList"));
			model.addAttribute("bidHistoryJson", bidHistoryJson);
			model.addAttribute("serverName", serverName);
			model.addAttribute("serverPort", serverPort);
			
		} catch (Exception e) {
			log.info("auctionDetail : ", e);
			return "redirect:/auction/list";
		}
		
		return "auction/detail";
	}
	
	@ResponseBody
	@PostMapping("detail/{auction_id}")
	public Map<String, Object> bidSubmit(
			@PathVariable("auction_id") long auction_id,
			@RequestParam("bidAmount") int bidAmount,
			HttpSession session) {
		
		Map<String, Object> map = new HashMap<>();
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			Bid dto = new Bid();
			dto.setAuction_id(auction_id);
			dto.setBidder_id(info.getMember_id());
			dto.setBid_amount(bidAmount);
			
			map = auctionService.insertBid(dto);
			map.put("status", "success");
			
		} catch (RuntimeException e) {
			log.error("bidSubmit : ", e);
			map.put("status", "error");
			map.put("message", e.getMessage());
		} catch (Exception e) {
			log.error("bidSubmit : ", e);
		}
		return map;
	}
	
	@ResponseBody
	@GetMapping("status/{auction_id}")
	public Map<String, Object> getStatus(
			@PathVariable("auction_id") long auction_id) {
		Map<String, Object> map = new HashMap<>();
		
		try {			
			Auction dto = auctionService.getEndAuction(auction_id);
			
			map.put("status", "success");
			map.put("auctionStatus", dto.getStatus());
			map.put("winner", dto.getWinner_nickname());
			
		} catch (Exception e) {
			log.info("getStatus : ", e);
			map.put("status", "error");
		}
		
		return map;
	}
	
	@ResponseBody
	@GetMapping("list/ajax")
	public Map<String, Object> addAndFilter(SearchCondition cond) throws Exception {
		Map<String, Object> map = new HashMap<>();
		
		try {
			map = auctionService.listAuction(cond);
		} catch (Exception e) {
			log.info("addAndFilter: ", e);
		}
		
		return map;
	}
}
