package com.sp.app.config;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.context.annotation.Configuration;

import jakarta.websocket.server.ServerEndpointConfig;

/*
 - @ServerEndPoint가 붙은 클래스는 웹소켓이 연결될때마다 객체가 생성되기 때문에 @Autowired가 설정된 멤버가 정상적으로 초기화되지 않는다. 
 - 해결책
   Config클래스를 정의하여 ServerEndpoint의 컨텍스트에 BeanFactory 또는 ApplicationContext를 연결해주면 된다.
*/

@Configuration
public class ServerEndpointConfigurator extends ServerEndpointConfig.Configurator implements ApplicationContextAware {
    private static volatile BeanFactory context;

    @Override
    public <T> T getEndpointInstance(Class<T> clazz) throws InstantiationException {
        return context.getBean(clazz);
    }

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
      ServerEndpointConfigurator.context = applicationContext;
    }

    /*
    // session에 접근 --
	@Override
	public void modifyHandshake(ServerEndpointConfig config, HandshakeRequest request, HandshakeResponse response) {
		HttpSession session = (HttpSession) request.getHttpSession();
		config.getUserProperties().put(HttpSession.class.getName(), session);
	}
	*/    
}