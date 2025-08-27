package com.sp.app.service;

import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;

import com.sp.app.mapper.EventMapper;
import com.sp.app.model.Event;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class EventServiceImpl implements EventService {
	private final EventMapper mapper;
	
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
	public List<Event> listEvent(Map<String, Object> map) {
		List<Event> list = null;
		
		try {
			list = mapper.listEvent(map);
		} catch (Exception e) {
			log.info("listEvent : ", e);
		}
		
		return list;
	}

	@Override
	public void updateHitCount(long event_num) throws SQLException {
		try {
			mapper.updateHitCount(event_num);
		} catch (Exception e) {
			log.info("updateHitCount : ", e);
			throw e;
		}
	}

	@Override
	public Event findById(long event_num) {
		Event dto = null;
		
		try {
			dto = Objects.requireNonNull(mapper.findById(event_num));
			
			dto.setSday(dto.getStartDate().substring(0, 10));
			dto.setStime(dto.getStartDate().substring(11));
			
			dto.setEday(dto.getEndDate().substring(0, 10));
			dto.setEtime(dto.getEndDate().substring(11));
			
			if(dto.getWinningDate() != null && dto.getWinningDate().length() != 0) {
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
	public Event findByNext(Map<String, Object> map) {
		Event dto = null;
		
		try {
			dto = mapper.findByNext(map);
		} catch (Exception e) {
			log.info("findByNext : ", e);
		}
		
		return dto;
	}

	@Override
	public Event findByPrev(Map<String, Object> map) {
		Event dto = null;
		
		try {
			dto = mapper.findByPrev(map);
		} catch (Exception e) {
			log.info("findByPrev : ", e);
		}
		
		return dto;
	}

	
	// 응모 이벤트
	@Override
	public void insertEventTakers(Event dto) throws SQLException {
		try {
			mapper.insertEventTakers(dto);
		} catch (Exception e) {
			log.info("insertEventTakers : ", e);
			throw e;
		}
	}

	@Override
	public List<Event> listEventTakers(long event_num) {
		List<Event> list = null;
		
		try {
			list = mapper.listEventTakers(event_num);
		} catch (Exception e) {
			log.info("listEventTakers : ", e);
		}
		
		return list;
	}
	
	@Override
	public boolean isuserEventTakers(Map<String, Object> map) {
		boolean result = false;
		
		try {
			Event dto = mapper.findByEventTakers(map);
			if(dto != null) {
				result = true;
			}
		} catch (Exception e) {
			log.info("listEventTakers : ", e);
		}
		
		return result;
	}

	@Override
	public Event findByEventWinner(Map<String, Object> map) {
		Event dto = null;
		
		try {
			dto = mapper.findByEventWinner(map);
		} catch (Exception e) {
			log.info("findByEventWinner : ", e);
		}
		
		return dto;
	}

	@Override
	public List<Event> listEventWinner(long event_num) {
		List<Event> list = null;
		
		try {
			list = mapper.listEventWinner(event_num);
		} catch (Exception e) {
			log.info("listEventWinner : ", e);
		}
		
		return list;
	}

	@Override
	public String getDDayLabel(String strEndDate) {
		String result = "";
		
		try {
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
			LocalDateTime endDate = LocalDateTime.parse(strEndDate, dtf);
			LocalDateTime now = LocalDateTime.now();
			Duration duration = Duration.between(now, endDate);
			
			if(duration.isNegative()) {
				result = "종료됨";
			} else if(duration.toDays() >= 7) {
				result = "more";
			} else if(duration.toDays() >= 1) {
				result = "D-" + duration.toDays();
			} else if(duration.toHours() >= 1) {
				result = duration.toHours() + "시간 후 종료";
			} else if(duration.toMinutes() > 0) {
				result = duration.toMinutes() + "분 남음";
			} else {
				result = "곧 마감";
			}
			
		} catch (DateTimeParseException e) {
			log.info("getDDayLabel", e);
		} catch (Exception e) {
			log.info("getDDayLabel", e);
		}
		
		return result;
	}

	
	// 마이페이지 이벤트 참여내역
	@Override
	public List<Event> myPageEventList(Map<String, Object> map) {
		List<Event> list = null;
		
		try {
			list = mapper.myPageEventList(map);
		} catch (Exception e) {
			log.info("myPageEventList", e);
		}
		
		return list;
	}

	@Override
	public int myPageDataCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.myPageDataCount(map);
		} catch (Exception e) {
			log.info("myPageDataCount : ", e);
		}
		
		return result;
	}
	
}
