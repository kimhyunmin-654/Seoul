package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import com.sp.app.admin.model.ReportsManage;

public interface ReportsManageService {
	public String getRegionnameById(String region_id);
	
	public int dataCount(Map<String, Object> map);
	public List<ReportsManage> listReports(Map<String, Object> map);
	
	public int dataGroupCount(Map<String, Object> map);
	public List<ReportsManage> listGroupReports(Map<String, Object> map);
	
	public ReportsManage findById(Long report_num);
	
	public int dataRelatedCount(Map<String, Object> map);
	public List<ReportsManage> listRelatedReports(Map<String, Object> map);
	
	public void updateReports(ReportsManage dto) throws Exception;
	public void updateBlockContent(Map<String, Object> map) throws Exception;
	public void deleteContent(Map<String, Object> map) throws Exception;
	
	public ReportsManage findContentByTypeId(Map<String, Object> map);
}
