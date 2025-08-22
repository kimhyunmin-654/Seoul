package com.sp.app.service;

import java.util.List;
import java.util.Map;

import com.sp.app.model.Board;

public interface BoardMyService {
	public List<Board> listMyBoard(Map<String, Object> map);
	
	public int MyBoardCount(Map<String, Object> map);
}
