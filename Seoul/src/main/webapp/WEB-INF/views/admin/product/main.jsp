<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>서울 한바퀴</title>
<jsp:include page="/WEB-INF/views/admin/product/layout/headerResources.jsp"/>
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/product/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/product/layout/left.jsp"/>

	<div class="right-panel">
		<div class="section" data-aos="fade-up" data-aos-delay="200">
			<div class="section-body">
				괸라자 메인 화면 입니다.
			</div>
		</div>
		
	</div>
</main>

<footer>
	<jsp:include page="/WEB-INF/views/admin/product/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/product/layout/footerResources.jsp"/>

</body>
</html>