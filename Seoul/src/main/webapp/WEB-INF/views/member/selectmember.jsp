<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>서울 한바퀴</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/selectmember.css" type="text/css">
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
</head>
<body>

<div class="signup-select-container">
	<h2>회원가입 유형</h2>

	<a href="${pageContext.request.contextPath}/member/account2" class="btn signup-btn btn-user">
		👤 일반회원 가입
	</a>
</div>

</body>
</html>
