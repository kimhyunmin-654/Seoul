package com.sp.app.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody; 
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.sp.app.common.StorageService;
import com.sp.app.model.Member;
import com.sp.app.model.SessionInfo;
import com.sp.app.service.MemberService;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/member/*")
public class MemberController {
	private final MemberService service;
	private final StorageService storageService;
	
	private String uploadPath;
	
	@PostConstruct
	public void init() {
		uploadPath = this.storageService.getRealPath("/uploads/member");
	}
	
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
				.nickname(dto.getNickname())
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
			uri = "redirect:/product/list";
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

		return "redirect:/product/list";
	}

	@GetMapping("account")
	public String memberForm(Model model) {
		model.addAttribute("mode", "account");
		return "member/selectmember";
	}
	
	@GetMapping("account2")
	public String memberForm2(Model model) {
		model.addAttribute("mode", "account2");
		return "member/member";
	}
	
	@GetMapping("account3")
	public String memberForm3(Model model) {
		model.addAttribute("mode", "account3");
		return "member/member2";
	}

	@PostMapping("account2")
	public String memberSubmit(Member dto, final RedirectAttributes reAttr, 
			Model model, HttpServletRequest req) {
		
		try {
			service.insertMember(dto, uploadPath);
			
			StringBuilder sb = new StringBuilder();
			sb.append(dto.getName() + "님이 회원 가입이 정상적으로 처리되었습니다.<br>");
			sb.append("메인화면으로 이동하여 로그인 하시기 바랍니다.<br>");
			
			reAttr.addFlashAttribute("message", sb.toString());
			reAttr.addFlashAttribute("title", "회원 가입");
			
			return "redirect:/member/complete";
			
		} catch (DuplicateKeyException e) {
			model.addAttribute("mode", "account2");
			model.addAttribute("message", "아이디 중복으로 회원가입이 실패했습니다.");
		} catch (DataIntegrityViolationException e) {
			model.addAttribute("mode", "account2");
			model.addAttribute("message", "제약 조건 위반으로 회원가입이 실패했습니다.");
		} catch (Exception e) {
			model.addAttribute("mode", "account2");
			model.addAttribute("message", "회원가입이 실패했습니다.");
		}

		
		return "member/member";
	}
	
	@PostMapping("account3")
	public String memberSubmit2(Member dto, final RedirectAttributes reAttr, 
			Model model, HttpServletRequest req) {
		
		try {
			service.insertMember2(dto, uploadPath);
			
			StringBuilder sb = new StringBuilder();
			sb.append(dto.getName() + "님이 회원 가입이 정상적으로 처리되었습니다.<br>");
			sb.append("메인화면으로 이동하여 로그인 하시기 바랍니다.<br>");
			
			reAttr.addFlashAttribute("message", sb.toString());
			reAttr.addFlashAttribute("title", "회원 가입");
			
			return "redirect:/member/complete";
			
		} catch (DuplicateKeyException e) {
			model.addAttribute("mode2", "account3");
			model.addAttribute("message", "아이디 중복으로 회원가입이 실패했습니다.");
		} catch (DataIntegrityViolationException e) {
			model.addAttribute("mode2", "account3");
			model.addAttribute("message", "제약 조건 위반으로 회원가입이 실패했습니다.");
		} catch (Exception e) {
			model.addAttribute("mode2", "account3");
			model.addAttribute("message", "회원가입이 실패했습니다.");
		}
		
		return "member/member2";
	}
	
	@PostMapping("update")
	public String updateSubmit(Member dto,
			final RedirectAttributes reAttr,
			Model model,
			HttpSession session) {
		
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		StringBuilder sb = new StringBuilder();
		try {
			dto.setMember_id(info.getMember_id());
			
			service.updateMember(dto, uploadPath);
			
			info.setNickname(dto.getNickname());
			info.setEmail(dto.getEmail());
			info.setAvatar(dto.getProfile_photo());
			
			session.setAttribute("member", info);
			
			sb.append(dto.getName() + "님의 회원정보가 정상적으로 변경되었습니다.<br>");
			sb.append("메인화면으로 이동 하시기 바랍니다.<br>");
		} catch (Exception e) {
			sb.append(dto.getName() + "님의 회원정보 변경이 실패했습니다.<br>");
			sb.append("잠시후 다시 변경 하시기 바랍니다.<br>");
		}
		
		reAttr.addFlashAttribute("title", "회원 정보 수정");
		reAttr.addFlashAttribute("message", sb.toString());
		
		return "redirect:/member/complete";
	}
	
	@GetMapping("complete")
	public String complete(@ModelAttribute("message") String message) throws Exception {
		if(message == null || message.isBlank()) {
			return "redirect:/product/list";
		}
		return "member/complete";
	}
	
	@ResponseBody
	@PostMapping("userIdCheck")
	public Map<String, ?> idCheck(@RequestParam(name = "login_id") String login_id) throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		String p = "false";
		try {
			Member dto = service.findById(login_id);
			if(dto == null) {
				p = "true";
			}
		} catch (Exception e) {
			log.info("idCheck : ", e);
		}
		model.put("passed", p);
		
		return model;	
	}
	
	@ResponseBody
	@PostMapping("userNickNameCheck")
	public Map<String, ?> nicknameCheck(@RequestParam(name = "nickname") String nickname) throws Exception {
		Map<String, Object> model = new HashMap<>();
		
		String p = "false";
		try {
			Member dto = service.findByNickName(nickname);
			if(dto == null) {
				p = "true";
			}
		} catch (Exception e) {
			log.info("nicknameCheck : ", e);
		}
		model.put("passed", p);
		
		return model;
	}
	
	@GetMapping("noAuthorized")
	public String noAuthorized(Model model) {
		return "member/noAuthorized";
	}
	
	
	@GetMapping("pwdFind")
	public String pwdFindForm(HttpSession session) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		if(info != null) {
			return "redirect:/product/list";
		}
		
		return "member/pwdFind";
	}
	
	
	@PostMapping("pwdFind")
	public String pwdFindSubmit(@RequestParam(name = "login_id") String login_id,
			RedirectAttributes reAttr,
			Model model) throws Exception {
		
		try {
			Member dto = service.findById(login_id);
			if(dto == null || dto.getEmail() == null || dto.getUserLevel() == 0 || dto.getEnabled() == 0) {
				model.addAttribute("message", "등록된 아이디가 아닙니다.");
				
				return "member/pwdFind";
			}
			
			service.generatePwd(dto);
			
			StringBuilder sb = new StringBuilder();
			sb.append("회원님의 이메일로 임시패스워드를 전송했습니다.<br>");
			sb.append("로그인 후 패스워드를 변경하시기 바랍니다.<br>");
			
			reAttr.addFlashAttribute("title", "패스워드 찾기");
			reAttr.addFlashAttribute("message", sb.toString());
			
			return "redirect:/member/complete";
			
		} catch (Exception e) {
			model.addAttribute("message", "이메일 전송이 실패했습니다.");
		}
		
		return "member/pwdFind";
	}
	
	@GetMapping("mypage")
	public String mypage(HttpSession session, Model model) {
	   
	    SessionInfo info = (SessionInfo) session.getAttribute("member");
	    if (info == null) {
	        return "redirect:/member/login";
	    }
	    if (info.getUserLevel() == 9) {
	        return "redirect:/admin/mypage";
	    }


	    model.addAttribute("loginUser", info);
	    return "member/mypage";
	}
	
	@GetMapping("pwd")
	public String pwdForm(@RequestParam(name = "dropout", required = false) String dropout, 
			Model model) {

		if (dropout == null) {
			model.addAttribute("mode", "update");
		} 

		return "member/pwd";
	}
	
	@PostMapping("pwd")
	public String pwdSubmit(@RequestParam(name = "password") String password,
			@RequestParam(name = "mode") String mode, 
			final RedirectAttributes reAttr,
			Model model,
			HttpSession session) {

		try {
			SessionInfo info = (SessionInfo) session.getAttribute("member");
			Member dto = Objects.requireNonNull(service.findById(info.getMember_id()));

			if (! dto.getPassword().equals(password)) {
				model.addAttribute("mode", mode);
				model.addAttribute("message", "패스워드가 일치하지 않습니다.");
				
				return "member/pwd";
			}

			model.addAttribute("dto", dto);
			model.addAttribute("mode", "update");
			
			
			if(dto.getUserLevel() == 1) {
				return "member/member"; // 일반회원 수정폼
			} else if(dto.getUserLevel() == 5) {
				return "member/member2"; // 셀러 수정폼
			} else if(dto.getUserLevel() == 9) {
				return "member/member"; // 관리자 수정폼
			}
					
		} catch (NullPointerException e) {
			session.invalidate();
		} catch (Exception e) {
		}
		
		return "redirect:/member/mypage";
	}
	
	@ResponseBody
	@PostMapping("deleteProfile")
	public Map<String, ?> deleteProfilePhoto(@RequestParam(name = "profile_photo") String profile_photo,
			HttpSession session) throws Exception {
		Map<String, Object> model = new HashMap<String, Object>();
		
		SessionInfo info = (SessionInfo)session.getAttribute("member");

		String state = "false";
		try {
			if(! profile_photo.isBlank()) {
				Map<String, Object> map = new HashMap<>();
				map.put("member_id", info.getMember_id());
				map.put("filename", info.getAvatar());
				
				service.deleteProfilePhoto(map, uploadPath);
				
				info.setAvatar("");
				state = "true";
			}
		} catch (Exception e) {
		}
		
		model.put("state", state);
		
		return model;
	}
	
	@GetMapping("delete")
	public String deleteForm() {
	    // 회원 탈퇴를 위한 비밀번호 입력 페이지로 이동
	    return "member/delete";
	}
	
	@PostMapping("delete")
	@ResponseBody
	public Map<String, Object> deleteMember(@RequestParam("password") String password, HttpSession session) {
	    Map<String, Object> model = new HashMap<>();
	    String state = "true";
	    String message = "회원 탈퇴가 정상적으로 처리되었습니다.";

	    try {
	        SessionInfo info = (SessionInfo) session.getAttribute("member");
	        if (info == null) {
	            state = "false";
	            message = "세션이 만료되었습니다. 다시 로그인해주세요.";
	            model.put("state", state);
	            model.put("message", message);
	            return model;
	        }

	        Member member = service.findById(info.getMember_id());
	        if (member == null || !password.equals(member.getPassword())) {
	            state = "false";
	            message = "비밀번호가 일치하지 않습니다.";
	            model.put("state", state);
	            model.put("message", message);
	            return model;
	        }

	        Member dto = new Member();
	        dto.setMember_id(info.getMember_id());
	        dto.setEnabled(0);
	        dto.setName("탈퇴한 회원");

	        service.deleteMember(dto);
	        session.invalidate();

	    } catch (Exception e) {
	        state = "false";
	        message = "회원 탈퇴 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.";
	        e.printStackTrace();
	    }
	    
	    model.put("state", state);
	    model.put("message", message);
	    return model;
	}

	@GetMapping("idFind")
	public String idFindForm() throws Exception {
		
		return "member/idFind";
	}
	
	
	@PostMapping("idFind")
	public String idFindSubmit(
			@RequestParam(name = "name") String name, 
			@RequestParam(name = "email") String email,
			HttpServletRequest request,
			Model model,
			Member dto) throws Exception {
		try {
			dto.setName(name);
			dto.setEmail(email);
			Member login_id = service.findMemberId(dto);
			
			model.addAttribute("findId", login_id);
			
			return "member/complete2";
		} catch (Exception e) {
			log.info("idFindSubmit", e);
			model.addAttribute("message", "오류가 발생되었습니다");
			
		}
		return "member/idFind";
	}	
	
}
