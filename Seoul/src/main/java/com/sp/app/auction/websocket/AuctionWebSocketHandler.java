package com.sp.app.auction.websocket;

import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class AuctionWebSocketHandler extends TextWebSocketHandler {
	
	private final Map<Long, Set<WebSocketSession>> rooms = new ConcurrentHashMap<>();
	private final ObjectMapper objectMapper = new ObjectMapper();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		
	}
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		String payload = message.getPayload();
		
		Map<String, Object> messageMap = objectMapper.readValue(payload, Map.class);
		String type = (String)messageMap.get("type");
		
		if(type.equalsIgnoreCase("JOIN")) {
			Long auction_id = Long.parseLong(String.valueOf(messageMap.get("auction_id")));
			rooms.computeIfAbsent(auction_id, k -> new CopyOnWriteArraySet<>()).add(session);
			
		} else if(type.equalsIgnoreCase("NEW_BID")) {
			Long auction_id = Long.parseLong(String.valueOf(messageMap.get("auction_id")));
			Set<WebSocketSession> roomSessions = rooms.get(auction_id);
			
			if(roomSessions != null) {
				
				for(WebSocketSession s : roomSessions) {
					if (!s.getId().equals(session.getId())) {
	                    s.sendMessage(message);
	                }
				}
				 
			}
		}
		
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		rooms.values().forEach(room -> room.remove(session));
	}
}
