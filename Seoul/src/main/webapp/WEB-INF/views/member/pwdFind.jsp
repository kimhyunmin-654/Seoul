<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/pwdfind.css" type="text/css">
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
<title>서울 한바퀴</title>
</head>
<body>

<main>
	<div class="find-box">
		<h3>패스워드 찾기</h3>
		<p>회원 아이디를 입력하세요</p>

		<form name="pwdForm" method="post">
			<input type="text" name="login_id" placeholder="아이디">
			<button type="button" onclick="sendOk();">확인 <i class="bi bi-check2"></i></button>
		</form>

		<p class="text-danger">${message}</p>
	</div>
</main>

<script type="text/javascript">
function sendOk() {
	const f = document.pwdForm;

	if(! f.login_id.value.trim()) {
		alert('아이디를 입력하세요. ');
		f.login_id.focus();
		return;
	}

	f.action = '${pageContext.request.contextPath}/member/pwdFind';
	f.submit();
}
</script>


</body>
</html>