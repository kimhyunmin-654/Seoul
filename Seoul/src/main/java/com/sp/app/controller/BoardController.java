package com.sp.app.controller;

import java.math.BigDecimal;
import java.net.URI;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;
import com.sp.app.exception.StorageException;
import com.sp.app.model.Board;
import com.sp.app.model.Region;
import com.sp.app.model.Reply;
import com.sp.app.model.Reports;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.BoardService;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/bbs/*")
public class BoardController {
	private final BoardService service;
	private final PaginateUtil paginateUtil;
	private final StorageService storageService;
	private final MyUtil myUtil;
	
	private String uploadPath;
	
	@PostConstruct
	public void init() {
		uploadPath = this.storageService.getRealPath("/uploads/bbs");
	}
	
	@GetMapping("list")
	public String list(@RequestParam(name = "region", defaultValue = "gangnam") String region,
			@ModelAttribute("region_name") String region_name,
			@RequestParam(name = "page", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model,
			HttpServletRequest req) throws Exception {
		
		try {
			region_name = service.getRegionnameById(region);
			
			int size = 8;
			int total_page = 0;
			int dataCount = 0;
			
			kwd = myUtil.decodeUrl(kwd);
			
			Map<String, Object> map = new HashMap<>();
			map.put("region_id", region);
			
			// 검색
			map.put("schType", schType);
			map.put("kwd", kwd);
			
			dataCount = service.dataCount(map);
			if(dataCount != 0) {
				total_page = dataCount / size + (dataCount % size > 0 ? 1 : 0);
			}
			
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			List<Board> list = service.listBoard(map);
			
			String cp = req.getContextPath();
			String query = "";
			String listUrl = cp + "/bbs/list?region=" + region;
			String articleUrl = cp + "/bbs/article?region=" + region + "&page=" + current_page;
			if (! kwd.isBlank()) {
				query = "schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
				
				listUrl += "&" + query;
				articleUrl += "&" + query;
			}
			String paging = paginateUtil.paging(current_page, total_page, listUrl);	
			
			List<Region> regionList = service.listRegion();
			model.addAttribute("regionList", regionList);
			
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

		model.addAttribute("region_name", region_name);
		model.addAttribute("region_code", region);
		model.addAttribute("currentMenu", "bbs/list");
		
		return "bbs/list";
	}
	
	@GetMapping("write")
	public String writeForm(@RequestParam(name = "region", defaultValue = "gangnam") String region, Model model) throws Exception {
		String region_name = "";
		
		try {
			region_name = service.getRegionnameById(region);
			
			List<Region> regionList = service.listRegion();
			model.addAttribute("regionList", regionList);
		} catch (Exception e) {
			log.info("writeForm : ", e);
		}
		
		model.addAttribute("mode", "write");
		model.addAttribute("region_code", region);
		model.addAttribute("region_name", region_name);
		model.addAttribute("currentMenu", "bbs/list");

		return "bbs/write";
	}
	
	@PostMapping("write")
	public String writeSubmit(@RequestParam(name = "region", defaultValue = "gangnam") String region,
			Board dto, HttpSession session) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			dto.setMember_id(info.getMember_id());
			
			service.insertBoard(dto, uploadPath);
			
		} catch (Exception e) {
			log.info("writeSubmit : ", e);
		}
		
		return "redirect:/bbs/list?region=" + region;
	}
	
	@GetMapping("article")
	public String article(@RequestParam(name = "region", defaultValue = "gangnam") String region,
			@RequestParam(name = "num") long num,
			@RequestParam(name = "page") String page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model,
			HttpSession session) throws Exception {
		
		String query = "region=" + region + "&page=" + page;
		String region_name = "";
		try {
			region_name = service.getRegionnameById(region);
			
			kwd = myUtil.decodeUrl(kwd);
			if (! kwd.isBlank()) {
				query += "&schType=" + schType + 
						"&kwd=" + myUtil.encodeUrl(kwd);
			}
			
			service.updateHitCount(num);
			
			Board dto = Objects.requireNonNull(service.findById(num));
			
			Map<String, Object> map = new HashMap<>();
			
			map.put("region_id", region);
			
			map.put("schType", schType);
			map.put("kwd", kwd);
			map.put("num", num);
			
			Board prevDto = service.findByPrev(map);
			Board nextDto = service.findByNext(map);
			
			SessionInfo info = (SessionInfo) session.getAttribute("member");

			List<Region> regionList = service.listRegion();
			model.addAttribute("regionList", regionList);
			
			model.addAttribute("dto", dto);
			model.addAttribute("prevDto", prevDto);
			model.addAttribute("nextDto", nextDto);
			
			model.addAttribute("page", page);
			model.addAttribute("query", query);
			
			model.addAttribute("region_code", region);
			model.addAttribute("region_name", region_name);
			model.addAttribute("currentMenu", "bbs/list");
			
			return "bbs/article";
			
		} catch (NullPointerException e) {
			log.info("article null 예외 : ", e);
		} catch (Exception e) {
			log.info("article 예외 : ", e);
		}
		
		return "redirect:/bbs/list?" + query;
	}
	
	@GetMapping("update")
	public String updateForm(@RequestParam(name = "region", defaultValue = "gangnam") String region,
			@RequestParam(name = "num") long num,
			@RequestParam(name = "page") String page,
			Model model,
			HttpSession session) throws Exception {
		
		String region_name = "";
		
		try {
			region_name = service.getRegionnameById(region);
			
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			Board dto = Objects.requireNonNull(service.findById(num));
			
			if(dto.getMember_id() != info.getMember_id()) {
				return "redirect:/bbs/list?region=" + region + "&page=" + page;
			}

			List<Region> regionList = service.listRegion();
			model.addAttribute("regionList", regionList);
			
			model.addAttribute("dto", dto);
			model.addAttribute("mode", "update");
			model.addAttribute("page", page);
			
			model.addAttribute("region_code", region);
			model.addAttribute("region_name", region_name);
			model.addAttribute("currentMenu", "bbs/list");
			
			return "bbs/write";
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("updateForm : ", e);
		}
		
		return "redirect:/bbs/list?region=" + region + "&page=" + page;
	}
	
	@PostMapping("update")
	public String updateSubmit(Board dto,
			@RequestParam(name = "region", defaultValue = "gangnam") String region,
			@RequestParam(name = "page") String page) throws Exception {
		
		try {
			service.updateBoard(dto, uploadPath);
		} catch (Exception e) {
			log.info("updateSubmit : ", e);
		}
		
		return "redirect:/bbs/list?region=" + region + "&page=" + page;
	}
	
	@GetMapping("deleteFile")
	public String deleteFile(@RequestParam(name = "num") long num,
			@RequestParam(name = "region", defaultValue = "gangnam") String region,
			@RequestParam(name = "page") String page,
			final RedirectAttributes reAttr,
			HttpSession session) throws Exception {
		
		String region_name = "";
		try {
			region_name = service.getRegionnameById(region);
			
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			Board dto = Objects.requireNonNull(service.findById(num));
			
			if(dto.getMember_id() != info.getMember_id()) {
				reAttr.addFlashAttribute("region_name", region_name);
				return "redirect:/bbs/list?region=" + region + "&page=" + page;
			}
			
			if(dto.getSaveFilename() != null) {
				storageService.deleteFile(uploadPath, dto.getSaveFilename());
				
				dto.setSaveFilename("");
				dto.setOriginalFilename("");
				dto.setFilesize(0);
				service.updateBoard(dto, uploadPath);
			}
			
			reAttr.addFlashAttribute("region_name", region_name);
			
			return "redirect:/bbs/update?region=" + region + "&num=" + num + "&page=" + page;
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("deleteFile : ", e);
		}
		
		reAttr.addFlashAttribute("region_name", region_name);
		
		return "redirect:/bbs/list?region=" + region + "&page=" + page;
	}
	
	@GetMapping("delete")
	public String delete(@RequestParam(name = "num") long num,
			@RequestParam(name = "region", defaultValue = "gangnam") String region,
			@RequestParam(name = "page") String page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			final RedirectAttributes reAttr,
			HttpSession session) throws Exception {
		
		String query = "region=" + region + "&page=" + page;
		String region_name = "";
		
		try {
			region_name = service.getRegionnameById(region);
			
			kwd = myUtil.decodeUrl(kwd);
			if(! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
			}
			
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			service.deleteBoard(num, uploadPath, info.getMember_id(), info.getUserLevel());
			
		} catch (Exception e) {
			log.info("delete : ", e);
		}
		
		reAttr.addFlashAttribute("region_name", region_name);
		
		return "redirect:/bbs/list?" + query;
	}
	
	@GetMapping("download")
	public ResponseEntity<?> download(
			@RequestParam(name = "num") long num,
			@RequestParam(name = "region", defaultValue = "gangnam") String region,
			HttpServletRequest req) throws Exception {
		
		try {
			Board dto = Objects.requireNonNull(service.findById(num));
			
			return storageService.downloadFile(uploadPath, dto.getSaveFilename(), dto.getOriginalFilename());
			
		} catch (NullPointerException | StorageException e) {
			log.info("download : ", e);
		} catch (Exception e) {
			log.info("download : ", e);
		}
		
		String redirectUrl = req.getContextPath() + "/bbs/downloadFailed?region=" + region;
		return ResponseEntity
				.status(HttpStatus.FOUND)
				.location(URI.create(redirectUrl))
				.build();
	}
	
	@GetMapping("downloadFailed")
	public String downloadFailed(@RequestParam(name = "region", defaultValue = "gangnam") String region) {
		return "error/downloadFailure";
	}
	
	
	// 게시글 좋아요 : AJAX-JSON
	@ResponseBody
	@PostMapping("boardLike/{num}")
	public Map<String, ?> insertBoardLike(@PathVariable(name = "num") long num,
			HttpSession session) {
		
		Map<String, Object> model = new HashMap<>();

		String state = "true";
		int boardLikeCount = 0;
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			Map<String, Object> paramMap = new HashMap<>();
			paramMap.put("num", num);
			paramMap.put("member_id", info.getMember_id());
			
			service.insertBoardLike(paramMap);
			
			boardLikeCount = service.boardLikeCount(num);
			
		} catch (DuplicateKeyException e) {
			state = "liked";
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		model.put("communityLikeCount", boardLikeCount);
		
		return model;
	}
	
	@ResponseBody
	@DeleteMapping("boardLike/{num}")
	public Map<String, ?> deleteBoardLike(@PathVariable(name = "num") long num,
			HttpSession session) {
		
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		int boardLikeCount = 0;
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			Map<String, Object> paramMap = new HashMap<>();
			paramMap.put("num", num);
			paramMap.put("member_id", info.getMember_id());
			
			service.deleteBoardLike(paramMap);
			
			boardLikeCount = service.boardLikeCount(num);
			
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		model.put("communityLikeCount", boardLikeCount);
		
		return model;
	}
	
	
	// 댓글 리스트 : AJAX-TEXT
	@GetMapping("listReply")
	public String listReply(@RequestParam(name = "num") long num, 
			@RequestParam(name = "pageNo", defaultValue = "1") int current_page,
			Model model,
			HttpServletResponse resp,
			HttpSession session) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			int size = 5;
			int total_page = 0;
			int dataCount = 0;
			
			Map<String, Object> map = new HashMap<>();
			map.put("num", num);
			
			if(info != null) {
				map.put("userLevel", info.getUserLevel());
				map.put("member_id", info.getMember_id());
			}
			
			dataCount = service.replyCount(map);
			total_page = paginateUtil.pageCount(dataCount, size);
			current_page = Math.min(current_page, total_page);
			
			int offset = (current_page - 1) * size;
			if(offset < 0) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			List<Long> blockList = service.findBlockMemberById(info.getMember_id());
			List<Reply> listReply = service.listReply(map, blockList);
			
			String paging = paginateUtil.pagingMethod(current_page, total_page, "listPage");
			
			model.addAttribute("listReply", listReply);
			model.addAttribute("pageNo", current_page);
			model.addAttribute("replyCount", dataCount);
			model.addAttribute("total_page", total_page);
			model.addAttribute("paging", paging);
			
		} catch (Exception e) {
			log.info("listReply : ", e);
			
			resp.sendError(406);
			throw e;
		}
		
		return "bbs/listReply";
	}
	
	// 댓글 및 답글 등록 : AJAX-JSON
	@ResponseBody
	@PostMapping("insertReply")
	public Map<String, ?> insertReply(Reply dto, HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			dto.setMember_id(info.getMember_id());
			service.insertReply(dto);
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		return model;
	}
	
	// 댓글 및 답글 삭제 : AJAX-JSON
	@ResponseBody
	@PostMapping("deleteReply")
	public Map<String, ?> deleteReply(@RequestParam Map<String, Object> paramMap) {
		Map<String, Object> model = new HashMap<>();

		String state = "true";
		try {
			service.deleteReply(paramMap);
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		return model;
	}
	
	// 답글 리스트 : AJAX-TEXT
	@GetMapping("listReplyAnswer")
	public String listReplyAnswer(@RequestParam Map<String, Object> paramMap,
			Model model,
			HttpServletResponse resp,
			HttpSession session) throws Exception {

		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			paramMap.put("userLevel", info.getUserLevel());
			paramMap.put("member_id", info.getMember_id());
			
			// 차단
			List<Long> blockList = service.findBlockMemberById(info.getMember_id());
			
			List<Reply> listReplyAnswer = service.listReplyAnswer(paramMap, blockList);
			
			int pageNo = Integer.parseInt(paramMap.getOrDefault("pageNo", "1").toString());
			
			model.addAttribute("listReplyAnswer", listReplyAnswer);
			model.addAttribute("pageNo", pageNo);
			
		} catch (Exception e) {
			log.info("listReplyAnswer : ", e);
			
			resp.sendError(406);
			throw e;
		}
		
		return "bbs/listReplyAnswer";
	}
	
	// 답글 개수 : AJAX-JSON
	@ResponseBody
	@PostMapping(value = "countReplyAnswer")
	public Map<String, ?> countReplyAnswer(@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		int count = 0;
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			paramMap.put("member_id", info.getMember_id());
			paramMap.put("userLevel", info.getUserLevel());
			
			count = service.replyAnswerCount(paramMap);

		} catch (Exception e) {
			log.info("countReplyAnswer : ", e);
		}
		
		model.put("count", count);
		return model;
	}
	
	// 댓글 좋아요/싫어요 : AJAX-JSON
	@ResponseBody
	@PostMapping("insertReplyLike")
	public Map<String, ?> insertReplyLike(@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		int likeCount = 0;
		int disLikeCount = 0;
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			paramMap.put("member_id", info.getMember_id());
			service.insertReplyLike(paramMap);
			
			Map<String, Object> countMap = service.replyLikeCount(paramMap);
			
			likeCount = ((BigDecimal)countMap.get("LIKECOUNT")).intValue();
			disLikeCount = ((BigDecimal)countMap.get("DISLIKECOUNT")).intValue();
			
		} catch (DuplicateKeyException e) {
			state = "liked";
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("likeCount", likeCount);
		model.put("disLikeCount", disLikeCount);
		model.put("state", state);
		
		return model;
	}
	
	@ResponseBody
	@PostMapping("deleteReplyLike")
	public Map<String, ?> deleteReplyLike(@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		int likeCount = 0;
		int disLikeCount = 0;
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			paramMap.put("member_id", info.getMember_id());
			service.deleteReplyLike(paramMap);
			
			Map<String, Object> countMap = service.replyLikeCount(paramMap);
			
			likeCount = ((BigDecimal)countMap.get("LIKECOUNT")).intValue();
			disLikeCount = ((BigDecimal)countMap.get("DISLIKECOUNT")).intValue();
			
		} catch (DuplicateKeyException e) {
			state = "deleted";
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("likeCount", likeCount);
		model.put("disLikeCount", disLikeCount);
		model.put("state", state);
		
		return model;
	}
	
	// 숨김 : AJAX-JSON
	@ResponseBody
	@PostMapping("replyShowHide")
	public Map<String, ?> replyShowHide(@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			paramMap.put("member_id", info.getMember_id());
			service.updateReplyShowHide(paramMap);
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		return model;
	}
	
	
	// 차단
	// 사용자 차단
	@ResponseBody
	@PostMapping("insertBlockMember")
	public Map<String, ?> insertBlockMember(@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			paramMap.put("member_id", info.getMember_id());
			
			service.insertBlockMember(paramMap);
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		return model;
	}
	
	@ResponseBody
	@PostMapping("deleteBlockMember")
	public Map<String, ?> userBlockMember(@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			paramMap.put("member_id", info.getMember_id());
			
			service.deleteBlockMember(paramMap);
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		return model;
	}
	
	// 관리자 차단
	@ResponseBody
	@PostMapping("updateReplyBlockByManager")
	public Map<String, ?> updateReplyBlockByManager(@RequestParam Map<String, Object> paramMap,
			HttpSession session) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			int userLevel = info.getUserLevel();
			
			service.updateReplyBlockByManager(paramMap, userLevel);
		} catch (RuntimeException e) {
			if(e.getMessage().equals("관리자만 가능한 작업입니다.")) {
				state = "access-denied";
			} else {
				state = "false";
			}
		}
		
		model.put("state", state);
		return model;
	}
	
	
	// 신고 : AJAX-JSON
	@ResponseBody
	@PostMapping("insertCommunityReports")
	public Map<String, ?> insertCommunityReports(Reports dto, HttpSession session, HttpServletRequest req) {
		Map<String, Object> model = new HashMap<>();
		
		String state = "true";
		
		try {
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			
			dto.setReported_by(info.getMember_id());
			dto.setReport_ip(req.getRemoteAddr());
			
			service.insertCommunityReports(dto);
			
		} catch (DuplicateKeyException e) {
			state = "reported";
		} catch (Exception e) {
			state = "false";
		}
		
		model.put("state", state);
		
		return model;
	}

}
