package com.sp.app.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sp.app.model.Member;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/member/*")
public class MemberController {
	private final MemberService service;
	
	@GetMapping("login")
	public String loginForm() {
		return "member/login";
	}

	@PostMapping("login")
	public String loginSubmit(@RequestParam(name = "login_id") String login_id,
			@RequestParam(name = "password") String password,
			Model model,
			HttpSession session) {

		Map<String, Object> map = new HashMap<>();
		map.put("login_id", login_id);
		map.put("password", password);
		
		Member dto = service.loginMember(map);
		if (dto == null) {
			model.addAttribute("message", "아이디 또는 패스워드가 일치하지 않습니다.");
			return "member/login";
		}

		// 세션에 로그인 정보 저장
		SessionInfo info = SessionInfo.builder()
				.member_id(dto.getMember_id())
				.login_id(dto.getLogin_id())
				.name(dto.getName())
				.email(dto.getEmail())
				.userLevel(dto.getUserLevel())
				.avatar(dto.getProfile_photo())
				.login_type("local")
				.build();
		
		// 세션 유지시간
		session.setMaxInactiveInterval(30 * 60); // 30분. 기본:30분
		
		// 세션에 로그인 정보 저장
		session.setAttribute("member", info);
		
		// 로그인 이전 URI로 이동
		String uri = (String) session.getAttribute("preLoginURI");
		session.removeAttribute("preLoginURI");
		if (uri == null) {
			uri = "redirect:/";
		} else {
			uri = "redirect:" + uri;
		}

		return uri;
	}

	@GetMapping("logout")
	public String logout(HttpSession session) {
		// 세션에 저장된 정보 지우기
		session.removeAttribute("member");

		// 세션에 저장된 모든 정보 지우고, 세션초기화
		session.invalidate();

		return "redirect:/";
	}

	@GetMapping("account")
	public String memberForm(Model model) {
		model.addAttribute("mode", "account");
		return "member/member";
	}

	
	
	@GetMapping("noAuthorized")
	public String noAuthorized(Model model) {
		return "member/noAuthorized";
	}
}
