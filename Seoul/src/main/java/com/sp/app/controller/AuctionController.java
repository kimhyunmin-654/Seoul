package com.sp.app.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sp.app.model.SearchCondition;
import com.sp.app.service.AuctionService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value =  "/auction/*")
public class AuctionController {
	
	private final AuctionService auctionService;
	
	
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
			model.addAttribute("categoryList", map.get("categoryList"));
			
			
		} catch (Exception e) {
			log.info("auctionList : ", e);
		}
		
		return "auction/list";
	}
}
