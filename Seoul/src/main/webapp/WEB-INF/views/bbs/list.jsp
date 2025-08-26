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
</head>
<body class="bg-light">

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>
<div class="container-fluid p-4 p-md-5">
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
						<div class="col-md-10 board-section my-4 p-5">
						
							<div class="row py-1 mb-2">
								<div class="col-md-6 align-self-center">
									<span class="small-title">글목록</span> <span class="dataCount">${dataCount}개(${page}/${total_page} 페이지)</span>
								</div>	
								<div class="col-md-6 align-self-center text-end">
								</div>
							</div>
							
							<table class="table table-hover board-list">
								<thead>
									<tr>
										<th class="num">번호</th>
										<th class="subject">제목</th>
										<th class="name">글쓴이</th>
										<th class="date">작성일</th>
										<th class="hit">조회수</th>
										<th class="like">공감수</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="dto" items="${list}" varStatus="status">
										<tr>
											<td>${dataCount - (page-1) * size - status.index}</td>
											<td class="left">
												<div class="text-wrap">
													<a href="${articleUrl}&num=${dto.num}" class="text-reset">${dto.subject}</a>
												</div>
												<c:if test="${dto.replyCount!=0}">(${dto.replyCount})</c:if>
											</td>
											<td>${dto.nickname}</td>
											<td>${dto.reg_date}</td>
											<td>${dto.hit_count}</td>
											<td>${dto.communityLikeCount}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
							
							<!-- Paging -->
							<div class="page-navigation">
								${dataCount == 0 ? "등록된 게시글이 없습니다" : paging}
							</div>
							
							<!-- Search -->
							<div class="row mt-3">
								<div class="col-md-3">
									<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/bbs/list?region=${region_code}';" title="새로고침"><i class="bi bi-arrow-clockwise"></i></button>
								</div>
								<div class="col-md-6 text-center">
									<form name="searchForm" class="form-search">
										<select name="schType">
											<option value="all" ${schType=="all"?"selected":""}>제목+내용</option>
											<option value="nickname" ${schType=="nickname"?"selected":""}>글쓴이</option>
											<option value="reg_date" ${schType=="reg_date"?"selected":""}>작성일</option>
											<option value="subject" ${schType=="subject"?"selected":""}>제목</option>
											<option value="content" ${schType=="content"?"selected":""}>내용</option>
										</select>
										<input type="text" name="kwd" value="${kwd}">
										<input type="hidden" name="region" value="${region_code}">
										<button type="button" class="btn-default" onclick="searchList();"><i class="bi bi-search"></i></button>
									</form>
								</div>
								<div class="col-md-3 text-end">
									<button type="button" class="btn-accent btn-md" onclick="location.href='${pageContext.request.contextPath}/bbs/write?region=${region_code}';">동네글등록</button>
								</div>
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
	const f = document.searchForm;
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