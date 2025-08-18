package com.sp.app.admin.controller;

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
import com.sp.app.admin.model.InquiryManage;
import com.sp.app.admin.service.InquiryManageService;
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
@RequestMapping("/admin/inquiryManage/*")
public class InquiryManageController {
	private final InquiryManageService service;
	private final PaginateUtil paginateUtil;
	private final MyUtil myUtil;

	
	@GetMapping("list")
	public String list(@RequestParam(name = "page", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			HttpServletRequest req,
			HttpSession session,
			Model model) throws Exception {
		
		try {
			int size = 10;
			int total_page = 0;
			int dataCount = 0;
			
			kwd = myUtil.decodeUrl(kwd);
			
			//전체 페이지수
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			
			dataCount = service.dataCount(map);
			if(dataCount != 0) {
				total_page = paginateUtil.pageCount(dataCount, size);
			}
			
			current_page = Math.min(current_page, total_page);
			
			
			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;
			map.put("offset", offset);
			map.put("size", size);
			
			//글 리스트
			List<InquiryManage> list = service.listInquiry(map);
			
			String cp = req.getContextPath();
			String query = "";
			String listUrl = cp + "/admin/inquiryManage/list";
			String articleUrl = cp + "/admin/inquiryManage/article?page=" + current_page;
			if(! kwd.isBlank()) {
				query = "schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
				
				listUrl += "?" + query;
				articleUrl += "&" + query;
			}
			
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("list", list);
			model.addAttribute("articleUrl", articleUrl);
			model.addAttribute("page", current_page);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("total_page", total_page);
			model.addAttribute("paging", paging);
			
			model.addAttribute("schType", schType);
			model.addAttribute("kwd", kwd);
			
		} catch (Exception e) {
			log.info("list : ", e);
		}
		
		return "admin/inquiryManage/list";
	}
	
	@GetMapping("article")
	public String article (@RequestParam(name = "inquiry_id") long inquiry_id,
			@RequestParam(name = "page") String page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			HttpSession session,
			Model model) throws Exception {
		String query = "page=" + page;
		try {
			kwd = myUtil.decodeUrl(kwd);
			if(! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
			}
			
			InquiryManage dto = Objects.requireNonNull(service.findById(inquiry_id));
			dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
			if(dto.getAnswer() != null) {
				dto.setAnswer(dto.getAnswer().replaceAll("\n", "<br>"));
			}
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			map.put("inquiry_id", inquiry_id);
			
			InquiryManage prevDto = service.findByPrev(map);
			InquiryManage nextDto = service.findByNext(map);
			
			model.addAttribute("dto", dto);
			model.addAttribute("prevDto", prevDto);
			model.addAttribute("nextDto", nextDto);
			
			model.addAttribute("page", page);
			model.addAttribute("schType", schType);
			model.addAttribute("kwd", kwd);
			model.addAttribute("query", query);
			
			return "admin/inquiryManage/article";
			
		} catch (NullPointerException e) {
			log.info("article : ", e);
		} catch (Exception e) {
			log.info("article : ", e);
			
		}
		
		return "redirect:/admin/inquiryManage/list?" + query;
	}
	
	@PostMapping("answer")
	public String answerSubmit(InquiryManage dto,
			@RequestParam(name = "page") String page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			HttpSession session) throws Exception {
		
		String query = "page=" + page;
		
		try {
			if(! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
			}
			
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			dto.setAnswer_id(info.getMember_id());
			service.updateAnswer(dto);
		} catch (Exception e) {
			log.info("answerSubmit : ", e);
		}
		
		return "redirect:/admin/inquiryManage/list?" + query;
	}
	

	@GetMapping("delete")
	public String delete(@RequestParam(name = "inquiry_id") long inquiry_id, 
			@RequestParam(name = "page") String page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			@RequestParam(name = "mode") String mode,
			HttpSession session) throws Exception {
		
		String query = "page=" + page;
		try {
			kwd = myUtil.decodeUrl(kwd);
			if(! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
			}
			
			if(mode.equals("answer")) {
				service.deleteAnswer(inquiry_id);
			} else {
				service.deleteInquiry(inquiry_id);
			}
			
		} catch (Exception e) {
			log.info("delete : ", e);
		}
		
		return "redirect:/admin/inquiryManage/list?" + query;
	}
}
