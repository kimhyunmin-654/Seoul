package com.sp.app.admin.service;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;

import com.sp.app.admin.mapper.EventManageMapper;
import com.sp.app.admin.model.EventManage;
import com.sp.app.common.StorageService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class EventManageServiceImpl implements EventManageService {
	private final EventManageMapper mapper;
	private final StorageService storageService;

	@Override
	public void insertEvent(EventManage dto, String uploadPath) throws Exception {
		try {
			if( ! dto.getSelectFile().isEmpty()) {
				String saveFilename = storageService.uploadFileToServer(dto.getSelectFile(), uploadPath);
				dto.setSaveFilename(saveFilename);
				dto.setOriginalFilename(dto.getSelectFile().getOriginalFilename());
				
				dto.setFilesize(dto.getSelectFile().getSize());
			}
			
			// 이벤트 시작일, 종료일
			dto.setStartDate(dto.getSday() + " " + dto.getStime() + ":00");
			dto.setEndDate(dto.getEday() + " " + dto.getEtime() + ":00");
			
			if(dto.getWinner_number() != 0 && dto.getWday().length() != 0 && dto.getWtime().length() != 0) {
				dto.setWinningDate(dto.getWday() + " " + dto.getWtime() + ":00");
			}
			
			mapper.insertEvent(dto);
		} catch (Exception e) {
			log.info("insertEvent : ", e);
			
			throw e;
		}
	}

	@Override
	public void updateEvent(EventManage dto, String uploadPath) throws Exception {
		try {
			if(dto.getSelectFile() != null && ! dto.getSelectFile().isEmpty()) {
				if(! dto.getSaveFilename().isBlank()) {
					deleteUploadFile(uploadPath, dto.getSaveFilename());
				}
				
				String saveFilename = storageService.uploadFileToServer(dto.getSelectFile(), uploadPath);
				dto.setSaveFilename(saveFilename);
				dto.setOriginalFilename(dto.getSelectFile().getOriginalFilename());
				
				dto.setFilesize(dto.getSelectFile().getSize());
			}
			
			dto.setStartDate(dto.getSday() + " " + dto.getStime());
			dto.setEndDate(dto.getEday() + " " + dto.getEtime());
			
			if(dto.getWinner_number() != 0 && dto.getWday().length() != 0 && dto.getWtime().length() != 0) {
				dto.setWinningDate(dto.getWday() + " " + dto.getWtime());
			}
			
			mapper.updateEvent(dto);
		} catch (Exception e) {
			log.info("updateEvent : ", e);
			
			throw e;
		}
	}

	@Override
	public void deleteEvent(long event_num, String uploadPath, int userLevel) throws Exception { // userLevel, member_id?
		try {
			EventManage dto = Objects.requireNonNull(findById(event_num));
			
			// 관리자만 글 삭제 가능
			if(userLevel != 9) {
				return;
			}
			
			deleteUploadFile(uploadPath, dto.getSaveFilename());
			
			mapper.deleteEvent(event_num);
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("deleteEvent : ", e);
			
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
	public List<EventManage> listEvent(Map<String, Object> map) {
		List<EventManage> list = null;
		
		try {
			list = mapper.listEvent(map);
			
		} catch (Exception e) {
			log.info("listEvent : ", e);
		}
		
		return list;
	}

	@Override
	public EventManage findById(long event_num) {
		EventManage dto = null;
		
		try {
			dto = Objects.requireNonNull(mapper.findById(event_num));
			
			dto.setSday(dto.getStartDate().substring(0, 10));
			dto.setStime(dto.getStartDate().substring(11));
			
			dto.setEday(dto.getEndDate().substring(0, 10));
			dto.setEtime(dto.getEndDate().substring(11));
			
			if(dto.getWinner_number() != 0 && dto.getEvent_type().equals("ENTRY")) {
				dto.setWday(dto.getWinningDate().substring(0, 10));
				dto.setWtime(dto.getWinningDate().substring(11));
			}
			
		} catch (NullPointerException e) {
		} catch (Exception e) {
			log.info("findById : ", e);
		}
		
		return dto;
	}

	@Override
	public EventManage findByNext(Map<String, Object> map) {
		EventManage dto = null;
		
		try {
			dto = mapper.findByNext(map);
		} catch (Exception e) {
			log.info("findByNext : ", e);
		}
		
		return dto;
	}
	
	@Override
	public EventManage findByPrev(Map<String, Object> map) {
		EventManage dto = null;
		
		try {
			dto = mapper.findByPrev(map);
		} catch (Exception e) {
			log.info("findByPrev : ", e);
		}
		
		return dto;
	}

	@Override
	public List<EventManage> listEventTakers(long event_num) {
		List<EventManage> list = null;
		
		try {
			list = mapper.listEventTakers(event_num);
		} catch (Exception e) {
			log.info("listEventTakers : ", e);
		}
		
		return list;
	}

	@Override
	public void insertEventWinner(EventManage dto) throws Exception {
		try {
			if(dto.getWinEvent() == 1) { // 순위 없음
				mapper.insertEventWinner1(dto);
			} else { // 순위별 당첨
				List<EventManage> list = listEventTakers(dto.getEvent_num());
				Collections.shuffle(list);
				
				int idx = 0;
				
				jump:
				for(int i = 0; i < dto.getRankCount().size(); i++) {
					for(int j = 0; j < dto.getRankCount().get(i); j++) {
						if(idx >= list.size()) {
							break jump;
						}
						
						dto.setMember_id(list.get(idx).getMember_id());
						dto.setRank(dto.getRankNum().get(i));
						
						mapper.insertEventWinner2(dto);
						
						idx++;
					}
				}
			}
			
		} catch (Exception e) {
			log.info("insertEventWinner : ", e);
			
			throw e;
		}
	}

	@Override
	public List<EventManage> listEventWinner(long event_num) {
		List<EventManage> list = null;
		
		try {
			list = mapper.listEventWinner(event_num);
		} catch (Exception e) {
			log.info("listEventWinner : ", e);
		}
		
		return list;
	}
	
	// 파일 삭제
	@Override
	public boolean deleteUploadFile(String uploadPath, String filename) {
		return storageService.deleteFile(uploadPath, filename);
	}
}
