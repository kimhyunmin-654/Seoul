package com.sp.app.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.sp.app.auction.websocket.AuctionWebSocketHandler;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSocket 
@RequiredArgsConstructor
public class AuctionWebSocketConfig implements WebSocketConfigurer {

    private final AuctionWebSocketHandler auctionWebSocketHandler;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(auctionWebSocketHandler, "/ws/auction") 
                .setAllowedOrigins("*");
    }
}