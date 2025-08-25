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
		<h3>아이디 찾기</h3>

		<form name="idForm" method="post">
			<input type="text" name="name" placeholder="이름">
			<input type="text" name="email" placeholder="이메일">
			<button type="button" onclick="sendOk();">확인 <i class="bi bi-check2"></i></button>
		</form>

		<p class="text-danger">${message}</p>
	</div>
</main>

<script type="text/javascript">
function sendOk() {
	const f = document.idForm;

	if(! f.name.value.trim()) {
		alert('이름를 입력하세요. ');
		f.name.focus();
		return;
	}
	
	if(! f.email.value.trim()) {
		alert('이메일을 입력하세요. ');
		f.email.focus();
		return;
	}

	f.action = '${pageContext.request.contextPath}/member/idFind';
	f.submit();
}
</script>


</body>
</html>