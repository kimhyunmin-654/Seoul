package com.sp.app.admin.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.admin.model.MemberManage;

@Mapper
public interface MemberManageMapper {
	public int dataCount(Map<String, Object> map);
	public List<MemberManage> listMember(Map<String, Object> map);
	
	public MemberManage findById(Long memeber_id);
	
	public void updateMember(Map<String, Object> map) throws SQLException;
	public void updateMemberLevel(Map<String, Object> map) throws SQLException;
	public void updateMemberEnabled(Map<String, Object> map) throws SQLException;
	public void updateFailureCountReset(Long member_id) throws SQLException;
	public void deleteMember(Map<String, Object> map) throws SQLException;
	
	public void insertMemberStatus(MemberManage dto) throws SQLException;
	public List<MemberManage> listMemberStatus(Long member_id);
	public MemberManage findByStatus(Long member_id);
	
	public List<Map<String, Object>> listAgeSection();
	
}
