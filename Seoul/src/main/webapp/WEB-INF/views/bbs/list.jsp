<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>서울 한바퀴</title>
<jsp:include page="/WEB-INF/views/layout/leftResources.jsp"/>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/bbslist.css" type="text/css">

</head>
<body class="bg-light">

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<div class="container px-4 py-4 py-sm-6 py-lg-8 mx-auto">
	<div class="row">
		<aside class="col-lg-2">
			<div class="sticky-top" style="top: 2rem;">
				<jsp:include page="/WEB-INF/views/layout/left.jsp"/>
			</div>
		</aside>
        
		<main class="col-lg-10">
			
			<!-- Page Title -->
			<div class="page-title">
				<div class="container align-items-center">
					<h1>${region_name} 한바퀴</h1>
					<div class="page-title-underline-accent"></div>
				</div>
			</div>
			
			
			<!-- Page Content -->
			<div class="section">
				<div class="container">
					<div class="row justify-content-center">
					
						<div class="card col-md-11 p-4-5 shadow-sm mb-2">
							<!-- Search -->
							<h5 class="mb-3">🔍${region_name}에서 검색</h5>
							<div class="row mt-1 mb-2 justify-content-center search-form-container">
								<div class="d-flex align-items-center justify-content-start flex-wrap px-4">
									<form name="bbssearchForm" class="d-flex align-items-center justify-content-center form-search">
										<div class="input-group-prepend">
											<span class="me-1 input-group-text" style="background-color: #e9ecef; border-right: none; color: #495057;">
												동네글 검색
											</span>
										</div>
										<select name="schType" class="me-1">
											<option value="all" ${schType=="all"?"selected":""}>제목+내용</option>
											<option value="nickname" ${schType=="nickname"?"selected":""}>글쓴이</option>
											<option value="reg_date" ${schType=="reg_date"?"selected":""}>작성일</option>
											<option value="subject" ${schType=="subject"?"selected":""}>제목</option>
											<option value="content" ${schType=="content"?"selected":""}>내용</option>
										</select>
										<input type="text" class="me-1" name="kwd" value="${kwd}">
										<input type="hidden" name="region" value="${region_code}">
										<button type="button" class="btn-default btn-outline-secondary d-flex align-items-center me-1 px-5" onclick="searchList();"><i class="bi bi-search"></i>&nbsp;검색</button>
									</form>
								
									<button type="button" class="btn-default px-4" onclick="location.href='${pageContext.request.contextPath}/bbs/list?region=${region_code}';" title="새로고침"><i class="bi bi-arrow-clockwise"></i>&nbsp;새로고침</button>
								</div>
							</div>
						</div>
						
						
						<div class="col-md-11 board-section my-1 p-4-5">
				
							<div class="row py-1 mb-2">
								<div class="col-md-6 align-self-center">
									<h5 class="mb-3">📋 ${region_name}한바퀴 목록</h5> <span class="dataCount">${dataCount}개(${page}/${total_page} 페이지)</span>
								</div>	
								<div class="col-md-6 align-self-center text-end">
									<button type="button" class="btn-send me-4 mb-3" onclick="location.href='${pageContext.request.contextPath}/bbs/write?region=${region_code}';">동네글등록</button>
								</div>
							</div>
							
							
							<div class="board-list-container">
								<c:forEach var="dto" items="${list}" varStatus="status">
									<a href="${articleUrl}&num=${dto.num}" class="card board-item mb-3 text-decoration-none text-dark">
										<div class="card-body">
											<h5 class="card-title font-weight-bold">
												${dto.subject}
											</h5>
											<p class="card-subtitle text-muted small">
												<span>${dto.nickname}</span>
												<span class="mx-1">·</span>
												<span>${dto.reg_date}</span>
											</p>
											<p class="card-text text-muted small">
												<i class="bi bi-heart-fill mr-1"></i>
												<span>${dto.communityLikeCount}</span>
												<i class="bi bi-chat-dots-fill mr-1"></i>
												<span>${dto.replyCount}</span>
												<i class="bi bi-eye mr-1"></i>
												<span>${dto.hit_count}</span>
											</p>
							            </div>
							        </a>
							    </c:forEach>
							</div>
							
							<!-- Paging -->
							<div class="page-navigation">
								${dataCount == 0 ? "등록된 게시글이 없습니다" : paging}
							</div>
							
						
						</div>
					</div>
				</div>
			</div>
		</main>

	</div>
</div>

<script type="text/javascript">
window.addEventListener('DOMContentLoaded', () => {
	const inputEL = document.querySelector('form input[name=kwd]');
	inputEL.addEventListener('keydown', function(evt) {
		if(evt.key === 'Enter') {
			evt.preventDefault();
			searchList();
		}
	});
});

function searchList() {
	const f = document.bbssearchForm;
	if(! f.kwd.value.trim()) {
		return;
	}
	
	const formData = new FormData(f);
	let params = new URLSearchParams(formData).toString();
	
	let url = '${pageContext.request.contextPath}/bbs/list';
	location.href = url + '?' + params;
}
</script>

<footer>

</footer>

</body>
</html>