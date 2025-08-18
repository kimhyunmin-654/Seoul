package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.model.Inquiry;

public interface InquiryService {
	public void insertInquiry(Inquiry dto) throws Exception;
	public void deleteInquiry(long inquiry_id) throws Exception;
	
	public int dataCount(Map<String, Object> map);
	public List<Inquiry> listInquiry(Map<String, Object> map);
	
	public Inquiry findById(long inquiry_id);
	public Inquiry findByPrev(Map<String, Object> map);
	public Inquiry findByNext(Map<String, Object> map);
}
