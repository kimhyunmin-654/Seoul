package com.sp.app.service;

import java.util.Map;

import com.sp.app.model.Auction;
import com.sp.app.model.Bid;
import com.sp.app.model.SearchCondition;

public interface AuctionService {
	
	public Map<String, Object> insertBid(Bid dto) throws Exception;
	public boolean isBidded(long auction_id);
	public void updateAuction(Auction dto) throws Exception;
	public Map<String, Object> listAuction(SearchCondition cond);	
	public Map<String, Object> detailAuction(long auction_id);
	public void endAuction() throws Exception;
	public Auction getEndAuction(long auction_id);
}
