package com.sp.app.chat.websocket;

import java.net.URI;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.HashMap;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sp.app.chat.model.ChatMessage;
import com.sp.app.chat.model.ChatNotification;
import com.sp.app.chat.model.ChatRoom;
import com.sp.app.chat.service.ChatService;
import com.sp.app.model.Member;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Component
@RequiredArgsConstructor
@Slf4j
public class ChatWebSocketHandler extends TextWebSocketHandler {

    private final ChatService chatService;

    private final Map<Long, CopyOnWriteArrayList<WebSocketSession>> roomSessions = new ConcurrentHashMap<>();
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        Long roomId = extractRoomId(session);
        if (roomId == null) {
            log.warn("roomId 누락. 연결 종료.");
            session.close(CloseStatus.BAD_DATA);
            return;
        }
        session.getAttributes().put("room_id", roomId);

        // 멤버아이디 확보: attributes, member 객체, query param, principal 순서로 시도
        Long memberId = extractMemberId(session);
        if (memberId != null) {
            session.getAttributes().put("member_id", memberId);
        } else {
            log.warn("연결된 세션에 member_id가 없음(sessionId={}, roomId={})", session.getId(), roomId);
            // (선택) 이후 디버깅을 위해 attributes 전체를 찍어둡니다
            log.debug("session.attributes={}", session.getAttributes());
        }

        roomSessions.computeIfAbsent(roomId, k -> new CopyOnWriteArrayList<>()).add(session);
        log.info("WS connected: room_id={}, session={}, member_id={}", roomId, session.getId(), memberId);
    }

    /** 새 헬퍼: 세션에서 memberId를 여러 경로로 추출 */
    private Long extractMemberId(WebSocketSession session) {
        // 1) attributes 직접 키 확인
        Object v = session.getAttributes().get("member_id");
        if (v == null) v = session.getAttributes().get("memberId");
        if (v instanceof Number) return ((Number) v).longValue();
        if (v instanceof String) {
            try { return Long.parseLong((String) v); } catch (NumberFormatException ignored) {}
        }
        // 2) member 객체
        Object memberObj = session.getAttributes().get("member");
        if (memberObj instanceof Member) {
            return ((Member) memberObj).getMember_id();
        }
        // 3) URI query 파라미터에서 member_id 또는 memberId 찾기
        URI uri = session.getUri();
        if (uri != null) {
            String q = uri.getQuery();
            if (q != null) {
                for (String param : q.split("&")) {
                    String[] pair = param.split("=");
                    if (pair.length == 2) {
                        if ("member_id".equals(pair[0]) || "memberId".equals(pair[0])) {
                            try { return Long.parseLong(pair[1]); } catch (NumberFormatException ignore) {}
                        }
                    }
                }
            }
        }
        // 4) Principal (스프링 시큐리티 사용 시)
        try {
            if (session.getPrincipal() != null) {
                String name = session.getPrincipal().getName();
                if (name != null) {
                    try { return Long.parseLong(name); } catch (NumberFormatException ignore) {}
                }
            }
        } catch (Exception ignored) {}

        return null;
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        Map<String, Object> json;
        try {
            json = mapper.readValue(message.getPayload(), new TypeReference<>() {});
        } catch (Exception e) {
            log.warn("WS JSON 파싱 실패: {}", e.getMessage());
            return;
        }

        String type = String.valueOf(json.getOrDefault("type", "message")).toLowerCase();
        Long roomId = (Long) session.getAttributes().get("room_id");
        if (roomId == null) roomId = toLong(json.get("room_id"), json.get("room_id"));
        if (roomId == null) {
            log.warn("room_id 없음");
            return;
        }

        if ("join".equals(type)) return;

        if ("message".equals(type) || "chat".equals(type)) {
            Long senderId = toLong(json.get("sender_id"), json.get("sender_id"));
            String content = str(json.getOrDefault("message", json.get("content")));
            if (senderId == null || content == null || content.isBlank()) return;

            ChatRoom room = chatService.getChatRoomById(roomId);
            if (room == null) return;

            Long receiverId = senderId.equals(room.getBuyer_id()) ? room.getSeller_id() : room.getBuyer_id();

            ChatMessage dto = ChatMessage.builder()
                    .room_id(roomId)
                    .product_id(room.getProduct_id())
                    .sender_id(senderId)
                    .receiver_id(receiverId)
                    .message(content)
                    .build();

            chatService.sendMessage(dto);

            chatService.createNotification(ChatNotification.builder()
                    .chat_id(dto.getChat_id())
                    .member_id(receiverId)
                    .is_read(false)
                    .created_at(new Date())
                    .build());

            Member sender = chatService.getMemberById(senderId);
            String nickname = sender != null && sender.getNickname() != null ? sender.getNickname() : "상대";
            String profilePhoto = sender != null && sender.getProfile_photo() != null ? sender.getProfile_photo() : "avatar.png";

            Map<String, Object> out = new HashMap<>();
            out.put("type", "message");
            out.put("room_id", roomId);
            out.put("product_id", room.getProduct_id());
            out.put("chat_id", dto.getChat_id());
            out.put("sender_id", senderId);
            out.put("receiver_id", receiverId);
            out.put("nickname", nickname);
            out.put("profile_photo", profilePhoto);
            out.put("message", content);
            out.put("send_time", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));

            String payload = mapper.writeValueAsString(out);
            broadcast(roomId, payload);
        }
    }


    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        Long roomId = (Long) session.getAttributes().get("room_id");
        if (roomId != null) {
            CopyOnWriteArrayList<WebSocketSession> list = roomSessions.get(roomId);
            if (list != null) {
                list.remove(session);
                if (list.isEmpty()) roomSessions.remove(roomId);
            }
        }
        log.info("WS closed: {}", session.getId());
    }

    /* -------------------- helpers -------------------- */

    private void broadcast(Long roomId, String payload) {
        if (payload == null) return;
        try {
            Map<String, Object> map = mapper.readValue(payload, new com.fasterxml.jackson.core.type.TypeReference<>() {});
            Long receiverId = toLong(map.get("receiver_id"));
            Long senderId = toLong(map.get("sender_id"));
            String senderSessionId = str(map.get("sender_session")); // 새 필드 읽기

            java.util.Set<String> sentSessions = new java.util.HashSet<>();

            // 1) 동일 룸의 모든 세션에 전송하되, '오직' 발신 세션만 제외
            CopyOnWriteArrayList<WebSocketSession> roomList = roomSessions.get(roomId);
            if (roomList != null) {
                for (WebSocketSession s : roomList) {
                    try {
                        if (s == null || !s.isOpen()) continue;
                        String sid = s.getId();
                        if (senderSessionId != null && senderSessionId.equals(sid)) {
                            // 오직 실제 발신 세션만 스킵
                            continue;
                        }
                        if (sentSessions.contains(sid)) continue;
                        s.sendMessage(new TextMessage(payload));
                        sentSessions.add(sid);
                    } catch (Exception e) {
                        log.warn("broadcast -> send to room session failed: {}", e.getMessage());
                    }
                }
            }

            // 2) 다른 룸에 있는 동일 멤버(알림용)에게 전달
            if (receiverId != null) {
                for (CopyOnWriteArrayList<WebSocketSession> list : roomSessions.values()) {
                    for (WebSocketSession s : list) {
                        try {
                            if (s == null || !s.isOpen()) continue;
                            String sid = s.getId();
                            if (sentSessions.contains(sid)) continue;
                            if (senderSessionId != null && senderSessionId.equals(sid)) continue; // 발신 세션만 제외
                            Long wsMemberId = toLong(s.getAttributes().get("member_id"));
                            if (wsMemberId == null) continue;
                            if (receiverId.equals(wsMemberId)) {
                                s.sendMessage(new TextMessage(payload));
                                sentSessions.add(sid);
                            }
                        } catch (Exception e) {
                            log.warn("broadcast -> send to other session failed: {}", e.getMessage());
                        }
                    }
                }
            }

        } catch (Exception e) {
            log.warn("broadcast 오류: {}", e.getMessage());
        }
    }
    
    private Long extractRoomId(WebSocketSession session) {
        URI uri = session.getUri();
        if (uri == null) return null;
        String query = uri.getQuery();
        if (query == null) return null;
        for (String param : query.split("&")) {
            String[] pair = param.split("=");
            if (pair.length == 2 && "roomId".equals(pair[0])) {
                try { return Long.parseLong(pair[1]); } catch (NumberFormatException ignore) {}
            }
        }
        return null;
    }

    private Long toLong(Object... candidates) {
        for (Object c : candidates) {
            if (c == null) continue;
            if (c instanceof Number) return ((Number) c).longValue();
            try { return Long.parseLong(String.valueOf(c)); } catch (Exception ignore) {}
        }
        return null;
    }

    private String str(Object o) { return o == null ? null : String.valueOf(o); }
}
