package com.sp.app.service;

import java.util.Map;

import com.sp.app.model.Auction;
import com.sp.app.model.Bid;
import com.sp.app.model.SearchCondition;

public interface AuctionService {
	
	public void insertAuction(Auction dto) throws Exception;
	public void insertBid(Bid dto) throws Exception;
	public void updateAuction(Auction dto) throws Exception;
	public Map<String, Object> listAuction(SearchCondition cond);	
	public Map<String, Object> detailAuction(long auction_id);
	
}
