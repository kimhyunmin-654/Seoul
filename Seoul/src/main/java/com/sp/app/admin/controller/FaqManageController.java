package com.sp.app.admin.controller;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.admin.model.FaqManage;
import com.sp.app.admin.service.FaqManageService;
import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.model.SessionInfo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/admin/faqManage/*")
public class FaqManageController {
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

	        String listUrl = cp + "/admin/faqManage/list?" + query;
	        String articleUrl = cp + "/admin/faqManage/article?page=" + current_page + "&" + query;

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
	        log.info("list : ", e);
	    }

	    return "admin/faqManage/list";
	}
	
	@GetMapping("write")
	public String writeForm(Model model) throws Exception {
		model.addAttribute("mode", "write");
		
		return "admin/faqManage/write";
	}
	
	@PostMapping("write")
	public String writeSubmit(FaqManage dto, HttpSession session) throws Exception {
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			dto.setMember_id(info.getMember_id());
			service.insertFaq(dto);
			
		} catch (Exception e) {
			log.info("writeSubmit : " + e);
		}
		
		return "redirect:/admin/faqManage/list";
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
			
	        @SuppressWarnings("unchecked")
	        Set<Long> viewed = (Set<Long>) session.getAttribute("viewedFaq");
	        if (viewed == null) {
	            viewed = new HashSet<>();
	        }
	        
	        if (!viewed.contains(faq_id)) {
	            service.updateHitCount(faq_id); 
	            viewed.add(faq_id);         
	            session.setAttribute("viewedFaq", viewed); 
	        }
			
			
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
			
			return "admin/faqManage/article";
			
			
		} catch (Exception e) {
			log.info("article : " + e);
		}
		
		
		return "redirect:/admin/faqManage/list?" + query;
	}
	
	@GetMapping("update")
	public String updateForm(@RequestParam("faq_id") long faq_id,
			@RequestParam("page") String page,
			Model model,
			HttpSession session) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			FaqManage dto = Objects.requireNonNull(service.findById(faq_id));
			
			if(dto.getMember_id() != info.getMember_id()) {
				return "redirect:/admin/faqManage/list?page=" + page;
			}
			
			model.addAttribute("dto", dto);
			model.addAttribute("mode", "update");
			model.addAttribute("page", page);
			
			return "admin/faqManage/write";
 			
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("updateForm : " + e);
		}
		
		return "redirect:/admin/faqManage/list?page=" + page;
	}
	
	@PostMapping("update")
	public String updateSubmit(FaqManage dto, 
			@RequestParam("page") String page) throws Exception {
		
		try {
			service.updateFaq(dto);
			
		} catch (Exception e) {
			log.info("updateForm : " + e);
		}
		
		return "redirect:/admin/faqManage/list?page=" + page;
	}
	
	@GetMapping("delete")
	public String delete(@RequestParam("faq_id") long faq_id,
			@RequestParam("page") String page,
			@RequestParam(name = "schType",defaultValue =  "all") String schType,
			@RequestParam(name = "kwd",defaultValue =  "") String kwd,
			HttpSession session) {
		
		String query = "page=" + page;
		
		try {
			kwd = myUtil.decodeUrl(kwd);
			if(! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd="
						+ myUtil.encodeUrl(kwd);
			}
			
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			service.deleteFaq(faq_id, info.getMember_id(), info.getUserLevel());
			
		} catch (Exception e) {
			log.info("updateForm : " + e);
		}
		
		return "redirect:/admin/faqManage/list?" +  query;
 	}
	
	@PostMapping("deletelist")
	public String deletelist(
	        @RequestParam(name = "faq_ids") long[] faq_ids,
	        HttpSession session) throws Exception {

	    SessionInfo info = (SessionInfo) session.getAttribute("member");
	    
	    try {
	        service.deleteFaq(faq_ids, info.getMember_id(), info.getUserLevel());
	        
	        
	    } catch (Exception e) {
	        log.info("deletelist : ", e);
	    }

	    return "redirect:/admin/faqManage/list";
	}
	
	
 
}



















