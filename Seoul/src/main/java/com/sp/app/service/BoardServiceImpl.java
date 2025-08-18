package com.sp.app.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.stereotype.Service;

import com.sp.app.common.MyUtil;
import com.sp.app.common.StorageService;
import com.sp.app.mapper.BoardMapper;
import com.sp.app.model.Board;
import com.sp.app.model.Reply;
import com.sp.app.model.Reports;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class BoardServiceImpl implements BoardService {
	private final BoardMapper mapper;
	private final StorageService storageService;
	private final MyUtil myUtil;

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
	public void insertBoard(Board dto, String uploadPath) throws Exception {
		try {
			if(! dto.getSelectFile().isEmpty()) {
				String saveFilename = storageService.uploadFileToServer(dto.getSelectFile(), uploadPath);
				dto.setSaveFilename(saveFilename);
				dto.setOriginalFilename(dto.getSelectFile().getOriginalFilename());
				
				dto.setFilesize(dto.getSelectFile().getSize());
			}
			
			mapper.insertBoard(dto);
		} catch (Exception e) {
			log.info("insertBoard : ", e);
			throw e;
		}
		
	}

	@Override
	public List<Board> listBoard(Map<String, Object> map) {
		List<Board> list = null;
		
		try {
			list = mapper.listBoard(map);
			
		} catch (Exception e) {
			log.info("listBoard : ", e);
		}
		
		return list;
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
	public Board findById(long num) {
		Board dto = null;

		try {
			dto = mapper.findById(num);
		} catch (Exception e) {
			log.info("findById : ", e);
		}
		
		return dto;
	}

	@Override
	public void updateHitCount(long num) throws Exception {

		try {
			mapper.updateHitCount(num);
		} catch (Exception e) {
			log.info("updateHitCount : ", e);
			throw e;
		}
		
	}

	@Override
	public Board findByPrev(Map<String, Object> map) {
		Board dto = null;

		try {
			dto = mapper.findByPrev(map);
		} catch (Exception e) {
			log.info("findByPrev : ", e);
		}
		
		return dto;
	}

	@Override
	public Board findByNext(Map<String, Object> map) {
		Board dto = null;

		try {
			dto = mapper.findByNext(map);
		} catch (Exception e) {
			log.info("findByNext : ", e);
		}
		
		return dto;
	}

	@Override
	public void updateBoard(Board dto, String uploadPath) throws Exception {

		try {
			if(dto.getSelectFile() != null && ! dto.getSelectFile().isEmpty()) {
				if(! dto.getSaveFilename().isBlank()) {
					deleteUploadFile(uploadPath, dto.getSaveFilename());
				}
				
				String saveFilename = storageService.uploadFileToServer(dto.getSelectFile(), uploadPath);
				dto.setSaveFilename(saveFilename);
				dto.setOriginalFilename(dto.getSelectFile().getOriginalFilename());
				
				dto.setFilesize(dto.getSelectFile().getSize());
			}
			
			mapper.updateBoard(dto);
		} catch (Exception e) {
			log.info("updateBoard : ", e);
			throw e;
		}
		
	}

	@Override
	public void deleteBoard(long num, String uploadPath, Long member_id, int userLevel) throws Exception {
		try {
			Board dto = Objects.requireNonNull(findById(num));
			if(userLevel != 9 && dto.getMember_id() != member_id) {
				return;
			}
			
			deleteUploadFile(uploadPath, dto.getSaveFilename());
			
			mapper.deleteBoard(num);
		} catch (Exception e) {
			log.info("deleteBoard : ", e);
			throw e;
		}
		
	}

	@Override
	public void insertBoardLike(Map<String, Object> map) throws Exception {
		try {
			mapper.insertBoardLike(map);
		} catch (Exception e) {
			log.info("insertBoardLike : ", e);
			throw e;
		}
	}

	@Override
	public void deleteBoardLike(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteBoardLike(map);
		} catch (Exception e) {
			log.info("deleteBoardLike : ", e);
			throw e;
		}
	}

	@Override
	public int boardLikeCount(long num) {
		int result = 0;
		
		try {
			result = mapper.boardLikeCount(num);
		} catch (Exception e) {
			log.info("boardLikeCount : ", e);
		}
		
		return result;
	}

	@Override
	public boolean isUserBoardLiked(Map<String, Object> map) {
		boolean result = false;

		try {
			Board dto = mapper.isUserBoardLiked(map);
			if(dto != null) {
				result = true;
			}
		} catch (Exception e) {
			log.info("isUserBoardLiked : ", e);
		}
		
		return result;
	}

	// 댓글
	@Override
	public void insertReply(Reply dto) throws Exception {
		try {
			mapper.insertReply(dto);
		} catch (Exception e) {
			log.info("insertReply : ", e);
			throw e;
		}
		
	}

	@Override
	public List<Reply> listReply(Map<String, Object> map, List<Long> blockList) {
		List<Reply> list = null;
		
		try {
			list = mapper.listReply(map);
			
			for(Reply dto : list) {
				dto.setContent(myUtil.htmlSymbols(dto.getContent()));
				
				map.put("reply_num", dto.getReply_num());
				dto.setUserReplyLiked(isUserReplyLiked(map));
				
				// 사용자 차단 여부
				if(blockList != null && blockList.contains(dto.getMember_id())) {
					dto.setUserBlocked(true);
				} else {
					dto.setUserBlocked(false);
				}
				
				// 관리자 차단 여부
				dto.setManagerBlocked(dto.getBlock() == 1);
			}
		} catch (Exception e) {
			log.info("listReply : ", e);
		}
		
		return list;
	}

	@Override
	public int replyCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.replyCount(map);
		} catch (Exception e) {
			log.info("replyCount : ", e);
		}
		
		return result;
	}

	@Override
	public void deleteReply(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteReply(map);
		} catch (Exception e) {
			log.info("deleteReply : ", e);
			throw e;
		}
	}

	// 답글
	@Override
	public List<Reply> listReplyAnswer(Map<String, Object> map, List<Long> blockList) {
		List<Reply> list = null;
		
		try {
			list = mapper.listReplyAnswer(map);
			
			// 차단
			for(Reply dto : list) {
				if(blockList != null && blockList.contains(dto.getMember_id())) {
					dto.setUserBlocked(true);
				} else {
					dto.setUserBlocked(false);
				}
				
				dto.setManagerBlocked(dto.getBlock() == 1);
			}
		} catch (Exception e) {
			log.info("listReplyAnswer : ", e);
		}
		
		return list;
	}

	@Override
	public int replyAnswerCount(Map<String, Object> map) {
		int result = 0;
		
		try {
			result = mapper.replyAnswerCount(map);
		} catch (Exception e) {
			log.info("replyAnswerCount : ", e);
		}
		
		return result;
	}

	// 댓글 좋아요/싫어요
	@Override
	public void insertReplyLike(Map<String, Object> map) throws Exception {
		try {
			mapper.insertReplyLike(map);
		} catch (Exception e) {
			log.info("insertReplyLike : ", e);
			throw e;
		}
	}
	
	@Override
	public void deleteReplyLike(Map<String, Object> map) throws Exception {
		try {
			mapper.deleteReplyLike(map);
		} catch (Exception e) {
			log.info("deleteReplyLike : ", e);
			throw e;
		}
	}
	
	@Override
	public Integer isUserReplyLiked(Map<String, Object> map) {
		int result = -1;
			// -1:공감여부 하지않음, 0:비공감, 1:공감
		
		try {
			result = mapper.isUserReplyLiked(map).orElse(-1);
		} catch (Exception e) {
			log.info("isUserReplyLiked : ", e);
		}
		
		return result;
	}

	@Override
	public Map<String, Object> replyLikeCount(Map<String, Object> map) {
		Map<String, Object> countMap = null;
		
		try {
			countMap = mapper.replyLikeCount(map);
		} catch (Exception e) {
			log.info("replyAnswerCount : ", e);
		}
		
		return countMap;
	}

	// 숨김
	@Override
	public void updateReplyShowHide(Map<String, Object> map) throws Exception {
		try {
			mapper.updateReplyShowHide(map);
		} catch (Exception e) {
			log.info("updateReplyShowHide : ", e);
			throw e;
		}
	}

	// 파일
	@Override
	public boolean deleteUploadFile(String uploadPath, String filename) {
		return storageService.deleteFile(uploadPath, filename);
	}

	
	// 차단
	@Override
	public void insertBlockMember(Map<String, Object> map) throws SQLException {
		try {
			mapper.insertBlockMember(map);
		} catch (Exception e) {
			log.info("insertBlockMember : ", e);
			throw e;
		}
	}

	@Override
	public void deleteBlockMember(Map<String, Object> map) throws SQLException {
		try {
			mapper.deleteBlockMember(map);
		} catch (Exception e) {
			log.info("deleteBlockMember : ", e);
			throw e;
		}
	}

	@Override
	public List<Long> findBlockMemberById(long num) throws SQLException {
		List<Long> blockList = null;
		
		try {
			blockList = mapper.findBlockMemberById(num);
		} catch (Exception e) {
			log.info("findBlockMemberById : ", e);
			throw e;
		}
		
		return blockList;
	}

	@Override
	public void updateReplyBlockByManager(Map<String, Object> map, int userLevel) {
		if(userLevel != 9) {
			throw new RuntimeException("관리자만 가능한 작업입니다.");
		}
		
		try {
			mapper.updateReplyBlockByManager(map);
		} catch (Exception e) {
			log.info("updateReplyBlockByManager : ", e);
			throw new RuntimeException("댓글 차단 처리 중 오류 발생", e);
		}
	}

	// 신고
	@Override
	public void insertCommunityReports(Reports dto) {
		try {
			mapper.insertCommunityReports(dto);
		} catch (Exception e) {
			log.info("insertCommunityReports : ", e);
		}
	}

}
