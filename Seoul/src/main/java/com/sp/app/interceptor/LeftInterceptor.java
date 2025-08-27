package com.sp.app.interceptor;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.sp.app.model.Category;
import com.sp.app.model.Region;
import com.sp.app.service.ProductService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class LeftInterceptor implements HandlerInterceptor {

    private final ProductService productService;

    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception {
        

        List<Category> categoryList = productService.listCategories();
        List<Region> regionList = productService.listRegion();
        
        
        req.setAttribute("categoryList", categoryList);
        req.setAttribute("regionList", regionList);
        
        return true; 
    }
}
