package com.sp.app.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sp.app.admin.mapper.ReportsManageMapper;
import com.sp.app.admin.model.ReportsManage;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class ReportsManageServiceImpl implements ReportsManageService {
	private final ReportsManageMapper mapper;
	
	@Override
	public String getRegionnameById(String region_id) {
		String region_name = "";
		
		try {
			region_name = mapper.getRegionnameById(region_id);
		} catch (Exception e) {
			log.info("getRegionnameById : ", e);
		}
		
		return region_name;
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
	public List<ReportsManage> listReports(Map<String, Object> map) {
		List<ReportsManage> list = null;
		
		try {
			list = mapper.listReports(map);
		} catch (Exception e) {
			log.info("listReports : ", e);
		}
		
		return list;
	}

	@Override
	public int dataGroupCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.dataGroupCount(map);
		} catch (Exception e) {
			log.info("dataGroupCount : ", e);
		}
		
		return result;
	}

	@Override
	public List<ReportsManage> listGroupReports(Map<String, Object> map) {
		List<ReportsManage> list = null;
		
		try {
			list = mapper.listGroupReports(map);
		} catch (Exception e) {
			log.info("listGroupReports : ", e);
		}
		
		return list;
	}

	@Override
	public ReportsManage findById(Long report_num) {
		ReportsManage dto = null;
		
		try {
			dto = mapper.findById(report_num);
		} catch (Exception e) {
			log.info("findById : ", e);
		}
		
		return dto;
	}

	@Override
	public int dataRelatedCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.dataRelatedCount(map);
		} catch (Exception e) {
			log.info("dataRelatedCount : ", e);
		}
		
		return result;
	}

	@Override
	public List<ReportsManage> listRelatedReports(Map<String, Object> map) {
		List<ReportsManage> list = null;
		
		try {
			list = mapper.listRelatedReports(map);
		} catch (Exception e) {
			log.info("listRelatedReports : ", e);
		}
		
		return list;
	}

	@Override
	public void updateReports(ReportsManage dto) throws Exception {
		try {
			mapper.updateReports(dto);
		} catch (Exception e) {
			log.info("updateReports : ", e);
			throw e;
		}
	}

	@Override
	public void updateBlockContent(Map<String, Object> map) throws Exception {
		try {
			mapper.updateBlockContent(map);
		} catch (Exception e) {
			log.info("updateBlockContent : ", e);
			throw e;
		}
	}

	@Override
	public void deleteContent(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteContent(map);
		} catch (Exception e) {
			log.info("deleteContent : ", e);
			throw e;
		}
	}

	@Override
	public ReportsManage findContentByTypeId(Map<String, Object> map) {
		ReportsManage dto = null;
		
		try {
			dto = mapper.findContentByTypeId(map);
		} catch (Exception e) {
			log.info("findContentByTypeId : ", e);
		}
		
		return dto;
	}

}
