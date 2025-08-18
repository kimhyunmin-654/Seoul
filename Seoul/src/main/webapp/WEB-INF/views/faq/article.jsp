<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>서울 한바퀴</title>
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>


<main class="main-container">

	<div class="container py-4 px-5">
		<div class="row justify-content-center">
			<div class="col-xl-8 col-lg-9 col-md-10"> 
	
				<div class="bg-white shadow-sm rounded p-5">
	
					<div class="pb-4 border-bottom">
						<h5 class="fw-bold mb-3">${dto.question}</h5>
						<div class="d-flex justify-content-between text-secondary small">
							<span>작성자: ${dto.nickname}</span>
							<span>작성일: ${dto.update_date} | 조회수: ${dto.hit_count}</span>
						</div>
					</div>
	
					<div class="py-4" style="min-height: 200px;">
						${dto.content}
					</div>
	
					<hr>
	
					<div class="mb-2 text-truncate">
						<strong>이전글:</strong>
						<c:if test="${not empty prevDto}">
							<a href="${pageContext.request.contextPath}/faq/article?${query}&faq_id=${prevDto.faq_id}" style="text-decoration: none; color: black">
								${prevDto.question}
							</a>
						</c:if>
					</div>
					<div class="mb-4 text-truncate">
						<strong>다음글:</strong>
						<c:if test="${not empty nextDto}">
							<a href="${pageContext.request.contextPath}/faq/article?${query}&faq_id=${nextDto.faq_id}" style="text-decoration: none; color: black">
								${nextDto.question}
							</a>
						</c:if>
					</div>
	
					<div class="d-flex justify-content-between mt-4">	
						<div>
							<button type="button" class="btn btn-secondary"
								onclick="location.href='${pageContext.request.contextPath}/faq/list';">
								리스트
							</button>
						</div>
					</div>
	
				</div>
			</div>
		</div>
	</div>
</main>

</body>
</html>