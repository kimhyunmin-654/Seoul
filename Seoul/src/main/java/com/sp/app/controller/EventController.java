package com.sp.app.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.common.PaginateUtil;
import com.sp.app.model.Event;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.EventService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/event/*")
public class EventController {
	private final EventService service;
	private final PaginateUtil paginateUtil;
	
	@GetMapping("{category}/list")
	public String list(@PathVariable("category") String category,
					@RequestParam(name = "page", defaultValue = "1") int current_page,
					@RequestParam(name = "eventType", defaultValue = "all") String event_type,
					Model model,
					HttpServletRequest req) throws Exception {
		
		try {
			int size = 6;
			int total_page = 0;
			int dataCount = 0;
			
			Map<String, Object> map = new HashMap<>();
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
			List<Event> list = service.listEvent(map);
			
			String cp = req.getContextPath();
			String listUrl = cp + "/event/" + category + "/list";
			String articleUrl = cp + "/event/" + category + "/article?eventType=" + event_type + "&page=" + current_page;
			
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			// 종료까지 남은기간
			String dDay = "";
			for(Event dto : list) {
				dDay = service.getDDayLabel(dto.getEndDate());
				dto.setLabelDDay(dDay);
			}
			
			model.addAttribute("list", list);
			model.addAttribute("category", category);
			model.addAttribute("page", current_page);
			model.addAttribute("total_page", total_page);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("articleUrl", articleUrl);
			model.addAttribute("paging", paging);
			
			model.addAttribute("event_type", event_type);
			
		} catch (Exception e) {
			log.info("list : ", e);
		}
		
		return "event/list";
	}
	
	@GetMapping("{category}/article")
	public String article(@PathVariable("category") String category,
			@RequestParam(name = "num") long event_num,
			@RequestParam(name = "page") String page,
			@RequestParam(name = "eventType", defaultValue = "all") String event_type,
			Model model, HttpSession session) throws Exception {
		
		String query = "eventType=" + event_type + "&page=" + page;
		try {
			// 당첨자 발표(winner) 탭이 아닐경우 조회수 증가
			if(! category.equals("winner")) {
				service.updateHitCount(event_num);
			}
			
			Event dto = Objects.requireNonNull(service.findById(event_num));
			
			Map<String, Object> map = new HashMap<>();
			map.put("category", category);
			map.put("event_num", event_num);
			map.put("event_type", event_type);
			
			Event nextDto = service.findByNext(map);
			Event prevDto = service.findByPrev(map);
			
			// 진행 이벤트(progress) 탭 : 이벤트 참여 여부
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			boolean isUserEventTakers = false;
			if(category.equals("progress")) {
				map.put("member_id", info.getMember_id());
				isUserEventTakers = service.isuserEventTakers(map);
				System.out.print("isusereventtakers : " + isUserEventTakers);
			}
			
			// 이벤트 참여자
			List<Event> listEventTakers = service.listEventTakers(event_num);
			
			// 당첨자 발표(winner) 탭 : 이벤트 당첨자
			List<Event> listEventWinner = null;
			Event userWinner = null;
			if(category.equals("winner") || category.equals("ended")) {
				listEventWinner = service.listEventWinner(event_num);
				
				for(Event vo : listEventWinner) {
					if(vo.getMember_id() == info.getMember_id()) {
						userWinner = vo;
					}
				}
			}
			
			model.addAttribute("category", category);
			model.addAttribute("event_type", event_type);
			model.addAttribute("dto", dto);
			model.addAttribute("prevDto", prevDto);
			model.addAttribute("nextDto", nextDto);
			
			model.addAttribute("isUserEventTakers", isUserEventTakers);
			model.addAttribute("listEventTakers", listEventTakers);
			model.addAttribute("listEventWinner", listEventWinner);
			model.addAttribute("userWinner", userWinner);
			
			model.addAttribute("page", page);
			model.addAttribute("query", query);
			
			return "event/article";
			
		} catch (NullPointerException e) {
			log.info("article : ", e);
		} catch (Exception e) {
			log.info("article : ", e);
		}
		
		return "redirect:/event/" + category + "/list?" + query;
	}
	
	
	@ResponseBody
	@PostMapping("progress/apply")
	public Map<String, ?> applySubmit(Event dto, HttpSession session) throws Exception {
		// 이벤트 응모
		Map<String, Object> model = new HashMap<>();
		
		String state = "false";
		try {
			log.info("dto : ", dto.getEvent_num());
			
			Event vo = Objects.requireNonNull(service.findById(dto.getEvent_num()));
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			Date now = new Date();
			Date endDate = sdf.parse(vo.getEndDate());
			if(now.getTime() > endDate.getTime()) {
				model.put("state", "ended");
				return model;
			}
			
			// 진행 예정 이벤트
			Date startDate = sdf.parse(vo.getStartDate());
			if(now.getTime() < startDate.getTime()) {
				model.put("state", "upcoming");
			}
			
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			dto.setMember_id(info.getMember_id());
			service.insertEventTakers(dto);
			
			state = "true";
			
		} catch (NullPointerException e) {
			log.info("applySubmit : ", e);
		} catch (Exception e) {
			log.info("applySubmit : ", e);
		}
		
		model.put("state", state);
		return model;
	}

}
