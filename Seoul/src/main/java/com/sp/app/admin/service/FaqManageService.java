package com.sp.app.admin.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.sp.app.admin.model.FaqManage;

public interface FaqManageService {
	public void insertFaq(FaqManage dto) throws SQLException;
	public void updateFaq(FaqManage dto) throws SQLException;
	public void deleteFaq(long faq_id, Long member_id, int userLevel) throws SQLException;
	public void deleteFaq(long[] faq_ids, Long member_id, int userLevel) throws SQLException;
	
	
	public int dataCount(Map<String, Object> map);
	public List<FaqManage> listFaq(Map<String, Object> map);
	
	public FaqManage findById(long faq_id);
	public void updateHitCount(long faq_id) throws SQLException;
	public FaqManage findByPrev(Map<String, Object> map);
	public FaqManage findByNext(Map<String, Object> map);
}
