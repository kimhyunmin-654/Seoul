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
import com.sp.app.model.ProductLike;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.ProductLikeService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("productLike/*")
public class ProductLikeController {

	private final ProductLikeService service;

	@PostMapping("insertProductLike")
	@ResponseBody
	public Map<String, ?> insertProductLike(@RequestParam Map<String, Object> paramMap, HttpSession session) {
		Map<String, Object> model = new HashMap<>();

		String state;
		boolean isLiked;

		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			if(info == null) {
				model.put("state", "login_required");
				return model;
			}
			
			paramMap.put("member_id", info.getMember_id());
			
			// 서비스 메서드의 반환값을 받아서 isLiked에 저장
			isLiked = service.insertProductLike(paramMap);
			state = "true";

			model.put("isLiked", isLiked);

		} catch (Exception e) {
			state = "false";
		}

		model.put("state", state);

		return model;
	}
	
	@ResponseBody
	@PostMapping("deleteProductLike")
	public Map<String, ?> deleteProductLike(@RequestParam Map<String, Object> paramMap, HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			paramMap.put("member_id", info.getMember_id());
			service.deleteProductLike(paramMap);
			
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		
		return model;
	}


	@GetMapping("list")
	public String listProductLike(HttpSession session, Model model) {
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			if (info == null) {
				return "redirect:/member/login";
			}

			Map<String, Object> paramMap = new HashMap<>();
			paramMap.put("member_id", info.getMember_id());

			List<ProductLike> productLike = service.listProductLike(paramMap);
			model.addAttribute("productLike", productLike);

		} catch (Exception e) {
			log.info("listProductLike error: ", e);
		}

		return "productLike/list";

	}
}
