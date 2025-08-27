<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>서울한바퀴</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

	<div class="right-panel">
		<div class="page-title  pb-0 mb-0" data-aos="fade-up" data-aos-delay="200">
			<h2 class="fs-2">공지사항</h2>
		</div>

		<div class="section p-5" data-aos="fade-up" data-aos-delay="200">
			<div class="section-body p-5">
				<div class="row gy-4 m-0">
					<div class="col-lg-12 board-section p-5 m-2" data-aos="fade-up" data-aos-delay="200">
						
						<div class="row mb-2">
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
									<th class="file">첨부</th>
									<th width="50">표시</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="dto" items="${noticeList}">
									<tr> 
										<td><span class="notice-text">공지</span></td>
										<td class="left">
											<c:url var="url" value="/admin/noticeManage/article/${dto.num}">
												<c:param name="page" value="${page}"/>
												<c:if test="${not empty kwd}">
													<c:param name="schType" value="${schType}"/>
													<c:param name="kwd" value="${kwd}"/>
												</c:if>									
											</c:url>									
											<div class="text-wrap"><a href="${url}">${dto.subject}</a></div>
										</td>
										<td>관리자</td>
										<td>${dto.reg_date}</td>
										<td>${dto.hit_count}</td>
										<td>
											<c:if test="${dto.fileCount != 0}">
												<a href="${pageContext.request.contextPath}/admin/noticeManage/zipdownload/${dto.num}" class="text-reset"><i class="bi bi-file-arrow-down"></i></a>
											</c:if>		      
										</td>
										<td>&nbsp;</td>
									</tr>
								</c:forEach>
	
								<c:forEach var="dto" items="${list}" varStatus="status">
									<tr> 
										<td>${dataCount - (page-1) * size - status.index}</td>
										<td class="left">
											<c:url var="url" value="/admin/noticeManage/article/${dto.num}">
												<c:param name="page" value="${page}"/>
												<c:if test="${not empty kwd}">
													<c:param name="schType" value="${schType}"/>
													<c:param name="kwd" value="${kwd}"/>
												</c:if>									
											</c:url>									
											<div class="text-wrap"><a href="${url}">${dto.subject}</a></div>
											<c:if test="${dto.gap < 10}">
												<span class="new-text">N</span>
											</c:if>
										</td>
										<td>관리자</td>
										<td>${dto.reg_date}</td>
										<td>${dto.hit_count}</td>
										<td>
											<c:if test="${dto.fileCount != 0}">
												<a href="${pageContext.request.contextPath}/admin/noticeManage/zipdownload/${dto.num}" class="text-reset"><i class="bi bi-file-arrow-down"></i></a>
											</c:if>		      
										</td>
										<td>${dto.showNotice == 1 ? "표시" : "숨김" }</td>
									</tr>
								</c:forEach>
							</tbody>					
						</table>
					
						<div class="page-navigation">
							${dataCount == 0 ? "등록된 게시물이 없습니다." : paging}
						</div>
	
						<div class="row mt-3">
							<div class="col-md-3">
								<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/noticeManage/list';" title="새로고침"><i class="bi bi-arrow-clockwise"></i></button>
							</div>
							<div class="col-md-6 text-center">
								<form name="searchForm" class="form-search">
									<select name="schType">
										<option value="all" ${schType=="all"?"selected":""}>제목+내용</option>
										<option value="reg_date" ${schType=="reg_date"?"selected":""}>작성일</option>
										<option value="subject" ${schType=="subject"?"selected":""}>제목</option>
										<option value="content" ${schType=="content"?"selected":""}>내용</option>
									</select>
									<input type="text" name="kwd" value="${kwd}">
									<button type="button" class="btn-default" onclick="searchList();"><i class="bi bi-search"></i></button>
								</form>
							</div>
							<div class="col-md-3 text-end">
								<button type="button" class="btn-accent btn-md" onclick="location.href='${pageContext.request.contextPath}/admin/noticeManage/write';">글쓰기</button>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</main>

<script type="text/javascript">
// 검색 키워드 입력란에서 엔터를 누른 경우 서버 전송 막기 
window.addEventListener('DOMContentLoaded', () => {
	const inputEL = document.querySelector('form input[name=kwd]'); 
	inputEL.addEventListener('keydown', function (evt) {
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
	
	// form 요소는 FormData를 이용하여 URLSearchParams 으로 변환
	const formData = new FormData(f);
	let params = new URLSearchParams(formData).toString();
	
	let url = '${pageContext.request.contextPath}/admin/noticeManage/list';
	location.href = url + '?' + params;
}
</script>

<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>