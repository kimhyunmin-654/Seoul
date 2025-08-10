package com.sp.app.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.server.standard.ServerEndpointExporter;

@Configuration
public class MyWebSocketConfig {
	// ServerEndpointExporter : @ServerEndpoint 어노테이션을 활성화
	@Bean
	ServerEndpointExporter serverEndpointExporter() {
		return new ServerEndpointExporter();
	}
}
