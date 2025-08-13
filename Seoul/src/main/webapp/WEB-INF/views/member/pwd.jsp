<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/pwd.css" type="text/css">
<title>Spring</title>
</head>
<body>

<header>
  <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>
    <div class="password-box">
        <h3>패스워드 재확인</h3>
        <p class="info">정보보호를 위해 패스워드를 다시 한 번 입력해주세요.</p>

        <form name="pwdForm" method="post">
            <input type="text" name="login_id" placeholder="아이디" value="${sessionScope.member.login_id}" readonly>
            <input type="password" name="password" placeholder="패스워드" autocomplete="off">
            <input type="hidden" name="mode" value="${mode}">
            <button type="button" onclick="sendOk()">확인 <i class="bi bi-check2"></i></button>
        </form>

        <p class="text-danger">${message}</p>
    </div>
</main>

<script type="text/javascript">
function sendOk() {
	const f = document.pwdForm;

	if(! f.password.value.trim()) {
		alert('패스워드를 입력하세요. ');
		f.password.focus();
		return;
	}

	f.action = '${pageContext.request.contextPath}/member/pwd';
	f.submit();
}
</script>


</body>
</html>