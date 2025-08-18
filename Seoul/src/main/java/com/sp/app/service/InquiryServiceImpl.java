package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sp.app.mapper.InquiryMapper;
import com.sp.app.model.Inquiry;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class InquiryServiceImpl implements InquiryService {
	private final InquiryMapper mapper;
	
	@Override
	public void insertInquiry(Inquiry dto) throws Exception {
		try {
			mapper.insertInquiry(dto);
		} catch (Exception e) {
			log.info("insertInquiry : ", e);
		}
		
	}

	@Override
	public void deleteInquiry(long inquiry_id) throws Exception {
		try {
			mapper.deleteInquiry(inquiry_id);
		} catch (Exception e) {
			log.info("deleteInquiry : ", e);
			
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
	public List<Inquiry> listInquiry(Map<String, Object> map) {
		List<Inquiry> list = null;
		
		try {
			list = mapper.listInquiry(map);
		} catch (Exception e) {
			log.info("listInquiry : ", e);
		}
		return list;
	}

	@Override
	public Inquiry findById(long inquiry_id) {
		Inquiry dto = null;
		
		try {
			dto = mapper.findById(inquiry_id);
		} catch (Exception e) {
			log.info("findById : ", e);
		}
		return dto;
	}

	@Override
	public Inquiry findByPrev(Map<String, Object> map) {
		Inquiry dto = null;
		
		try {
			dto = mapper.findByPrev(map);
		} catch (Exception e) {
			log.info("findByPrev ; ", e);
		}
		
		return dto;
	}

	@Override
	public Inquiry findByNext(Map<String, Object> map) {
		Inquiry dto = null;
		
		try {
			dto = mapper.findByNext(map);
		} catch (Exception e) {
			log.info("findByNext ; ", e);
		}
		
		return dto;
	}

}
