package com.sp.app.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.sp.app.interceptor.LeftInterceptor;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class LeftMvcConfig implements WebMvcConfigurer {

    private final LeftInterceptor leftInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(leftInterceptor)
                .addPathPatterns("/product/list", "/auction/list", "/product/detail/**", "/auction/detail/**");
    }
}
