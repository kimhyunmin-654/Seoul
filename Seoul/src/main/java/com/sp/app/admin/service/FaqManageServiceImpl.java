package com.sp.app.admin.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.admin.mapper.FaqManageMapper;
import com.sp.app.admin.model.FaqManage;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class FaqManageServiceImpl implements FaqManageService {
	private final FaqManageMapper mapper;
	
	@Transactional(rollbackFor = {Exception.class})
	@Override
	public void insertFaq(FaqManage dto) throws SQLException {
		try {
			long seq = mapper.faqSeq();
			dto.setFaq_id(seq);
			
			mapper.insertFaq(dto);;
			
		} catch (Exception e) {
			log.info("insertFaq : ", e);
			
			throw e;
		}
		
	}

	@Transactional(rollbackFor = {Exception.class})
	@Override
	public void updateFaq(FaqManage dto) throws SQLException {
		try {
			mapper.updateFaq(dto);
		} catch (Exception e) {
			log.info("updateFaq : ", e);
			
			throw e;
		}
		
	}

	@Transactional(rollbackFor = {Exception.class})
	@Override
	public void deleteFaq(long faq_id, Long member_id, int userLevel) throws SQLException {
		try {
			FaqManage dto = Objects.requireNonNull(findById(faq_id));
			
			if(userLevel < 5 && dto.getMember_id() != member_id) {
				return;
			}
			
			mapper.deleteFaq(faq_id);
		} catch (Exception e) {
			log.info("deleteFaq : ", e);
			
			throw e;
		}
	}

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
	public List<FaqManage> listFaq(Map<String, Object> map) {
		List<FaqManage> list = null;
		
		try {
			list = mapper.listFaq(map);
		} catch (Exception e) {
			log.info("listFaq : ", e);
		}
		
		return list;
	}

	@Override
	public FaqManage findById(long faq_id) {
		FaqManage dto = null;
		
		try {
			dto = mapper.findById(faq_id);
		} catch (Exception e) {
			log.info("findById : ", e);
		}
		
		return dto;
	}

	@Transactional(rollbackFor = {Exception.class})
	@Override
	public void updateHitCount(long faq_id) throws SQLException {
		try {
			mapper.updateHitCount(faq_id);
		} catch (Exception e) {
			log.info("updateHitCount : ", e);
			
			throw e;
		}
	}

	@Override
	public FaqManage findByPrev(Map<String, Object> map) {
		FaqManage dto = null;
		
		try {
			dto = mapper.findByPrev(map);
		} catch (Exception e) {
			log.info("findByPrev : ", e);
		}
		
		return dto;
	}

	@Override
	public FaqManage findByNext(Map<String, Object> map) {
		FaqManage dto = null;
		
		try {
			dto = mapper.findByNext(map);
		} catch (Exception e) {
			log.info("findByNext : ", e);
		}
		
		return dto;
	}

	@Transactional(rollbackFor = {Exception.class})
	@Override
	public void deleteFaq(long[] faq_ids, Long member_id, int userLevel) throws SQLException {
	    try {
	        for (long faq_id : faq_ids) {
	            FaqManage dto = findById(faq_id);

	            if (dto == null) continue;


	            mapper.deleteFaq(faq_id);
	        }
	    } catch (Exception e) {
	        log.info("deleteFaq : ", e);
	        throw e;
	    }
	}
	
}
