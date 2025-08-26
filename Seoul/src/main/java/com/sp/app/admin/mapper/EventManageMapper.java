package com.sp.app.admin.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.admin.model.EventManage;

@Mapper
public interface EventManageMapper {
	public void insertEvent(EventManage dto) throws SQLException;
	public void updateEvent(EventManage dto) throws SQLException;
	public void deleteEvent(long event_num) throws SQLException;

	public int dataCount(Map<String, Object> map);
	public List<EventManage> listEvent(Map<String, Object> map);

	public EventManage findById(long event_num);
	public EventManage findByNext(Map<String, Object> map);
	public EventManage findByPrev(Map<String, Object> map);

	public List<EventManage> listEventTakers(long event_num);
	
	public void insertEventWinner1(EventManage dto) throws SQLException;
	public void insertEventWinner2(EventManage dto) throws SQLException;
	
	public List<EventManage> listEventWinner(long event_num);
}
