package com.sp.app.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.sp.app.model.Event;

public interface EventService {
	public int dataCount(Map<String, Object> map);
	public List<Event> listEvent(Map<String, Object> map);
	
	public void updateHitCount(long event_num) throws SQLException;
	public Event findById(long event_num);
	public Event findByNext(Map<String, Object> map);
	public Event findByPrev(Map<String, Object> map);
	
	// 이벤트 응모
	public void insertEventTakers(Event dto) throws SQLException;
	public List<Event> listEventTakers(long event_num);
	public boolean isuserEventTakers(Map<String, Object> map);
	
	// 이벤트 당첨
	public Event findByEventWinner(Map<String, Object> map);
	public List<Event> listEventWinner(long event_num);
	
	// 이벤트 마감기한
	public String getDDayLabel(String strEndDate);

	// 마이페이지 이벤트 참여내역
	public List<Event> myPageEventList(Map<String, Object> map);
	
	// 이벤트 카테고리
	public int myPageDataCount(Map<String, Object> map);
}
