package com.sp.app.interceptor;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.sp.app.model.SessionInfo;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;



@Slf4j
public class LoginCheckInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception {
	    HttpSession session = req.getSession(false);
	    SessionInfo info = (session == null) ? null : (SessionInfo) session.getAttribute("member");
	    final String cp = req.getContextPath();
	    String uri = req.getRequestURI();
	    String qs  = req.getQueryString();

	    // 에러 디스패치 건드리지 않음
	    if (req.getDispatcherType() == DispatcherType.ERROR) {
	        return true;
	    }

	    try {
	        // 권한 체크(예: /admin)
	        if (info != null && uri.contains("/admin") && info.getUserLevel() < 5) {
	            resp.sendRedirect(cp + "/member/noAuthorized");
	            return false;
	        }

	        // 로그인 체크
	        if (info == null) {
	            if (uri.startsWith(cp)) uri = uri.substring(cp.length());
	            if (qs != null) uri += "?" + qs;
	            req.getSession(true).setAttribute("preLoginURI", uri);

	            if (isAjaxRequest(req)) {
	                resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
	            } else {
	                resp.sendRedirect(cp + "/member/login");
	            }
	            return false; 
	        }

	        return true;
	    } catch (Exception e) {
	        log.warn("LoginCheckInterceptor error", e);
	        if (!resp.isCommitted()) {
	            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Interceptor error");
	        }
	        return false;
	    }
	}


	@Override
	public void postHandle(HttpServletRequest req, HttpServletResponse resp, Object handler, ModelAndView modelAndView)
			throws Exception {
	}


	@Override
	public void afterCompletion(HttpServletRequest req, HttpServletResponse resp, Object handler, Exception ex)
			throws Exception {
	}

	private boolean isAjaxRequest(HttpServletRequest req) {
	    String xrw = req.getHeader("X-Requested-With");
	    if ("XMLHttpRequest".equalsIgnoreCase(xrw)) return true;
	    String ajax = req.getHeader("AJAX");
	    return ajax != null && ajax.equalsIgnoreCase("true");
	}

}
