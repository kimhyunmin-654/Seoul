package com.sp.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sp.app.mapper.BoardMyMapper;
import com.sp.app.model.Board;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class BoardMyServiceImpl implements BoardMyService{
	private final BoardMyMapper mapper;

	@Override
	public List<Board> listMyBoard(Map<String, Object> map) {
		List<Board> list = null;
		try {
			list = mapper.listMyBoard(map);
		} catch (Exception e) {
			log.info("listMyBoard : ", e);
			
		}
		
		return list;
	}

	@Override
	public int MyBoardCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.MyBoardCount(map);
		} catch (Exception e) {
			log.info("MyBoardCount : ", e);
		}
		return result;
	}

}
