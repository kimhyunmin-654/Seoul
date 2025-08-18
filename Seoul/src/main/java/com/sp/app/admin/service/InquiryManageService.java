package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import com.sp.app.admin.model.InquiryManage;

public interface InquiryManageService {
	public int dataCount(Map<String, Object> map);
	public List<InquiryManage> listInquiry(Map<String, Object> map);
	
	public InquiryManage findById(long inquiry_id);
	public InquiryManage findByPrev(Map<String, Object> map);
	public InquiryManage findByNext(Map<String, Object> map);
	
	public void updateAnswer(InquiryManage dto) throws Exception;
	public void deleteAnswer(long inquiry_id) throws Exception;
	public void deleteInquiry(long inquiry_id) throws Exception;
	
}
