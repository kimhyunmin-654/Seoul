<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>서울 한바퀴</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/mypage.css" type="text/css">

</head>
<body>

<header>
  <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="wrap">
  <jsp:include page="/WEB-INF/views/layout/leftmypage.jsp"/>
</main>

</body>
</html>
