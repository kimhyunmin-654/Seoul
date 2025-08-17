package com.sp.app.service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.sp.app.common.PaginateUtil;
import com.sp.app.mapper.AuctionMapper;
import com.sp.app.model.Auction;
import com.sp.app.model.Bid;
import com.sp.app.model.Category;
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
	
	@Override
	public void insertAuction(Auction dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void insertBid(Bid dto) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateAuction(Auction dto) throws Exception {
		// TODO Auto-generated method stub
		
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
		// TODO Auto-generated method stub
		return null;
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

}
