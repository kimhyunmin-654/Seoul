package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Event;

@Mapper
public interface EventMapper {
	public int dataCount(Map<String, Object> map);
	public List<Event> listEvent(Map<String, Object> map);
	
	public Event findById(long event_num);
	public void updateHitCount(long event_num) throws SQLException;
	public Event findByNext(Map<String, Object> map);
	public Event findByPrev(Map<String, Object> map);
	
	// 이벤트 응모
	public void insertEventTakers(Event dto) throws SQLException;
	public Event findByEventTakers(Map<String, Object> map);
	public List<Event> listEventTakers(long event_num);
	
	// 이벤트 당첨
	public Event findByEventWinner(Map<String, Object> map);
	public List<Event> listEventWinner(long event_num);
}
