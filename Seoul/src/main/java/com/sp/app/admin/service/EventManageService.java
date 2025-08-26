package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import com.sp.app.admin.model.EventManage;

public interface EventManageService {
	public void insertEvent(EventManage dto, String uploadPath) throws Exception;
	public void updateEvent(EventManage dto, String uploadPath) throws Exception;
	public void deleteEvent(long event_num, String uploadPath, int userLevel) throws Exception;
	
	public int dataCount(Map<String, Object> map);
	public List<EventManage> listEvent(Map<String, Object> map);
	
	public EventManage findById(long event_num);
	public EventManage findByNext(Map<String, Object> map);
	public EventManage findByPrev(Map<String, Object> map);
	
	public List<EventManage> listEventTakers(long event_num);
	
	public void insertEventWinner(EventManage dto) throws Exception;
	public List<EventManage> listEventWinner(long event_num);
	
	public boolean deleteUploadFile(String uploadPath, String filename);
}
