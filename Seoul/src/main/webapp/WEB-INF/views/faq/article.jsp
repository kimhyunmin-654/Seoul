<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Seoul</title>
</head>
<body>

<header>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>


<main class="main-container">
<!-- Page Title -->
	<div class="page-title">
		<div class="container align-items-center" data-aos="fade-up">
			<h1>FAQ</h1>
			<div class="page-title-underline-accent"></div>
		</div>
	</div>
    
	<!-- Page Content -->    
	<div class="section">
		<div class="container" data-aos="fade-up" data-aos-delay="100">
			<div class="row justify-content-center">
				<div class="col-md-10 board-section my-4 p-5">

					<div class="pb-2">
						<span class="small-title">상세정보</span>
					</div>
									
					<table class="table board-article">
						<thead>
							<tr>
								<td colspan="2" class="text-center">
									${dto.question}
								</td>
							</tr>
						</thead>

						<tbody>
							<tr>
								<td width="50%">
									작성자 : ${dto.nickname}
								</td>
								<td width="50%" class="text-end">
									작성일 : ${dto.update_date} | 조회 ${dto.hit_count}
								</td>
							</tr>
							
							<tr>
								<td colspan="2" valign="top" height="200" class="article-content" style="border-bottom: none;">
									${dto.content}
								</td>
							</tr>						
							
							<tr>
								<td colspan="2">
									이전글 : 
									<c:if test="${not empty prevDto}">
										<a href="${pageContext.request.contextPath}/faq/article?${query}&faq_id=${prevDto.faq_id}">${prevDto.question}</a>
									</c:if>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									다음글 : 
									<c:if test="${not empty nextDto}">
										<a href="${pageContext.request.contextPath}/faq/article?${query}&faq_id=${nextDto.faq_id}">${nextDto.question}</a>
									</c:if>									
								</td>
							</tr>
						</tbody>
					</table>

						<div class="col-md-6 align-self-center text-end">
							<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/faq/list';">리스트</button>
						</div>
					</div>
					
				</div>
			</div>
		</div>
	</div>
</main>

</body>
</html>