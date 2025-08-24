package com.sp.app.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Auction;
import com.sp.app.model.Bid;
import com.sp.app.model.SearchCondition;

@Mapper
public interface AuctionMapper {
	public void insertAuction(Auction dto) throws Exception;
	public void insertBid(Bid dto) throws Exception;
	public void updateAuction(Auction dto) throws Exception;
	public void updateCurrentPrice(Auction dto) throws Exception;
	public void extendEndTime(Auction dto) throws Exception;
	public List<Auction> listAuctionProduct(SearchCondition cond);	
	public Auction findAuctionById(long auction_id);
	public Auction findFeaturedAuction(SearchCondition cond);
	public Bid findNewBid(long bid_id);
	public List<Bid> findBidsByAuctionId(long auction_id);
	public List<Long> findEndedAuction();
	public void updateAuctionStatus(Auction dto);
	public Bid findTopBid(long auction_id);
	public Auction getEndAuction(long auction_id);
}
