package com.sp.app.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.admin.model.EventManage;
import com.sp.app.admin.service.EventManageService;
import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;
import com.sp.app.model.SessionInfo;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/admin/eventManage/*")
public class EventManageController {
	private final EventManageService service;
	private final PaginateUtil paginateUtil;
	private final StorageService storageService;
	
	private String uploadPath;
	
	@PostConstruct
	public void init() {
		uploadPath = this.storageService.getRealPath("/uploads/eventManage");
	}
	
	
	@GetMapping("{category}/list")
	public String list(@PathVariable("category") String category,
			@RequestParam(name = "page", defaultValue = "1") int current_page,
			@RequestParam(name = "eventType", defaultValue = "all") String event_type,
			Model model,
			HttpServletRequest req) throws Exception {
		
		try {
			int size = 10;
			int total_page = 0;
			int dataCount = 0;
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("category", category);
			map.put("event_type", event_type);
			
			dataCount = service.dataCount(map);
			if(dataCount != 0) {
				total_page = paginateUtil.pageCount(dataCount, size);
			}
			
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			// 글 리스트
			List<EventManage> list = service.listEvent(map);
			
			String cp = req.getContextPath();
			String listUrl = cp + "/admin/eventManage/" + category + "/list?eventType=" + event_type;
			String articleUrl = cp + "/admin/eventManage/" + category + "/article?eventType=" + event_type + "&page=" + current_page;
			
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("list", list);
			model.addAttribute("category", category);
			model.addAttribute("page", current_page);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("total_page", total_page);
			model.addAttribute("articleUrl", articleUrl);
			model.addAttribute("paging", paging);
			
			model.addAttribute("event_type", event_type);
			
		} catch (Exception e) {
			log.info("list : ", e);
		}
		
		return "admin/eventManage/list";
	}
	
	@GetMapping("{category}/write")
	public String writeForm(@PathVariable("category") String category,
			Model model) throws Exception {
		model.addAttribute("mode", "write");

		return "admin/eventManage/write";
	}
	
	@PostMapping("{category}/write")
	public String writeSubmit(@PathVariable("category") String category,
			EventManage dto, HttpSession session) throws Exception {

		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			dto.setMember_id(info.getMember_id());
			
			service.insertEvent(dto, uploadPath);
		} catch (Exception e) {
			log.info("writeSubmit : ", e);
		}

		return "redirect:/admin/eventManage/all/list"; // eventType?
	}
	
	@GetMapping("{category}/article")
	public String article(@PathVariable("category") String category,
			@RequestParam(name = "num") long event_num,
			@RequestParam(name = "page") String page,
			@RequestParam(name = "eventType", defaultValue = "all") String event_type,
			Model model) throws Exception {
		
		String query = "event_type=" + event_type + "&page=" + page;
		
		try {
			EventManage dto = Objects.requireNonNull(service.findById(event_num));
			
			Map<String, Object> map = new HashMap<>();
			map.put("category", category);
			map.put("event_num", event_num);
			map.put("event_type", event_type);
			
			EventManage prevDto = service.findByPrev(map);
			EventManage nextDto = service.findByNext(map);
			
			// 이벤트
			List<EventManage> listEventTakers = service.listEventTakers(event_num);
			
			List<EventManage> listEventWinner = service.listEventWinner(event_num);
			
			model.addAttribute("category", category);
			model.addAttribute("event_type", event_type);
			model.addAttribute("dto", dto);
			
			model.addAttribute("prevDto", prevDto);
			model.addAttribute("nextDto", nextDto);
			
			model.addAttribute("listEventTakers", listEventTakers);
			model.addAttribute("listEventWinner", listEventWinner);
			
			model.addAttribute("page", page);
			model.addAttribute("query", query); // page, event_type
			
			
			return "admin/eventManage/article";
			
		} catch (NullPointerException e) {
			log.info("article : ", e);
		} catch (Exception e) {
			log.info("article : ", e);
		}
		
		return "redirect:/event/" + category + "/list?" + query;
	}
	
	@GetMapping("{category}/update")
	public String updateForm(@PathVariable("category") String category,
			@RequestParam(name = "num") long event_num,
			@RequestParam(name = "page") String page,
			Model model, HttpSession session) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			if(info.getUserLevel() != 9) {
				return "redirect:/event/" + category + "/list?page=" + page;
			}
			
			EventManage dto = Objects.requireNonNull(service.findById(event_num));
			
			model.addAttribute("dto", dto);
			model.addAttribute("page", page);
			model.addAttribute("mode", "update");
			
			return "admin/eventManage/write";
			
		} catch (NullPointerException e) {
			log.info("updateForm : ", e);
		} catch (Exception e) {
			log.info("updateForm : ", e);
		}
		
		return "redirect:/event/" + category + "/list?page=" + page;
	}
	
	@PostMapping("{category}/update")
	public String updateSubmit(@PathVariable("category") String category,
			EventManage dto,
			@RequestParam(name = "page") String page,
			HttpSession session) throws Exception {

		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			dto.setUpdate_id(info.getMember_id());
			
			service.updateEvent(dto, uploadPath);
			
		} catch (Exception e) {
			log.info("updateSubmit : ", e);
		}
		
		return "redirect:/admin/eventManage/" + category + "/list?page=" + page;
	}
	
	@GetMapping("{category}/deleteFile")
	public String deleteFile(@PathVariable("category") String category,
			@RequestParam(name = "num") long event_num,
			@RequestParam(name = "page") String page,
			@RequestParam(name = "eventType", defaultValue = "all") String event_type,
			HttpSession session) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			EventManage dto = Objects.requireNonNull(service.findById(event_num));
			
			if(info.getUserLevel() != 9) { // 관리자
				return "redirect:/admin/eventManage/" + category + "/list?eventType=" + event_type + "&page=" + page;
			}
			
			if(dto.getSaveFilename() != null) {
				storageService.deleteFile(uploadPath, dto.getSaveFilename());
				
				dto.setSaveFilename("");
				dto.setOriginalFilename("");
				dto.setFilesize(0);
				
				service.updateEvent(dto, uploadPath);
			}
			
		} catch (NullPointerException e) {
			log.info("deleteFile : ", e);
		} catch (Exception e) {
			log.info("deleteFile : ", e);
		}
		
		return "redirect:/admin/eventManage/" + category + "/list?eventType=" + event_type + "&page=" + page;
	}
	
	
	@GetMapping("{category}/delete")
	public String delete(@PathVariable("category") String category,
			@RequestParam(name = "num") long event_num,
			@RequestParam(name = "page") String page,
			@RequestParam(name = "eventType", defaultValue = "all") String event_type,
			HttpSession session) throws Exception {
		
		String query = "eventType" + event_type + "&page=" + page;
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			service.deleteEvent(event_num, uploadPath, info.getUserLevel());
		} catch (Exception e) {
			log.info("delete : ", e);
		}
		
		return "redirect:/admin/eventManage/" + category + "/list?" + query;
	}
	
	@PostMapping("{category}/win")
	public String winner(@PathVariable("category") String category,
			EventManage dto,
			@RequestParam(name = "page") String page) throws Exception {
		
		try {
			service.insertEventWinner(dto);
		} catch (Exception e) {
			log.info("winner : ", e);
		}
		
		return "redirect:/admin/eventManage/winner/list?page=" + page;
	}

}
