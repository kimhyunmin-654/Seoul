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
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.admin.model.MemberManage;
import com.sp.app.admin.service.MemberManageService;
import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;

import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/admin/memberManage/*")
public class MemberManageController {
	private final MemberManageService service;
	private final PaginateUtil paginateUtil;
	private final MyUtil myUtil;
	
	@GetMapping("main")
	public String memberManage(Model model) throws Exception {
		
		return "admin/memberManage/main";
	}
	
	//회원 리스트 : AJAX - TEXT
	@GetMapping("list")
	public String listMember(@RequestParam (name = "page", defaultValue = "1") int current_page, 
			@RequestParam(name = "schType", defaultValue = "login_id") String schType, 
			@RequestParam(name = "kwd", defaultValue = "") String kwd, 
			@RequestParam(name = "role", defaultValue = "1") int role,
			@RequestParam(name = "non", defaultValue = "0") int non,
			@RequestParam(name = "enabled", defaultValue = "") String enabled,
			Model model, 
			HttpServletResponse resp) throws Exception {
		
		try {
			int size = 10;
			int total_page = 0;
			int dataCount = 0;
			
			kwd = myUtil.decodeUrl(kwd);
			
			Map<String, Object> map = new HashMap<>();
			map.put("role", role);
			map.put("non", non);
			map.put("enabled", enabled);
			map.put("schType", schType);
			map.put("kwd", kwd);
			
			dataCount = service.dataCount(map);
			if(dataCount != 0) {
				total_page = paginateUtil.pageCount(dataCount, size);
			}
			
			//다른사림이 자료를 삭제하여 전체페이지수가 편화 된경우
			current_page = Math.min(current_page, total_page);
			
			//리스트에 출력할 데이터
			int offset = (current_page - 1) * size;
			if (offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			List<MemberManage> list = service.listMember(map);
			String paging = paginateUtil.paging(current_page, total_page, "listMember");
			
			model.addAttribute("list", list);
			model.addAttribute("page", current_page);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("paging", paging);
			model.addAttribute("role", role);
			model.addAttribute("non", non);
			model.addAttribute("enabled", enabled);
			model.addAttribute("schType", schType);
			model.addAttribute("kwd", kwd);
			
		} catch (Exception e) {
			log.info("list : ", e);
			
			resp.sendError(406);
			throw e;
		}
		
		return "admin/memberManage/list";
	}
	
	//회원상세 정보 : AJAX-TEXT
	@GetMapping("profile")
	public String dataileMemver(@RequestParam(name = "member_id") Long member_id,
			@RequestParam(name = "page") String page,
			Model model,
			HttpServletResponse resp) throws Exception {
		
		try {
			MemberManage dto = Objects.requireNonNull(service.findById(member_id));
			MemberManage memberStatus = service.findByStatus(member_id);
			List<MemberManage> listStatus = service.listMemberStatus(member_id);
			
			model.addAttribute("dto", dto);
			model.addAttribute("memberStatus", memberStatus);
			model.addAttribute("listStatus", listStatus);
			model.addAttribute("page", page);
			
		} catch (NullPointerException e) {
			resp.sendError(410);
			throw e;
		} catch (Exception e) {
			resp.sendError(406);
			throw e;
		}
		
		return "admin/memberManage/profile";
	}
	
	//회원정보변경 : AJAX-JSON
	@ResponseBody
	@PostMapping("updateMember")
	public Map<String, ?> updateMember(@RequestParam Map<String, Object> paramMap) throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			//회원정보 변경
			service.updateMember(paramMap);
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		return model;
	}
	
	//회원 상태 변경 : AJAX-JSON
	@ResponseBody
	@PostMapping("updateMemberStatus")
	public Map<String, ?> updateMemberStatus(MemberManage dto) throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			//회원 활성 비활성
			Map<String, Object> map = new HashMap<>();
			map.put("member_id", dto.getMember_id());
			if(dto.getStatus_code() == 0) {
				map.put("enavled", 1);
			} else {
				map.put("enabled", 0);
			}
			service.updateMemberEnabled(map);
			
			//회원상태 변경사항 저장
			service.insertMemberStatus(dto);
			
			if(dto.getStatus_code() == 0) {
				//회원 패스워드 실패횟수 초기화
				service.updateFailureCountReset(dto.getMember_id());
			}
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		return model;
	}
	
	//회원 연력대별 인원수 : AJAX-JSON
	@ResponseBody
	@GetMapping("memberAgeSection")
	public Map<String, ?> memberAgeSection() throws Exception {
		Map<String, Object> model = new HashMap<String, Object>();
		
		//연령대별 인원수
		List<Map<String, Object>> list = service.listAgeSection();
		
		model.put("list", list);
		
		return model;
	}
	

}
