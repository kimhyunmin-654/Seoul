package com.sp.app.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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

import com.sp.app.chat.model.ChatMessage;
import com.sp.app.chat.service.ChatService;
import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;
import com.sp.app.model.BuyerCandidate;
import com.sp.app.model.Product;
import com.sp.app.model.PurchaseItem;
import com.sp.app.model.ReviewView;
import com.sp.app.model.SessionInfo;
import com.sp.app.model.TransactionReview;
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
	private final ChatService chatService;
	
	private final PaginateUtil paginateUtil;
	private final StorageService storageService;
	private final MyUtil myUtil;
	
	private String uploadPath;
	
	@PostConstruct
	public void init() {
		uploadPath = this.storageService.getRealPath("/uploads/product");
	}
	
	
	@GetMapping("salelist")
	public String salelist(
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
	
	@GetMapping("purchaseslist")
	public String purchasesList(
			@RequestParam(name="page", defaultValue = "1") int current_page,
			Model model,
			HttpSession session,
			HttpServletRequest req) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			if(info == null) {
				return "redirect:/member/login";
			}
			
			Long member_id = info.getMember_id();
			
			int size = 10;
			int total_page = 0;
			int dataCount2 = 0;
			
			Map<String, Object> map = new HashMap<>();
			map.put("buyer_id", member_id);
			
			dataCount2 = transactionService.dataCount2(map);
			if(dataCount2 > 0) {
				total_page = paginateUtil.pageCount(dataCount2, size);
			} else {
				total_page = 1;
			}
			
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;
			map.put("offset", offset);
			map.put("size", size);
			
			List<PurchaseItem> list = transactionService.listPurchasesByBuyer(map);
			if(list == null) list = List.of();
			
			String cp = req.getContextPath();
			String listUrl = cp + "/transaction/purchaseslist";
			String articleUrl = cp + "/transaction/article?page=" + current_page;
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("list", list);
			model.addAttribute("articleUrl", articleUrl);
			model.addAttribute("dataCount", dataCount2);
			model.addAttribute("page", current_page);
			model.addAttribute("total_page", total_page);
			model.addAttribute("size", size);
			model.addAttribute("paging", paging);
			
		} catch (Exception e) {
			log.info("purchasesList : ", e);
		}
		return "transaction/purchaseslist";
		
	}
	
	@GetMapping("reviewForm")
	@ResponseBody
	public Map<String, Object> reviewForm(
	        @RequestParam("room_id") Long room_id,
	        @RequestParam("product_id") Long product_id,
	        HttpSession session) {

	    Map<String, Object> resp = new HashMap<>();
	    try {
	        SessionInfo info = (SessionInfo) session.getAttribute("member");
	        if (info == null) {
	            resp.put("success", false);
	            resp.put("message", "로그인이 필요합니다.");
	            return resp;
	        }
	        Long memberId = info.getMember_id();

	        ChatMessage lastMsg = chatService.getLastMessage(room_id);
	        if (lastMsg == null) {
	            resp.put("success", false);
	            resp.put("message", "채팅 기록을 찾을 수 없습니다.");
	            return resp;
	        }
	        Long chat_id = lastMsg.getChat_id();

	        Map<String,Object> map = new HashMap<>();
	        map.put("buyer_id", memberId);
	        map.put("product_id", product_id);
	        Map<String, Object> q = new HashMap<>();
	        q.put("buyer_id", memberId);
	        q.put("offset", 0);
	        q.put("size", 1000);
	        List<PurchaseItem> purchases = transactionService.listPurchasesByBuyer(q);
	        boolean isBuyer = false;
	        if (purchases != null) {
	            for (PurchaseItem it : purchases) {
	                if (it.getRoom_id() != null && it.getRoom_id().equals(room_id)) {
	                    isBuyer = true;
	                    break;
	                }
	            }
	        }
	        if (!isBuyer) {
	            resp.put("success", false);
	            resp.put("message", "권한이 없습니다.");
	            return resp;
	        }

	        int exists = transactionService.hasReview(chat_id); 
	        if (exists > 0) {
	            resp.put("success", false);
	            resp.put("message", "이미 후기를 작성하셨습니다.");
	            resp.put("already", true);
	            return resp;
	        }

	        resp.put("success", true);
	        resp.put("chat_id", chat_id);
	        resp.put("product_id", product_id);
	        resp.put("room_id", room_id);
	        resp.put("product_name", transactionService.findProductById(product_id).getProduct_name());
	        return resp;

	    } catch (Exception e) {
	        log.error("reviewForm error", e);
	        resp.put("success", false);
	        resp.put("message", "서버 오류");
	        return resp;
	    }
	}
	
	@PostMapping("writeReview")
	@ResponseBody
	public Map<String, ?> writeReview(
			@RequestParam("chat_id") long chat_id,
			@RequestParam("product_id") long product_id,
			@RequestParam("rating") int rating,
			@RequestParam(name="content", required=false) String content,
			HttpSession session) {
		
		Map<String, Object> resp = new HashMap<>();
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			if(info == null) {
				resp.put("success", false);
				resp.put("message", "로그인이 필요합니다");
				return resp;
			}
						
			if (rating < 1 || rating > 5) {
				resp.put("success", false);
				resp.put("message", "별점은 1~5 사이여야 합니다.");
				return resp;
			}
			
	        TransactionReview dto = TransactionReview.builder()
	                .chat_id(chat_id)
	                .product_id(product_id)
	                .rating(rating)
	                .content(content == null ? "" : content.trim())
	                .writer_id(info.getMember_id())
	                .build();
			
			int inserted = transactionService.writeReview(dto);
			if (inserted > 0) {
				resp.put("success", true);
				resp.put("message", "후기가 등록되었습니다.");
			} else {
				resp.put("success", false);
				resp.put("message", "후기 등록 실패 또는 이미 작성됨");
			}
			
			return resp;
			
		} catch (Exception e) {
			log.info("writeReview : ", e);
			resp.put("success", false);
			resp.put("message", "서버 오류");
			return resp;
		}
	}
	
	@GetMapping("reviewslist")
	public String reviewsListView(Model model) {
	    return "transaction/reviewslist"; 
	}
	
	@GetMapping("reviewslistData")
	@ResponseBody
	public Map<String, ?> reviewsListData(
	        @RequestParam(name = "pageNo", defaultValue = "1") int current_page,
	        HttpSession session,
	        HttpServletRequest req) throws Exception {

	    Map<String, Object> model = new HashMap<>();
	    String state = "true";
	    try {
	        SessionInfo info = (SessionInfo) session.getAttribute("member");
	        if(info == null) {
	            state = "false";
	            model.put("state", state);
	            model.put("message", "로그인이 필요합니다");
	            return model;
	        }
	        Long seller_id = info.getMember_id();

	        int size = 5;
	        Map<String, Object> cntMap = new HashMap<>();
	        cntMap.put("seller_id", seller_id); 
	        
	        int dataCount = transactionService.countReviewBySeller(cntMap);
	        int total_page = paginateUtil.pageCount(dataCount, size);
	        
	        current_page = Math.min(current_page, total_page);
	        if(current_page < 1) current_page = 1;

	        int offset = (current_page - 1) * size;
	        if (offset < 0) offset = 0;

	        Map<String, Object> map = new HashMap<>();
	        map.put("seller_id", seller_id);
	        map.put("offset", offset);
	        map.put("size", size);

	        List<ReviewView> list = transactionService.listReviewBySeller(map);

	        List<Map<String, Object>> outList = new ArrayList<>();
	        String contextPath = req.getContextPath();
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	        if(list != null) {
	            for(ReviewView rv : list) {
	                Map<String, Object> m = new HashMap<>();
	                m.put("review_id", rv.getReview_id());
	                m.put("chat_id", rv.getChat_id());
	                m.put("product_id", rv.getProduct_id());
	                m.put("rating", rv.getRating());
	                m.put("content", rv.getContent() == null ? "" : rv.getContent());
	                Date created = rv.getCreated_at();
	                m.put("created_at", created != null ? sdf.format(created): "");
	                m.put("nickname", rv.getNickname() == null ? "" : rv.getNickname());

	                String profile = rv.getProfile_photo();
	                if(profile == null || profile.isBlank()) {
	                    m.put("profile_photo", contextPath + "/dist/images/avatar.png");
	                } else {
	                    m.put("profile_photo", contextPath + "/uploads/member/" + profile);
	                }

	                outList.add(m);
	            }
	        }

	        model.put("dataCount", dataCount);
	        model.put("total_page", total_page);
	        model.put("pageNo", current_page);
	        model.put("list", outList);

	    } catch (Exception e) {
	        log.info("reviewsList : " , e);
	        state = "false";
	    }

	    model.put("state", state);
	    return model;
	}
	

	@PostMapping("deleteProduct")
	@ResponseBody
	public Map<String, Object> deleteProduct(
	        @RequestParam("product_id") long product_id,
	        HttpSession session) {

	    Map<String, Object> resp = new HashMap<>();
	    try {
	        SessionInfo info = (SessionInfo) session.getAttribute("member");
	        if (info == null) {
	            resp.put("success", false);
	            resp.put("message", "로그인이 필요합니다.");
	            return resp;
	        }

	        long member_id = info.getMember_id();

	        transactionService.deleteProduct(product_id, member_id, uploadPath);

	        resp.put("success", true);
	        resp.put("message", "상품이 삭제되었습니다.");
	        return resp;
	    } catch (RuntimeException re) {
	        log.warn("deleteProduct - business error", re);
	        resp.put("success", false);
	        resp.put("message", re.getMessage() == null ? "삭제 권한이 없거나 상품이 없습니다." : re.getMessage());
	        return resp;
	    } catch (Exception e) {
	        log.error("deleteProduct error", e);
	        resp.put("success", false);
	        resp.put("message", "서버 오류가 발생했습니다.");
	        return resp;
	    }
	}
	
}














