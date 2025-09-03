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

import com.sp.app.admin.model.ReportsManage;
import com.sp.app.admin.service.ReportsManageService;
import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.model.SessionInfo;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/admin/reportsManage")
public class ReportsManageController {
	private final ReportsManageService service;
	private final PaginateUtil paginateUtil;
	private final MyUtil myUtil;
	
	@GetMapping("main")
	public String main(@RequestParam(name = "status", defaultValue = "0") int status,
			@RequestParam(name = "page", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model) {
		
		model.addAttribute("report_status", status);
		model.addAttribute("page", current_page);
		model.addAttribute("schType", schType);
		model.addAttribute("kwd", kwd);
		
		return "admin/reportsManage/main";
	}
	
	// AJAX - Text
	@GetMapping("list/{menuItem}")
	public String list(@PathVariable(name = "menuItem") String menuItem,
			@RequestParam(name = "status", defaultValue = "0") int report_status,
			@RequestParam(name = "pageNo", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model) {
		
		String viewPage = "listAll";
		
		try {
			log.info(menuItem);
			
			viewPage = menuItem.equals("group") ? "listGroup" : "listAll";
			log.info(viewPage);
			
			int size = 10;
			int total_page = 0;
			int dataCount = 0;
			
			kwd = myUtil.decodeUrl(kwd);
			
			Map<String, Object> map = new HashMap<>();
			map.put("status", report_status);
			map.put("schType", schType);
			map.put("kwd", kwd);
			
			if(menuItem.equals("all")) {
				dataCount = service.dataCount(map);
			} else {
				dataCount = service.dataGroupCount(map);
			}
			
			if(dataCount != 0) {
				total_page = paginateUtil.pageCount(dataCount, size);
			}
			
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			// 글 리스트
			List<ReportsManage> list = null;
			if(menuItem.equals("all")) {
				list = service.listReports(map);
			} else {
				list = service.listGroupReports(map);
			}
			
			String paging = paginateUtil.pagingMethod(current_page, total_page, "listPage");
			
			model.addAttribute("list", list);
			model.addAttribute("report_status", report_status);
			model.addAttribute("pageNo", current_page);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("total_page", total_page);
			model.addAttribute("paging", paging);
			
		} catch (Exception e) {
			log.info("list : ", e);
		}
		
		return "admin/reportsManage/" + viewPage;
	}
	
	
	// 글보기
	@GetMapping("article/{report_num}")
	public String article(@PathVariable(name = "report_num") long report_num,
			@RequestParam(name = "status", defaultValue = "0") int report_status,
			@RequestParam(name = "page") String page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model) throws Exception {
		
		String query = "page=" + page;
		try {
			kwd = myUtil.decodeUrl(kwd);
			
			// 신고상태
			if(report_status != 0) {
				query += "&status=" + report_status;
			}
			
			// 검색
			if(! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
			}
			
			// 신고 상세정보
			ReportsManage report = Objects.requireNonNull(service.findById(report_num));
			if(report.getReason_detail() != null) {
				report.setReason_detail(report.getReason_detail().replaceAll("\n", "<br>"));
			}
			
			// 신고대상 글 신고건수
			Map<String, Object> countMap = new HashMap<>();
			countMap.put("target_table", report.getTarget_table());
			countMap.put("target_num", report.getTarget_num());
			int reportsCount = service.dataRelatedCount(countMap);
			
			// 신고대상 글 정보(게시글 보기)
			Map<String, Object> map = new HashMap<>();
			map.put("target_type", report.getTarget_type());
			map.put("target_table", report.getTarget_table());
			map.put("num", report.getTarget_num());
			
			// 테이블별 field_name
			if(report.getTarget_type().equals("posts")) { // 동네한바퀴 게시글
				map.put("field_name", "num");
			} else if(report.getTarget_type().contains("reply")) { // 동네한바퀴 댓글, 답글
				map.put("field_name", "reply_num");
			} else { // 중고거래
				map.put("field_name", "product_id");
			}
			
			ReportsManage target = service.findContentByTypeId(map);
			if(target != null) {
				target.setContent(target.getContent().replaceAll("\n", "<br>"));
			}
			
			String region_name = service.getRegionnameById(target.getRegion_id());
			
			model.addAttribute("report", report);
			model.addAttribute("target", target);
			model.addAttribute("region_name", region_name);
			model.addAttribute("reportsCount", reportsCount);
			
			model.addAttribute("report_status", report_status);
			model.addAttribute("page", page);
			model.addAttribute("schType", schType);
			model.addAttribute("kwd", kwd);
			
			model.addAttribute("query", query);
			
			return "admin/reportsManage/article";
			
		} catch (NullPointerException e) {
			log.info("article : ", e);
		} catch (Exception e) {
			log.info("article : ", e);
		}
		
		return "redirect:/admin/reportsManage/main";
	}
	
	// 동일 게시물 신고 리스트
	// AJAX - Text
	@GetMapping("listRelated")
	public String listRelated(@RequestParam(name = "report_num") long report_num,
			@RequestParam(name = "target_num") long target_num,
			@RequestParam(name = "target_table") String target_table,
			@RequestParam(name = "pageNo", defaultValue = "1") int current_page,
			Model model) {
		
		try {
			int size = 5;
			int total_page = 0;
			int dataCount = 0;
			
			// 신고건수
			Map<String, Object> map = new HashMap<>();
			map.put("report_num", report_num);
			map.put("target_num", target_num);
			map.put("target_table", target_table);
			
			dataCount = service.dataRelatedCount(map);
			if(dataCount != 0) {
				total_page = paginateUtil.pageCount(dataCount, size);
			}
			
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			List<ReportsManage> list = service.listRelatedReports(map);
			
			String paging = paginateUtil.pagingMethod(current_page, total_page, "listAll");
			
			model.addAttribute("list", list);
			model.addAttribute("pageNo", current_page);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("total_page", total_page);
			model.addAttribute("paging", paging);
			
		} catch (Exception e) {
			log.info("listRelated : ", e);
		}
		
		return "admin/reportsManage/listAll";
	}
	
	@PostMapping("update")
	public String updateReports(ReportsManage dto,
			@RequestParam(name = "report_action") String report_action,
			@RequestParam(name = "status", defaultValue = "0") int status,			
			@RequestParam(name = "page") String page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			HttpSession session, Model model) throws Exception {
		
		String query = "page=" + page;
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			kwd = myUtil.decodeUrl(kwd);
			
			if(status != 0) {
				query += "&status=" + status;
			}
			
			if(! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
			}
			
			// 신고 처리
			dto.setHandled_by(info.getMember_id());
			service.updateReports(dto);
			
			String field_name = "";
			switch(dto.getTarget_table()) {
				case "community": field_name = "num"; break;
				case "community_reply": field_name = "reply_num"; break;
				case "transaction": field_name = "product_id"; break;
			}
			
			Map<String, Object> map = new HashMap<>();
			map.put("target_table", dto.getTarget_table());
			map.put("field_name", field_name);
			map.put("num", dto.getTarget_num());
			map.put("target_type", dto.getTarget_type());
			
			if(report_action.equals("blind")) {
				map.put("block", 1);
				service.updateBlockContent(map);
			} else if(report_action.equals("unlock")) {
				map.put("block", 0);
				service.updateBlockContent(map);
			} else if(report_action.equals("delete")) {
				map.put("reply_num", dto.getTarget_num());
				service.deleteContent(map);
			}
			
			return "redirect:/admin/reportsManage/article/" + dto.getReport_num() + "?" + query;
			
		} catch (NullPointerException e) {
			log.info("updateReports : ", e);
		} catch (Exception e) {
			log.info("updateReports : ", e);
		}
		
		return "redirect:/admin/reportsManage/main";
	}
	
}
