package com.sp.app.chat.websocket;

import java.util.Map;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import jakarta.servlet.http.HttpSession;

import com.sp.app.model.Member;
import com.sp.app.model.SessionInfo;

@Component
public class ChatHandshakeInterceptor implements HandshakeInterceptor {

    @Override
    public boolean beforeHandshake(ServerHttpRequest request,
                                   ServerHttpResponse response,
                                   WebSocketHandler wsHandler,
                                   Map<String, Object> attributes) {
        if (request instanceof ServletServerHttpRequest) {
            ServletServerHttpRequest servlet = (ServletServerHttpRequest) request;
            HttpSession http = servlet.getServletRequest().getSession(false);
            if (http != null) {
                Object obj = http.getAttribute("member"); // 컨트롤러에서 쓰던 그 키

                if (obj instanceof SessionInfo) {
                    SessionInfo info = (SessionInfo) obj;
                    attributes.put("member_id", info.getMember_id());
                } else if (obj instanceof Member) {
                    Member m = (Member) obj;
                    attributes.put("member_id", m.getMember_id());
                }
            }
        }
        return true; // handshake 계속 진행
    }

    @Override
    public void afterHandshake(ServerHttpRequest request,
                               ServerHttpResponse response,
                               WebSocketHandler wsHandler,
                               Exception exception) {
        // no-op
    }
}
