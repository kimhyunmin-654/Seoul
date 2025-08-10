package com.sp.app.admin.service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.sp.app.admin.mapper.NoticeManageMapper;
import com.sp.app.admin.model.NoticeManage;
import com.sp.app.common.StorageService;
import com.sp.app.exception.StorageException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class NoticeManageServiceImpl implements NoticeManageService {
	private final NoticeManageMapper mapper;
	private final StorageService storageService;
	
	@Override
	public void insertNotice(NoticeManage dto, String uploadPath) throws Exception {
		try {
			long seq = mapper.notice_seq();
			dto.setNum(seq);
			
			mapper.insertNotice(dto);
			
			//파일업로드
			if(! dto.getSelectFile().isEmpty()) {
				insertNoticeFile(dto, uploadPath);
			}
			
		} catch (Exception e) {
			log.info("insertNotice : ", e);
			
			throw e;
		}
	}

	@Override
	public int dataCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.dataCount(map);
		} catch (Exception e) {
			log.info("dataCount : ", e);
		}
		return result;
	}

	@Override
	public List<NoticeManage> listNoticeTop() {
		List<NoticeManage> list = null;
		
		try {
			list = mapper.listNoticeTop();
		} catch (Exception e) {
			log.info("listNoticeTop : ", e);
		}
		return list;
	}
	
	@Override
	public List<NoticeManage> listNotice(Map<String, Object> map) {
		List<NoticeManage> list = null;
		
		try {
			list = mapper.listNotice(map);
			
			long gap;
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			LocalDateTime today = LocalDateTime.now();
			for(NoticeManage dto : list) {
				LocalDateTime dateTime = LocalDateTime.parse(dto.getReg_date(), formatter);
				gap = dateTime.until(today, ChronoUnit.HOURS);
				dto.setGap(gap);
				
				dto.setReg_date(dto.getReg_date().substring(0, 10));
			}
		} catch (Exception e) {
			log.info("listNotice : ", e);
		}
		return list;
	}

	@Override
	public void updateHitCount(long num) throws Exception {
		try {
			mapper.updateHitCount(num);
		} catch (Exception e) {
			log.info("updateHitCount ; ", e);
			
			throw e;
		}
		
	}

	@Override
	public NoticeManage findById(long num) {
		NoticeManage dto = null;
		
		try {
			dto = mapper.findById(num);
		} catch (Exception e) {
			log.info("findById : ", e);
		}
		return dto;
	}

	@Override
	public NoticeManage findByPrev(Map<String, Object> map) {
		NoticeManage dto = null;
		
		try {
			dto = mapper.findByPrev(map);
		} catch (Exception e) {
			log.info("findByPrev : ", e);
		}
		return dto;
	}

	@Override
	public NoticeManage findByNext(Map<String, Object> map) {
		NoticeManage dto = null;
		
		try {
			dto = mapper.findByNext(map);
		} catch (Exception e) {
			log.info("findByNext : ", e);
		}
		return dto;
	}


	@Override
	public void updateNotice(NoticeManage dto, String uploadPath) throws Exception {
		try {
			mapper.updateNotice(dto);
			
			if(! dto.getSelectFile().isEmpty()) {
				insertNoticeFile(dto, uploadPath);
			}
		} catch (Exception e) {
			log.info("updateNotice : ", e);
			
			throw e;
		}
	}

	@Override
	public void deleteNotice(long num, String uploadPath) throws Exception {
		try {
			//파일 지우기
			List<NoticeManage> listFile = listNoticeFile(num);
			if(listFile != null) {
				for(NoticeManage dto : listFile) {
					deleteUploadFile(uploadPath, dto.getSave_filename());
				}
			}
			
			//파일 테이블 내용 지우기
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("field", "num");
			map.put("num", num);
			deleteNoticeFile(map);
			
			//게시글 지우기
			mapper.deleteNotice(num);
		} catch (Exception e) {
			log.info("deleteNotice : ", e);
			
			throw e;
		}
		
	}

	@Override
	public List<NoticeManage> listNoticeFile(long num) {
		List<NoticeManage> listFile = null;
		
		try {
			listFile = mapper.listNoticeFile(num);
		} catch (Exception e) {
			log.info("listNoticeFile : ", e);
		}
		return listFile;
	}

	@Override
	public NoticeManage findByFileId(long fileNum) {
		NoticeManage dto = null;
		
		try {
			dto = mapper.findByFileId(fileNum);
		} catch (Exception e) {
			log.info("findByFileId : ", e);
		}
		return dto;
	}

	@Override
	public void deleteNoticeFile(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteNoticeFile(map);
		} catch (Exception e) {
			log.info("deleteNoticeFile : ", e);
			
			throw e;
		}
		
	}

	@Override
	public boolean deleteUploadFile(String uploadPath, String filename) {
		return storageService.deleteFile(uploadPath, filename);
	}
	protected void insertNoticeFile(NoticeManage dto, String uploadPath) throws Exception {
		for(MultipartFile mf : dto.getSelectFile()) {
			try {
				String save_filename = Objects.requireNonNull(storageService.uploadFileToServer(mf, uploadPath));
				
				String original_filename = mf.getOriginalFilename();
				long filesize = mf.getSize();
				
				dto.setOriginal_filename(original_filename);
				dto.setSave_filename(save_filename);
				dto.setFilesize(filesize);
				
				mapper.insertNoticeFile(dto);
			} catch (NullPointerException e) {
			} catch (StorageException e) {
			} catch (Exception e) {
				throw e;
			}
		}
	}
}
