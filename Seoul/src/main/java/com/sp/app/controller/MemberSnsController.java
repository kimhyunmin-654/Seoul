package com.sp.app.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.model.Member;
import com.sp.app.model.SessionInfo;
import com.sp.app.oauth.KakaoAuthService;
import com.sp.app.oauth.KakaoUser;
import com.sp.app.service.MemberService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class MemberSnsController {
	private final MemberService memberService;
	private final KakaoAuthService kakaoService;
	
	public static final String SNS_PROVIDER_KAKAO = "kakao";
	
	@GetMapping("/oauth/kakao/callback")
	public void kakaoLogin(@RequestParam("code") String code,
	        HttpServletRequest req,
	        HttpServletResponse resp,
	        HttpSession session) throws Exception {

	    try {
	        String accessToken = kakaoService.getAccessToken(code);
	        if (accessToken == null) {
	            log.error("kakaoLogin: accessToken is null for code={}", code);
	            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "카카오 인증 실패");
	            return;
	        }

	        KakaoUser kakaoUser = kakaoService.getUserInfo(accessToken);
	        if (kakaoUser == null || kakaoUser.getId() == null) {
	            log.error("kakaoLogin: kakaoUser or id is null, body may be invalid");
	            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "카카오 사용자 정보 불러오기 실패");
	            return;
	        }

	        String sns_id = String.valueOf(kakaoUser.getId());
	        String sns_provider = SNS_PROVIDER_KAKAO;

	        Map<String, Object> map = new HashMap<>();
	        map.put("sns_id", sns_id);
	        map.put("sns_provider", sns_provider);

	        Member dto = memberService.loginSnsMember(map);
	        if (dto == null) {
	            dto = new Member();

	            // 닉네임 (필수): 카카오에서 주지 않으면 fallback 생성
	            String nickname = kakaoUser.getNickname();
	            if (nickname == null || nickname.isBlank()) {
	                nickname = "kakao_" + sns_id;
	                log.info("kakaoLogin: nickname missing, use fallback={}", nickname);
	            }
	            dto.setNickname(nickname);
	            dto.setName(nickname);

	            // 이메일: 없으면 placeholder 생성 (운영정책에 따라 변경)
	            String email = kakaoUser.getEmail();
	            if (email == null || email.isBlank()) {
	                email = sns_provider + "_" + sns_id + "@noemail.kakao";
	                log.info("kakaoLogin: email missing, use placeholder={}", email);
	            }
	            dto.setEmail(email);

	            String rawPwd = java.util.UUID.randomUUID().toString();

	            dto.setPassword(rawPwd);

	            dto.setSns_id(sns_id);
	            dto.setSns_provider(sns_provider);
	            dto.setUserLevel(1); // 필요하면 DTO 타입에 맞게 조정

	            // member_id는 service에서 시퀀스 채워 넣음
	            memberService.insertSnsMember(dto);
	        }

	        // 세션 생성
	        SessionInfo info = SessionInfo.builder()
	                .member_id(dto.getMember_id())
	                .login_id(dto.getSns_id())
	                .name(dto.getName())
	                .email(dto.getEmail())
	                .userLevel(1)
	                .login_type(dto.getSns_provider())
	                .build();

	        session.setMaxInactiveInterval(30 * 60);
	        session.setAttribute("member", info);

	    } catch (Exception e) {
	        log.error("kakaoLogin error", e);
	        // 팝업/리다이렉트 방식에 따라 적절한 오류 처리(간단히 메시지 출력)
	        resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "카카오 로그인 처리 중 오류 발생");
	        return;
	    }

	    // 리디렉트 URI 복원 및 팝업 종료 스크립트(안전하게 인코딩)
	    String cp = req.getContextPath();
	    String uri = (String) session.getAttribute("preLoginURI"); // 기존 사용키로 복원
	    session.removeAttribute("preLoginURI"); // 오타 수정

	    if (uri == null) {
	        uri = cp + "/";
	    } else {
	        uri = cp + uri;
	    }

	    String safeUri = java.net.URLEncoder.encode(uri, java.nio.charset.StandardCharsets.UTF_8);
	    StringBuilder sb = new StringBuilder();
	    sb.append("<!doctype html><html><head><meta charset=\"utf-8\"></head><body>");
	    sb.append("<script>");
	    sb.append("try{");
	    sb.append("  var target = decodeURIComponent('").append(safeUri).append("');");
	    sb.append("  if(window.opener && !window.opener.closed){");
	    sb.append("    window.opener.location.replace(target);");
	    sb.append("    window.close();");
	    sb.append("  } else {");
	    sb.append("    location.replace(target);");
	    sb.append("  }");
	    sb.append("}catch(e){");
	    sb.append("  console.error(e); location.replace(decodeURIComponent('").append(safeUri).append("'));");
	    sb.append("}");
	    sb.append("</script>");
	    sb.append("</body></html>");

	    resp.setContentType("text/html;charset=UTF-8");
	    resp.getWriter().println(sb.toString());
	    resp.getWriter().flush();
	}
		
}
