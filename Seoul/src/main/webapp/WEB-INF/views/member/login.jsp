<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Spring</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>



<main>
	<div class="section bg-light">
		<div class="container">

			<div class="row justify-content-center" data-aos="fade-up" data-aos-delay="200">
				<div class="col-md-5">
					<div class="bg-white box-shadow my-5 p-5">
						<h3 class="text-center pt-3"><i class="bi bi-lock"></i> 회원 로그인</h3>
	                    
						<form name="loginForm" action="" method="post" class="row g-3 mb-2">
							<div class="col-12">
								<label class="mb-1">아이디</label>
								<input type="text" name="login_id" class="form-control" placeholder="아이디">
							</div>
							<div class="col-12">
								<label class="mb-1">패스워드</label>
								<input type="password" name="password" class="form-control" autocomplete="off" 
									placeholder="패스워드">
							</div>
							<div class="col-12">
								<div class="form-check">
									<input class="form-check-input rememberMe" type="checkbox" id="rememberMe">
									<label class="form-check-label" for="rememberMe"> 아이디 저장</label>
								</div>
							</div>
							<div class="col-12 text-center">
								<button type="button" class="btn-accent btn-lg w-100" onclick="sendLogin();">&nbsp;Login&nbsp;<i class="bi bi-check2"></i></button>
							</div>
							<div class="col-12 d-flex justify-content-between">
								<button type="button" class="btn-light flex-fill me-2" onclick="loginWithKakao();">카카오</button>

							</div>
						</form>
	                    
						<div>
							<p class="form-control-plaintext text-center text-danger">${message}</p>
						</div>

						<div class="mt-3">
							<p class="text-center">
								<a href="#" class="me-2 border-link-right">아이디 찾기</a>
								<a href="${pageContext.request.contextPath}/member/pwdFind"  class="me-2 border-link-right">패스워드 찾기</a>
								<a href="${pageContext.request.contextPath}/member/account" class="border-link-right">회원가입</a>
							</p>
						</div>
	                    
					</div>
	
				</div>
			</div>

		</div>
	</div>
</main>

<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.5/kakao.min.js" integrity="sha384-dok87au0gKqJdxs7msEdBPNnKSRT+/mhTVzq+qOhcL464zXwvcrpjeWvyj1kCdq6" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
function sendLogin() {
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