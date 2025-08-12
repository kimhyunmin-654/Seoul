package com.sp.app.admin.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.admin.model.NoticeManage;
import com.sp.app.admin.service.NoticeManageService;
import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;
import com.sp.app.exception.StorageException;
import com.sp.app.model.SessionInfo;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/admin/noticeManage/*")
public class NoticeManageController {
	private final NoticeManageService service;
	private final PaginateUtil paginateUtil;
	private final StorageService storageService;
	private final MyUtil myUtil;
	
	private String uploadPath;
	
	@PostConstruct
	public void init() {
		uploadPath = this.storageService.getRealPath("/uploads/notice");
	}
	
	@GetMapping("list")
	public String list(@RequestParam(name = "page", defaultValue = "1") int current_page,
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model,
			HttpServletRequest req) throws Exception {
		
		try {
			int size = 10;
			int total_page = 0;
			int dataCount = 0;
			
			kwd = myUtil.decodeUrl(kwd);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			
			dataCount = service.dataCount(map);
			if(dataCount != 0) {
				total_page = paginateUtil.pageCount(dataCount, size);
			}
			
			//다른사람이 자료를 삭제하여 전체페이수가 변환 된경우
			current_page = Math.min(current_page, total_page);
			
			//1페이지인경우 공지리스트 가져오기
			List<NoticeManage> noticeList = null;
			if(current_page == 1) {
				noticeList = service.listNoticeTop();
			}
			
			//리스트에 출력할 데이터를 가져오기
			int offset = (current_page - 1) * size;
			if(offset < 0 ) offset = 0;
			
			map.put("offset", offset);
			map.put("size", size);
			
			//글리스트
			List<NoticeManage> list = service.listNotice(map);
			
			String cp = req.getContextPath();
			String query = "";
			String listUrl = cp + "/admin/noticeManage/list";
			if(! kwd.isBlank()) {
				query = "schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
				
				listUrl += "?" + query;
			}
			
			String paging = paginateUtil.paging(current_page, total_page, listUrl);
			
			model.addAttribute("noticeList", noticeList);
			model.addAttribute("list", list);
			model.addAttribute("page", current_page);
			model.addAttribute("dataCount", dataCount);
			model.addAttribute("size", size);
			model.addAttribute("total_page", total_page);
			model.addAttribute("paging", paging);
			
			model.addAttribute("schType", schType);
			model.addAttribute("kwd", kwd);
			
		} catch (Exception e) {
			log.info("list : ", e);
		}
		
		return "admin/noticeManage/list";
	}
	
	@GetMapping("write")
	public String writeForm(Model model, HttpSession session) throws Exception {
		model.addAttribute("mode", "write");
		
		return "admin/noticeManage/write";
	}
	
	@PostMapping("write")
	public String writeSubmit(NoticeManage dto, HttpSession session) throws Exception {
		
		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			
			dto.setMember_id(info.getMember_id());
			service.insertNotice(dto, uploadPath);
		} catch (Exception e) {
			log.info("writeSubmit : ", e);
		}
		
		return "redirect:/admin/noticeManage/list";
	}
	
	@GetMapping("article/{num}")
	public String article(@PathVariable(name = "num") long num,
			@RequestParam(name = "page") String page,
			@RequestParam(name = "schType", defaultValue = "all") String schType, 
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			Model model) throws Exception {
		
		String query = "page=" + page;
		try {
			kwd = myUtil.decodeUrl(kwd);
			
			if(! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
			}
			
			service.updateHitCount(num);
			
			NoticeManage dto = Objects.requireNonNull(service.findById(num));
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("schType", schType);
			map.put("kwd", kwd);
			map.put("modify_date", dto.getModify_date());
			
			NoticeManage prevDto = service.findByPrev(map);
			NoticeManage nextDto = service.findByNext(map);
			
			//파일
			List<NoticeManage> listFile = service.listNoticeFile(num);
			
			model.addAttribute("dto", dto);
			model.addAttribute("prevDto", prevDto);
			model.addAttribute("nextDto", nextDto);
			model.addAttribute("listFile", listFile);
			model.addAttribute("page", page);
			model.addAttribute("query", query);
			
			return "admin/noticeManage/article";
			
		} catch (NullPointerException e) {
			log.info("article : ", e);
		} catch (Exception e) {
			log.info("article : ", e);
		}
		
		return "redirect:/admin/noticeManage/list?" + query;
	}
	
	@GetMapping("update")
	public String updateForm(@RequestParam(name = "num") long num,
			@RequestParam(name = "page") String page,
			Model model,
			HttpSession session) throws Exception {
		
		try {
			
			NoticeManage dto = Objects.requireNonNull(service.findById(num));
			
			List<NoticeManage> listFile = service.listNoticeFile(num);
			
			model.addAttribute("mode", "update");
			model.addAttribute("page", page);
			model.addAttribute("dto", dto);
			model.addAttribute("listFile", listFile);
			
			return "admin/noticeManage/write";
			
		} catch (NullPointerException e) {
			log.info("updateForm : ", e);
		} catch (Exception e) {
			log.info("updateForm : ", e);
		}
		
		return "redirect:/admin/noticeManage/list?page=" + page;
	}
	
	@PostMapping("update")
	public String updateSubmit(NoticeManage dto,
	        @RequestParam(name = "page") String page,
	        HttpSession session) throws Exception {

	    try {
	        service.updateNotice(dto, uploadPath);

	    } catch (Exception e) {
	        log.info("updateSubmit : ", e);
	    }

	    return "redirect:/admin/noticeManage/list?page=" + page;
	}
	
	@GetMapping("delete")
	public String delete(@RequestParam(name = "num") long num,
			@RequestParam(name = "page") String page, 
			@RequestParam(name = "schType", defaultValue = "all") String schType,
			@RequestParam(name = "kwd", defaultValue = "") String kwd,
			HttpSession session) throws Exception {
		
		String query = "page=" + page;
		try {
			kwd = myUtil.decodeUrl(kwd);
			if(! kwd.isBlank()) {
				query += "&schType=" + schType + "&kwd=" + myUtil.encodeUrl(kwd);
			}
			
			service.deleteNotice(num, uploadPath);
			
		} catch (Exception e) {
			log.info("delete : ", e);
		}
		
		return "redirect:/admin/noticeManage/list?" + query;
	}
	
	@GetMapping("download/{fileNum}")
	public ResponseEntity<?> download(
			@PathVariable(name = "fileNum") long fileNum) throws Exception {
		
		try {
			NoticeManage dto = Objects.requireNonNull(service.findByFileId(fileNum));
			
			return storageService.downloadFile(uploadPath, dto.getSave_filename(), dto.getOriginal_filename());
		} catch (NullPointerException | StorageException e) {
			log.info("download : ", e);
		} catch (Exception e) {
			log.info("download : ", e);
		}
		
		String errorMessage = "<script>alert('파일 다운로드가 불가능 합니다!!!');history.back();</script>";
		
		return ResponseEntity.status(HttpStatus.NOT_FOUND)//404상태 코드 반환
				.contentType(MediaType.valueOf("text/html;charset=UTF-8"))
				.body(errorMessage);//에러메시지 반환
	}
	
	@GetMapping("zipdownload/{num}")
	public ResponseEntity<?> zipdownload(@PathVariable(name = "num") long num) throws Exception {
		try {
			List<NoticeManage> listFile = service.listNoticeFile(num);
			if(listFile.size() > 0) {
				String[] source = new String[listFile.size()];
				String[] originals = new String[listFile.size()];
				String fileName = listFile.get(0).getOriginal_filename();
				String zipFilename = fileName.substring(0, fileName.lastIndexOf(".")) + "_외.zip";
				
				for(int idx = 0; idx < listFile.size(); idx++) {
					source[idx] = uploadPath + File.separator + listFile.get(idx).getSave_filename();
					originals[idx] = File.separator + listFile.get(idx).getOriginal_filename();
				}
				
				return storageService.downloadZipFile(source, originals, zipFilename);
			}
			
		} catch (Exception e) {
			log.info("zipdownload : ", e);
		}
		
		String errorMessage = "<script>alert('파일 다운로드가 불가능 합니다. !!!');history.back();</script>";
		
		return ResponseEntity.status(HttpStatus.NOT_FOUND)
				.contentType(MediaType.valueOf("text/html;charset=UTF-8"))
				.body(errorMessage);
	}
	
	@ResponseBody
	@PostMapping("deleteFile")
	public Map<String, ?> deleteFile(@RequestParam(name = "fileNum") long fileNum,
			HttpSession session) throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		String state = "false";
		
		try {
			NoticeManage dto = Objects.requireNonNull(service.findByFileId(fileNum));
			
			service.deleteUploadFile(uploadPath, dto.getSave_filename());
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("field", "fileNum");
			map.put("num", fileNum);
			
			service.deleteNoticeFile(map);
			
			state = "true";
			
		} catch (NullPointerException e) {
			log.info("deleteFile : ", e);
		} catch (Exception e) {
			log.info("deleteFile : ", e);
		}
		
		//작업 결과를 json으로 전송
		model.put("state", state);
		return model;
	}
}
