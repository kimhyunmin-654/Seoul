<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Spring</title>
</head>
<body>

<main>
	<h3>메인 페이지</h3>

	<c:if test="${sessionScope.member == null}">
		<a href="${pageContext.request.contextPath}/member/login" class="border-link-right">로그인</a>
	</c:if>

	<c:if test="${sessionScope.member != null}">
		<a href="${pageContext.request.contextPath}/member/logout" class="border-link-right">로그아웃</a>
	</c:if>
</main>

</body>
</html>
