package com.sp.app.service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sp.app.common.MyUtil;
import com.sp.app.common.PaginateUtil;
import com.sp.app.mapper.AuctionMapper;
import com.sp.app.model.Auction;
import com.sp.app.model.Bid;
import com.sp.app.model.Category;
import com.sp.app.model.ProductImage;
import com.sp.app.model.SearchCondition;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuctionServiceImpl implements AuctionService{
	private final ProductService productService;
	private final AuctionMapper auctionMapper;
	private final PaginateUtil paginateUtil;
	private final MyUtil myUtil;
	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> insertBid(Bid dto) throws Exception {
		Map<String, Object> map = new HashMap<>();
		try {
			Auction auction = auctionMapper.findAuctionById(dto.getAuction_id());
			
			String endTimeStr = auction.getEnd_time();
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
			LocalDateTime endTime = LocalDateTime.parse(endTimeStr, dtf);
			
			if(LocalDateTime.now().isAfter(endTime)) {
				throw new RuntimeException("이미 마감된 경매입니다.");
			}
			
			int currentPrice = auction.getCurrent_price();
		    int minIncrement;

		    
		    if (currentPrice < 100000) { 
		        minIncrement = 1000;
		    } else if (currentPrice < 500000) {
		        minIncrement = 5000;
		    } else if (currentPrice < 1000000) { 
		        minIncrement = 10000;
		    } else { 
		        minIncrement = 50000;
		    }
		    
		    if (dto.getBid_amount() < currentPrice + minIncrement) {
		        throw new RuntimeException("현재 최소 입찰액은" + 
		                                   (currentPrice + minIncrement) + "원 이상입니다.");
		    }
			
		    auctionMapper.insertBid(dto);
		    auction.setCurrent_price(dto.getBid_amount());
		    auctionMapper.updateCurrentPrice(auction);

		    Duration duration = Duration.between(LocalDateTime.now(), endTime);

		    if (duration.getSeconds() <= 60) { 
		        LocalDateTime newEndTime = LocalDateTime.now().plusMinutes(1);
		        auction.setEnd_time(newEndTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss")));
		        auctionMapper.extendEndTime(auction);
		        map.put("timeExtended", true);
		    } 
			
			
			Bid newBid = auctionMapper.findNewBid(dto.getBid_id());
			newBid.setAuction_id(dto.getAuction_id());
			
			map.put("newBid", newBid);
			map.put("updatedAuction", auction);
			map.put("status", "success");

		} catch (Exception e) {
			log.info("insertBid : ", e);
			map.put("status", "error");
			throw e;
		}
		
		return map;
	}

	@Override
	public void updateAuction(Auction dto) throws Exception {
		auctionMapper.updateAuction(dto);
	}
	
	
	@Override
	public boolean isBidded(long auction_id) {
		int bidCount = auctionMapper.findAuctionById(auction_id).getBidCount();
		if(bidCount > 0) {
			return true;
		} else {
			return false;
		}
	}

	@Override
	public Map<String, Object> listAuction(SearchCondition cond) {

		Map<String, Object> map = new HashMap<>();
		
		try {
			
			cond.setType("AUCTION");
			
			int size = cond.getSize();
			int dataCount = productService.dataCount(cond);
			int total_page = paginateUtil.pageCount(dataCount, size);
			
			if(cond.getPage() > total_page) cond.setPage(total_page);
			int offset = (cond.getPage() - 1) * size;
			cond.setOffset(offset);
						
			List<Auction> list = auctionMapper.listAuctionProduct(cond);
			
			for(Auction dto : list) {
				processAuctionData(dto);
			}
			
			List<Category> categoryList = productService.listCategories();
			
			Auction featuredAuction = auctionMapper.findFeaturedAuction(cond);
			
			if(featuredAuction == null) {
				SearchCondition globalCond = new SearchCondition();
				globalCond.setType("auction");
				featuredAuction = auctionMapper.findFeaturedAuction(globalCond);
			}
			
			if(featuredAuction != null) {
				processAuctionData(featuredAuction);	
			}
			
			map.put("featuredAuction", featuredAuction);
			map.put("list", list);
			map.put("dataCount", dataCount);
			map.put("totalPage", total_page);
			map.put("page", cond.getPage());
			map.put("categoryList", categoryList);
		
		} catch (Exception e) {
			log.info("listAuction : ", e);
		}
		
		return map;
	}

	@Override
	public Map<String, Object> detailAuction(long auction_id) {
		Map<String, Object> map = new HashMap<>();
		
		try {
			Auction dto = auctionMapper.findAuctionById(auction_id);
			if(dto == null) {
				return null;
			}
			
			processAuctionData(dto);
			dto.setContent(myUtil.htmlSymbols(dto.getContent()));

			List<ProductImage> imageList = productService.listProductImage(dto.getProduct_id());			
			List<Bid> bidList = auctionMapper.findBidsByAuctionId(auction_id);
			
			map.put("dto", dto);
			map.put("imageList", imageList);
			map.put("bidList", bidList);
			
			
		} catch (Exception e) {
			log.info("detailAuction : ", e);
		}
		
		return map;
	}
	
	private void processAuctionData(Auction dto) {
		if(dto == null || dto.getEnd_time() == null) {
			return;
		}
		
		String endTimeStr = dto.getEnd_time();
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		LocalDateTime endTime = LocalDateTime.parse(endTimeStr, dtf);
		LocalDateTime now = LocalDateTime.now();
		
		if(now.isAfter(endTime)) {
			dto.setRemainingTime("경매 마감");
			dto.setUrgent(false);
			return;
		}
		
		Duration duration = Duration.between(now, endTime);
		long secondsLeft = duration.getSeconds();
		
		long days = secondsLeft / (24 * 3600);
		long hours = (secondsLeft % (24 * 3600)) / 3600;
		long minutes = (secondsLeft % 3600) / 60;
		long seconds = (secondsLeft % 3600) % 60; 
				
		if(days != 0) {			
			dto.setRemainingTime(String.format("%d일 %02d:%02d:%02d", days, hours, minutes, seconds));
		} else {
			dto.setRemainingTime(String.format("%02d:%02d:%02d", hours, minutes, seconds));
		}
		
		dto.setHot(dto.getBidCount() > 10);
		dto.setUrgent(secondsLeft < 3600);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void endAuction() throws Exception {
		
		try {
			List<Long> endedAuctionIds = auctionMapper.findEndedAuction();
			
			if(endedAuctionIds != null && !endedAuctionIds.isEmpty()) {
				for(long auction_id : endedAuctionIds) {
					Bid topBid = auctionMapper.findTopBid(auction_id);
					
					String status;
					Long winnerId = null;
					
					if(topBid != null) {
						status = "ENDED_SUCCESS";
						winnerId = topBid.getBidder_id();
					} else {
						status = "ENDED_FAIL";
					}
					
					Auction dto = new Auction();
					dto.setAuction_id(auction_id);
					dto.setStatus(status);
					dto.setWinner_id(winnerId);
					
					auctionMapper.updateAuctionStatus(dto);
				}
			}
		} catch (Exception e) {
			throw e;
		}
		
	}

	@Override
	public Auction getEndAuction(long auction_id) {
		Auction dto = null;
		
		try {
			dto = auctionMapper.getEndAuction(auction_id);
			
	        LocalDateTime endTime = LocalDateTime.parse(dto.getEnd_time(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	        
	        if (LocalDateTime.now().isAfter(endTime)) {
	            
	            if (dto.getCurrent_price() > dto.getStart_price()) {
	            	dto.setStatus("ENDED_SUCCESS");
	            } else {
	            	dto.setStatus("ENDED_FAIL");
	            }
	        }
	        
		} catch (Exception e) {
			log.info("getAuctionStatus : ", e);
		}
		
		return dto;
	}

}
