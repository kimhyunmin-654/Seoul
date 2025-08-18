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
		<div class="page-title" data-aos="fade-up" data-aos-delay="200">
			<h2>1:1 문의</h2>
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
									<th width="100">번호</th>
									<th>제목</th>
									<th width="100">작성자</th>
									<th width="100">문의일자</th>
									<th width="100">처리결과</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="dto" items="${list}">
									<tr> 
										<td>${dto.inquiry_id}</td> <!-- category 필드가 없으므로 임시로 빈 칸 처리 -->
										<td class="left">
											<div class="text-wrap"><a href="${articleUrl}&inquiry_id=${dto.inquiry_id}">${dto.title}</a></div>
										</td>
										<td>${dto.name}</td>
										<td>${dto.created_at}</td>
										<td>${empty dto.answered_at ? "답변대기" : "답변완료"}</td>
									</tr>
								</c:forEach>
							</tbody>					
						</table>
					
						<div class="page-navigation">
							${dataCount == 0 ? "등록된 게시물이 없습니다." : paging}
						</div>
	
						<div class="row mt-3">
							<div class="col-md-3">
								<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/inquiryManage/list';" title="새로고침"><i class="bi bi-arrow-clockwise"></i></button>
							</div>
							<div class="col-md-6 text-center">
								<form name="searchForm" class="form-search">
									<select name="schType">
										<option value="all" ${schType=="all"?"selected":""}>제목+내용</option>
										<option value="name" ${schType=="name"?"selected":""}>글쓴이</option>
										<option value="created_at" ${schType=="created_at"?"selected":""}>작성일</option>
									</select>
									<input type="text" name="kwd" value="${kwd}">
									<button type="button" class="btn-default" onclick="searchList();"><i class="bi bi-search"></i></button>
								</form>
							</div>
							<div class="col-md-3 text-end">
								&nbsp;
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
	
	let url = '${pageContext.request.contextPath}/admin/inquiryManage/list';
	location.href = url + '?' + params;
}
</script>

<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>
