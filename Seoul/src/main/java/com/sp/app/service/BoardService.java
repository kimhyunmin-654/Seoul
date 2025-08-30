package com.sp.app.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.sp.app.model.Board;
import com.sp.app.model.Region;
import com.sp.app.model.Reply;
import com.sp.app.model.Reports;

public interface BoardService {
	public String getRegionnameById(String region_id);
	public List<Region> listRegion();
	
	// 게시판 리스트
	public void insertBoard(Board dto, String uploadPath) throws Exception;
	
	public List<Board> listBoard(Map<String, Object> map);
	public int dataCount(Map<String, Object> map);
	
	public Board findById(long num);
	public void updateHitCount(long num) throws Exception;
	public Board findByPrev(Map<String, Object> map);
	public Board findByNext(Map<String, Object> map);
	
	public void updateBoard(Board dto, String uploadPath) throws Exception;
	public void deleteBoard(long num, String uploadPath, Long member_id, int userLevel) throws Exception;
	
	// 공감
	public void insertBoardLike(Map<String, Object> map) throws Exception;
	public void deleteBoardLike(Map<String, Object> map) throws Exception;
	public int boardLikeCount(long num);
	public boolean isUserBoardLiked(Map<String, Object> map);
	
	// 댓글
	public void insertReply(Reply dto) throws Exception;
	public List<Reply> listReply(Map<String, Object> map, List<Long> blockList);
	public int replyCount(Map<String, Object> map);
	public void deleteReply(Map<String, Object> map) throws Exception;
	
	// 답글
	public List<Reply> listReplyAnswer(Map<String, Object> map, List<Long> blockList);
	public int replyAnswerCount(Map<String, Object> map);
	
	// 댓글 좋아요/싫어요
	public void insertReplyLike(Map<String, Object> map) throws Exception;
	public void deleteReplyLike(Map<String, Object> map) throws Exception;
	public Integer isUserReplyLiked(Map<String, Object> map);
	public Map<String, Object> replyLikeCount(Map<String, Object> map);
	
	// 숨김
	public void updateReplyShowHide(Map<String, Object> map) throws Exception;
	
	// 파일 삭제
	public boolean deleteUploadFile(String uploadPath, String filename);
	
	// 사용자 차단
	public void insertBlockMember(Map<String, Object> map) throws SQLException;
	public void deleteBlockMember(Map<String, Object> map) throws SQLException;
	public List<Long> findBlockMemberById(long num) throws SQLException;
	
	// 관리자 차단
	public void updateReplyBlockByManager(Map<String, Object> map, int userLevel);
	
	// 신고
	public void insertCommunityReports(Reports dto) throws Exception;

}
