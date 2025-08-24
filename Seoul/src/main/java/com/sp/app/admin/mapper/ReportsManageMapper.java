package com.sp.app.admin.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sp.app.admin.model.ReportsManage;

@Mapper
public interface ReportsManageMapper {
	public String getRegionnameById(@Param("region_id") String region_id);
	
	public int dataCount(Map<String, Object> map);
	public List<ReportsManage> listReports(Map<String, Object> map);
	
	public int dataGroupCount(Map<String, Object> map);
	public List<ReportsManage> listGroupReports(Map<String, Object> map);
	
	public ReportsManage findById(Long report_num);
	
	public int dataRelatedCount(Map<String, Object> map);
	public List<ReportsManage> listRelatedReports(Map<String, Object> map);
	
	public void updateReports(ReportsManage dto) throws SQLException;
	public void updateBlockContent(Map<String, Object> map) throws SQLException;
	public void deleteContent(Map<String, Object> map) throws SQLException;
	
	public ReportsManage findContentByTypeId(Map<String, Object> map);
	
}
