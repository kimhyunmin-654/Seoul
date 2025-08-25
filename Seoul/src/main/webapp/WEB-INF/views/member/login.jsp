<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>서울 한바퀴</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/login.css" type="text/css">
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
</head>
<body>

<header>
  <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

	<div class="login-container">
	    <h3>회원 로그인</h3>
	    
	    <form name="loginForm" method="post">
	        <div class="mb-3">
	            <label class="form-label">아이디</label>
	            <input type="text" id="login_id" name="login_id" class="form-control" placeholder="아이디">
	        </div>
	        <div class="mb-3">
	            <label class="form-label">패스워드</label>
	            <input type="password" name="password" class="form-control" placeholder="비밀번호">
	        </div>
	        <div class="mb-3 form-check">
	            <input type="checkbox" class="form-check-input" id="rememberMe">
	            <label class="form-check-label" for="rememberMe">아이디 저장</label>
	        </div>
	
	        <div class="d-grid mb-2">
	            <button type="submit" class="btn btn-accent" onclick="sendLogin()">로그인</button>
	        </div>
	        <div class="d-grid mb-3">
	            <button type="button" class="btn btn-kakao" onclick="loginWithKakao()">카카오 로그인</button>
	        </div>
	
	        <div class="text-center text-danger mb-2">${message}</div>
	
	        <div class="text-center login-links">
	            <a href="${pageContext.request.contextPath}/member/idFind">아이디 찾기</a> |
	            <a href="${pageContext.request.contextPath}/member/pwdFind">비밀번호 찾기</a> |
	            <a href="${pageContext.request.contextPath}/member/account">회원가입</a>
	        </div>
	    </form>
	</div>

<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.5/kakao.min.js" integrity="sha384-dok87au0gKqJdxs7msEdBPNnKSRT+/mhTVzq+qOhcL464zXwvcrpjeWvyj1kCdq6" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
$(function(){
    try {
        const saved = localStorage.getItem("savedLoginId");
        if (saved) {
            const loginInput = document.getElementById("login_id");
            if (loginInput) loginInput.value = saved;
            const remember = document.getElementById("rememberMe"); 
            if (remember) remember.checked = true;
        }
    } catch (e) {
        console.warn("읽기 실패:", e);
    }
});

function sendLogin(event) {
	if (event && event.preventDefault) event.preventDefault();
	
    const f = document.loginForm;
    const saveId = document.getElementById("rememberMe").checked;
    
    if( ! f.login_id.value.trim() ) {
        f.login_id.focus();
        return;
    }

    if( ! f.password.value.trim() ) {
        f.password.focus();
        return;
    }

	if (saveId) {
		localStorage.setItem("savedLoginId", f.login_id.value.trim());
	} else {
		localStorage.removeItem("savedLoginId");
	}	    
    
    f.action = '${pageContext.request.contextPath}/member/login';
    f.submit();
}

function loginWithKakao() {
    // 로그인 모달 창이 열려 있다면 닫음 (모달 중복 방지)
    // $('#loginModal').modal('hide');

    // 카카오 JavaScript 앱 키 (카카오 개발자 콘솔에서 발급받은 키로 교체 필요)
    const JAVASCRIPT_KEY = ''; 

    // 로그인 완료 후 인가 코드를 받을 리다이렉트 URI
    const REDIRECT_URI = 'http://localhost:9090/oauth/kakao/callback';

    // 카카오 로그인 인증 요청 URL 구성
    const kakaoAuthUrl = `https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=\${JAVASCRIPT_KEY}&redirect_uri=\${REDIRECT_URI}&prompt=login`;

    // 팝업창 설정 (사이즈, 옵션 등)
    const setting = 'width=500,height=700,menubar=no,location=no,status=no,scrollbars=yes,resizable=no';

    // 새 창(팝업)으로 로그인 인증 페이지 오픈
    const popup = window.open(kakaoAuthUrl, 'kakaoLogin', setting);
}
</script>


</body>
</html>