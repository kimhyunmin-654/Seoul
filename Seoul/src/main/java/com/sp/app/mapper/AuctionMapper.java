package com.sp.app.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.sp.app.model.Auction;
import com.sp.app.model.Bid;

@Mapper
public interface AuctionMapper {
	public void insertAuction(Auction dto) throws Exception;
	public void insertBid(Bid dto) throws Exception;
	public void updateAuction(Auction dto) throws Exception;
	public List<Auction> listAuctionProduct(Map<String, Object> map);	
	public Auction findAuctionById(long auction_id);
	public List<Bid> findBidsByAuctionId(Map<String, Object> map);
	
}
