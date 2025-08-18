package com.sp.app.mapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sp.app.model.Board;
import com.sp.app.model.Reply;
import com.sp.app.model.Reports;

@Mapper
public interface BoardMapper {
	public String getRegionnameById(@Param("region_id") String region_id);
	
	public void insertBoard(Board dto) throws SQLException;
	public void updateBoard(Board dto) throws SQLException;
	public void deleteBoard(long num) throws SQLException;
	
	public int dataCount(Map<String, Object> map);
	public List<Board> listBoard(Map<String, Object> map);
	
	public Board findById(long num);
	public void updateHitCount(long num) throws SQLException;
	public Board findByPrev(Map<String, Object> map);
	public Board findByNext(Map<String, Object> map);
	
	public void insertBoardLike(Map<String, Object> map) throws SQLException;
	public void deleteBoardLike(Map<String, Object> map) throws SQLException;
	public int boardLikeCount(long num);
	public Board isUserBoardLiked(Map<String, Object> map);
	
	// 댓글
	public void insertReply(Reply dto) throws SQLException;
	public int replyCount(Map<String, Object> map);
	public List<Reply> listReply(Map<String, Object> map);
	public void deleteReply(Map<String, Object> map) throws SQLException;
	
	// 답글
	public List<Reply> listReplyAnswer(Map<String, Object> map);
	public int replyAnswerCount(Map<String, Object> map);
	
	// 댓글 좋아요
	public void insertReplyLike(Map<String, Object> map) throws SQLException;
	public void deleteReplyLike(Map<String, Object> map) throws SQLException;
	public Optional<Integer> isUserReplyLiked(Map<String, Object> map);
	public Map<String, Object> replyLikeCount(Map<String, Object> map);
	
	// 댓글 숨김
	public void updateReplyShowHide(Map<String, Object> map) throws SQLException;
	
	// 사용자 차단
	public void insertBlockMember(Map<String, Object> map) throws SQLException;
	public void deleteBlockMember(Map<String, Object> map) throws SQLException;
	public List<Long> findBlockMemberById(long num) throws SQLException;
	
	// 관리자 차단
	public void updateReplyBlockByManager(Map<String, Object> map);
	
	// 신고
	public void insertCommunityReports(Reports dto);

}
