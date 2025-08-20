package com.sp.app.admin.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.sp.app.admin.model.MemberManage;

public interface MemberManageService {
	public int dataCount(Map<String, Object> map);
	public List<MemberManage> listMember(Map<String, Object> map);
	
	public MemberManage findById(Long member_id);
	
	public void updateMember(Map<String, Object> map) throws Exception;
	public void updateMemberLevel(Map<String, Object> map) throws Exception;
	public void updateMemberEnabled(Map<String, Object> map) throws Exception;
	public void updateFailureCountReset(Long member_id) throws Exception;
	public void deleteMember(Map<String, Object> map) throws SQLException;
	
	public void insertMemberStatus(MemberManage dto) throws Exception;
	public List<MemberManage> listMemberStatus(Long member_id);
	public MemberManage findByStatus(Long member_id);
	
	public List<Map<String, Object>> listAgeSection();

}
