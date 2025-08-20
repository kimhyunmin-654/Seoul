package com.sp.app.admin.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.admin.mapper.MemberManageMapper;
import com.sp.app.admin.model.MemberManage;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberManageServiceImpl implements MemberManageService {
	private final MemberManageMapper mapper;
	
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
	public List<MemberManage> listMember(Map<String, Object> map) {
		List<MemberManage> list = null;
		
		try {
			list = mapper.listMember(map);
		} catch (Exception e) {
			log.info("listMember : ", e);
		}
		return list;
	}

	@Transactional(rollbackFor = {Exception.class})
	@Override
	public MemberManage findById(Long member_id) {
		MemberManage dto = null;
		
		try {
			//파라미터로 입력된 값이 null이면 nullpointexception 발생하고 null이 아니면 입력값 그대로 반환
			dto = Objects.requireNonNull(mapper.findById(member_id));
			
		} catch (NullPointerException e) {
		} catch (ArrayIndexOutOfBoundsException e) {
		} catch (Exception e) {
			log.info("findById : ", e);
		}
		
		return dto;
	}

	@Override
	public void updateMember(Map<String, Object> map) throws Exception {
		try {
			mapper.updateMember(map);
		} catch (Exception e) {
			log.info("updateMember : ", e);
			
			throw e;
		}
		
	}

	@Override
	public void updateMemberLevel(Map<String, Object> map) throws Exception {
		try {
			mapper.updateMemberLevel(map);
		} catch (Exception e) {
			log.info("updateMember : ", e);
			
			throw e;
		}
		
	}

	@Override
	public void updateMemberEnabled(Map<String, Object> map) throws Exception {
		try {
			mapper.updateMemberEnabled(map);
		} catch (Exception e) {
			log.info("updateMemberEnabled : ", e);
			
			throw e;
		}
		
	}

	@Override
	public void updateFailureCountReset(Long member_id) throws Exception {
		try {
			mapper.updateFailureCountReset(member_id);
		} catch (Exception e) {
			log.info("updateFailureCountReset : ", e);
			
			throw e;
		}
		
	}

	@Override
	public void insertMemberStatus(MemberManage dto) throws Exception {
		try {
			mapper.insertMemberStatus(dto);
		} catch (Exception e) {
			log.info("insertMemberStatus : ", e);
			
			throw e;
		}
		
	}

	@Override
	public List<MemberManage> listMemberStatus(Long member_id) {
		List<MemberManage> list = null;
		
		try {
			list = mapper.listMemberStatus(member_id);
		} catch (Exception e) {
			log.info("listMemberStatus : ", e);
			
		}
		return list;
	}

	@Override
	public MemberManage findByStatus(Long member_id) {
		MemberManage dto = null;
		
		try {
			dto = mapper.findByStatus(member_id);
		} catch (Exception e) {
			log.info("findByStatus : ", e);
		}
		return dto;
	}

	@Override
	public List<Map<String, Object>> listAgeSection() {
		List<Map<String, Object>> list = null;
		
		try {
			list = mapper.listAgeSection();
		} catch (Exception e) {
			log.info("listAgeSection : ", e);
		}
		return list;
	}

	@Override
	public void deleteMember(Map<String, Object> map) throws SQLException {
		try {
			
			mapper.deleteMember(map);
		} catch (Exception e) {
			log.info("deleteMember : ", e);
			
			throw e;
		}
	}
	
}
