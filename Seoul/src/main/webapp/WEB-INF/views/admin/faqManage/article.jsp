<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Seoul</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

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
							<a href="${pageContext.request.contextPath}/admin/faqManage/article?${query}&faq_id=${prevDto.faq_id}">
								${prevDto.question}
							</a>
						</c:if>
					</div>
					<div class="mb-4 text-truncate">
						<strong>다음글:</strong>
						<c:if test="${not empty nextDto}">
							<a href="${pageContext.request.contextPath}/admin/faqManage/article?${query}&faq_id=${nextDto.faq_id}">
								${nextDto.question}
							</a>
						</c:if>
					</div>
	
					<div class="d-flex justify-content-between mt-4">
						<div>
							<c:choose>
								<c:when test="${sessionScope.member.member_id == dto.member_id}">
									<button type="button" class="btn btn-outline-primary me-2"
										onclick="location.href='${pageContext.request.contextPath}/admin/faqManage/update?faq_id=${dto.faq_id}&page=${page}';">
										수정
									</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="btn btn-outline-secondary me-2" disabled>수정</button>
								</c:otherwise>
							</c:choose>
	
							<c:choose>
								<c:when test="${sessionScope.member.member_id == dto.member_id || sessionScope.member.userLevel > 5}">
									<button type="button" class="btn btn-outline-danger" onclick="deleteOk();">삭제</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="btn btn-outline-secondary" disabled>삭제</button>
								</c:otherwise>
							</c:choose>
						</div>
	
						<div>
							<button type="button" class="btn btn-secondary"
								onclick="location.href='${pageContext.request.contextPath}/admin/faqManage/list';">
								리스트
							</button>
						</div>
					</div>
	
				</div>
			</div>
		</div>
	</div>
</main>

<c:if test="${sessionScope.member.member_id == dto.member_id || sessionScope.member.userLevel > 5}">
	<script type="text/javascript">
		function deleteOk() {
			if(confirm('게시글을 삭제하시겠습니까 ? ')) {
				let params = 'faq_id=${dto.faq_id}&page=${page}';
				let url = '${pageContext.request.contextPath}/admin/faqManage/delete?' + params;
				location.href = url;
			}
		}
		
	</script>
</c:if>
<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>