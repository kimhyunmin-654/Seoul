package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.model.Board;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.BoardMyService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("myBoard")
public class BoardMyController {
	private final BoardMyService service;
	private final PaginateUtil paginateUtil;
	private final MyUtil myUtil;
	
	
	@GetMapping("list")
	public String list(@RequestParam(name = "page", defaultValue = "1") int current_page,
				@ModelAttribute("region_name")String region_name,
				@RequestParam(name = "region", defaultValue = "gangname") String region,
				@RequestParam(name = "schType", defaultValue = "all") String schType,
				@RequestParam(name = "kwd", defaultValue = "") String kwd,
				HttpServletRequest req,
				HttpSession session, Model model) {
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			if(info == null) {
				return "redirect:/member/login";
			}
			
			
			int size = 10;
			int total_page = 0;
			int dataCount = 0;
			
			Map<String, Object> map = new HashMap<>();
			map.put("member_id", info.getMember_id());
			map.put("schType", schType);
			map.put("kwd", kwd);
			map.put("region_id", region);
			
			dataCount = service.MyBoardCount(map);
			
			if(dataCount != 0) {
				total_page = paginateUtil.pageCount(dataCount, size);
			}
			
			current_page = Math.min(current_page, total_page);
			if(current_page < 1) current_page = 1;
			
			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			List<Board> list = service.listMyBoard(map);
			
			String cp = req.getContextPath();
			String query = "size=" + size;
			String listUrl = cp + "/myBoard/list?" + query; 
			
			if(!kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
				
				listUrl += "&" + query;
			}
			
			
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("list", list);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("total_page", total_page);
			model.addAttribute("page", current_page);
			model.addAttribute("paging", paging);
			model.addAttribute("schType", schType);
			model.addAttribute("kwd", kwd);
			
			
		} catch (Exception e) {
			log.info("list : ", e);
		}
		
		model.addAttribute("region_name", region_name);
		model.addAttribute("region_code", region);
		
		return "myBoard/list";
		
	}
	
}
