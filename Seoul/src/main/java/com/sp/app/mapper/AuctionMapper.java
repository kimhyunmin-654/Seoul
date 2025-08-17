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
	public List<Auction> listAuctionProduct(SearchCondition cond);	
	public Auction findAuctionById(long auction_id);
	public Auction findFeaturedAuction(SearchCondition cond);
	public List<Bid> findBidsByAuctionId(long auction_id);
	
}
