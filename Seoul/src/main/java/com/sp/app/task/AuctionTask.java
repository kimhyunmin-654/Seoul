package com.sp.app.task;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.sp.app.service.AuctionService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Component
@RequiredArgsConstructor
@Slf4j
public class AuctionTask {
	private final AuctionService auctionService;
	
	@Scheduled(cron = "0 * * * * *")
	public void checkAuctionStatus() {
		try {
			auctionService.endAuction();
		} catch (Exception e) {
			log.info("checkAuctionStatus : ", e);
		}
	}
}
