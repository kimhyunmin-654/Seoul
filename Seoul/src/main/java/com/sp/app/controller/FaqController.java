package com.sp.app.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.admin.model.FaqManage;
import com.sp.app.admin.service.FaqManageService;
import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/faq/*")
public class FaqController {
	
	private final FaqManageService service;
	private final PaginateUtil paginateUtil;
	private final MyUtil myUtil;
	
	@GetMapping("list")
	public String list(
	        @RequestParam(name = "page", defaultValue = "1") int current_page,
	        @RequestParam(name = "size", defaultValue = "10") int size,
	        @RequestParam(name = "schType", defaultValue = "all") String schType,
	        @RequestParam(name = "kwd", defaultValue = "") String kwd,
	        Model model,
	        HttpServletRequest req) throws Exception {

	    try {
	        int total_page = 0;
	        int dataCount = 0;

	        kwd = myUtil.decodeUrl(kwd);

	        Map<String, Object> map = new HashMap<>();
	        map.put("schType", schType);
	        map.put("kwd", kwd);

	        dataCount = service.dataCount(map);

	        if (dataCount != 0) {
	            total_page = paginateUtil.pageCount(dataCount, size);
	        }

	        current_page = Math.min(current_page, total_page);
	        if (current_page < 1) current_page = 1;

	        int offset = (current_page - 1) * size;
	        if (offset < 0) offset = 0;

	        map.put("offset", offset);
	        map.put("size", size);

	        List<FaqManage> list = service.listFaq(map);

	        String cp = req.getContextPath();
	        String query = "size=" + size;  

	        if (!kwd.isBlank()) {
	            query += "&schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
	        }

	        String listUrl = cp + "/faq/list?" + query;
	        String articleUrl = cp + "/faq/article?page=" + current_page + "&" + query;

	        String paging = paginateUtil.paging(current_page, total_page, listUrl);

	        model.addAttribute("list", list);
	        model.addAttribute("dataCount", dataCount);
	        model.addAttribute("size", size);
	        model.addAttribute("total_page", total_page);
	        model.addAttribute("page", current_page);
	        model.addAttribute("paging", paging);
	        model.addAttribute("articleUrl", articleUrl);
	        model.addAttribute("schType", schType);
	        model.addAttribute("kwd", kwd);

	    } catch (Exception e) {
	        log.error("list : " + e.getMessage(), e);
	    }

	    return "faq/list";
	}
	
	@GetMapping("article")
	public String article(@RequestParam("faq_id") long faq_id,
			@RequestParam("page") String page,
			@RequestParam(name = "schType",defaultValue =  "all") String schType,
			@RequestParam(name = "kwd",defaultValue =  "") String kwd,
			Model model,
			HttpSession session) throws Exception {
		
		String query = "page=" + page;
		
		try {
			kwd = myUtil.decodeUrl(kwd);
			
			if(! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
			}
			
			service.updateHitCount(faq_id);
			
			FaqManage dto = Objects.requireNonNull(service.findById(faq_id));
			
			dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
			
			Map<String, Object> map = new HashMap<>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			map.put("faq_id", faq_id);
			
			String updateDate = dto.getUpdate_date();
			if (updateDate.length() == 10) {
			    updateDate += " 00:00:00";
			}
			
			map.put("update_date", updateDate);
			
			FaqManage prevDto = service.findByPrev(map);
			FaqManage nextDto = service.findByNext(map);
			
			model.addAttribute("dto", dto);
			model.addAttribute("prevDto", prevDto);
			model.addAttribute("nextDto", nextDto);
			
			model.addAttribute("query", query);
			model.addAttribute("page", page);
			
			return "faq/article";
			
			
		} catch (Exception e) {
			log.info("article : " + e);
		}
		
		
		return "redirect:/faq/list?" + query;
	}
}
