package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.common.StorageService;
import com.sp.app.mail.MailSender;
import com.sp.app.mapper.MemberMapper;
import com.sp.app.model.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class MemberServiceImpl implements MemberService {
	private final MemberMapper mapper;
	private final StorageService storageService;
	private final MailSender mailSender;

	
	@Override
	public Member loginMember(Map<String, Object> map) {
		Member dto = null;

		try {
			dto = mapper.loginMember(map);
		} catch (Exception e) {
			log.info("loginMember : ", e);
		}

		return dto;
	}

	@Override
	public Member loginSnsMember(Map<String, Object> map) {
		Member dto = null;

		try {
			dto = mapper.loginSnsMember(map);
		} catch (Exception e) {
			log.info("loginSnsMember : ", e);
		}

		return dto;
	}
	
	
	@Transactional(rollbackFor = {Exception.class})
	@Override
	public void insertMember(Member dto, String uploadPath) throws Exception {
		if(! dto.getSelectFile().isEmpty()) {
			
		}
	}

	@Override
	public void updateLastLogin(Long member_id) throws Exception {
		
	}

	@Override
	public void updateMember(Member dto, String uploadPath) throws Exception {
		
	}

	@Override
	public Member findById(Long member_id) {

		return null;
	}

	@Override
	public Member findById(String login_id) {

		return null;
	}

	@Override
	public void deleteMember(Map<String, Object> map, String uploadPath) throws Exception {
		
	}

	@Override
	public void deleteProfilePhoto(Map<String, Object> map, String uploadPath) throws Exception {
		
	}

	@Override
	public void generatePwd(Member dto) throws Exception {
		
	}

	@Override
	public List<Member> listFindMember(Map<String, Object> map) {

		return null;
	}
}
