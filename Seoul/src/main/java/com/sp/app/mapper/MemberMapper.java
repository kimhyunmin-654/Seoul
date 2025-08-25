package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Member;

@Mapper
public interface MemberMapper {
	public Member loginMember(Map<String, Object> map);
	public Member loginSnsMember(Map<String, Object> map);
	public void updateLastLogin(Long member_id) throws SQLException;

	public Long memberSeq();	
	public void insertMember(Member dto) throws SQLException;
	public void insertMember2(Member dto) throws SQLException;
	public void insertSnsMember(Member dto) throws SQLException;
	
	public void updateMemberEnabled(Map<String, Object> map) throws SQLException;
	public void updateMemberLevel(Map<String, Object> map) throws SQLException;
	public void updateMember(Member dto) throws SQLException;
	
	public int deleteMember(Member dto);
	public void deleteProfilePhoto(Map<String, Object> map) throws SQLException;

	public Member findById(Long member_id);
	public Member findByLoginId(String login_id);
	public Member findByNickName(String nickName);
		
	public List<Member> listFindMember(Map<String, Object> map);
	
	public Member findMemberId(Member dto);
}
