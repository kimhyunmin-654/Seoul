package com.sp.app.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Board;

@Mapper
public interface BoardMyMapper {
	public List<Board> listMyBoard(Map<String, Object> map);
	
	public int MyBoardCount(Map<String, Object> map);
}
