<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>서울 한바퀴</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/faqlist.css" type="text/css">

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

	<div class="section">
		<div class="container" data-aos="fade-up" data-aos-delay="100">
			<div class="row justify-content-center">
				<div class="col-md-10 board-section my-4 p-5">
				
				<div class="row py-1 mb-3 align-items-center">
					<div class="col-md-8">
						<div class="d-flex align-items-center flex-wrap gap-2">
							<button class="btn btn-danger" id="btnDeleteList">삭제</button>
							<span class="small-title">FAQ목록</span>
							<span class="dataCount">${dataCount}개 (${page}/${total_page} 페이지)</span>
						</div>
					</div>
				
					<div class="col-md-4 text-md-end mt-2 mt-md-0">
						<c:if test="${dataCount != 0}">
							<form name="pageSizeForm" class="d-inline-block">
								<div style="display: inline-block; min-width: 120px;">
									<select name="size" class="form-select" style="padding: 5px 10px;" onchange="changeList();">
										<option value="5" ${size==5 ? "selected":""}>5개씩 출력</option>
										<option value="10" ${size==10 ? "selected":""}>10개씩 출력</option>
										<option value="20" ${size==20 ? "selected":""}>20개씩 출력</option>
										<option value="30" ${size==30 ? "selected":""}>30개씩 출력</option>
										<option value="50" ${size==50 ? "selected":""}>50개씩 출력</option>
									</select>
								</div>
					
								<input type="hidden" name="page" value="${page}">
								<input type="hidden" name="schType" value="${schType}">
								<input type="hidden" name="kwd" value="${kwd}">
							</form>
						</c:if>
					</div>
				</div>			
				
				<form name="listForm" method="post">
					<table class="table table-hover board-list">
						<thead>
							<tr>
								<th width="5%">
                                    <input type="checkbox" id="chkAll" class="form-check-input">
                                </th>
								<th class="num">번호</th>
								<th class="subject" style="text-align: center">제목</th>
								<th class="name">작성자</th>
								<th class="date">작성일</th>
								<th class="hit">조회수</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="dto" items="${list}" varStatus="status">
								<tr>
									<td><input type="checkbox" name="faq_ids" value="${dto.faq_id}" class="row-check"></td>
									<td>${dataCount-(page-1)*size-status.index}</td>
									<td class="left">
										<div class="text-wrap">
											<a href="${articleUrl}&faq_id=${dto.faq_id}">${dto.question}</a>
										</div>
									</td>
									<td>${dto.nickname}</td>
									<td>${dto.update_date}</td>
									<td>${dto.hit_count}</td>
							
								</tr>
							</c:forEach>							
						</tbody>					
					</table>
				</form>
				
				<div class="page-navigation text-center my-4">
					${dataCount == 0 ? "등록된 FAQ가 없습니다." : paging}
				</div>
 
					<div class="row mt-3">
						<div class="col-md-3">
							<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/faqManage/list';" title="새로고침"><i class="bi bi-arrow-clockwise"></i></button>
						</div>
						<div class="col-md-6 text-center">
							<form name="searchForm" class="form-search">
								<select name="schType">
									<option value="all" ${schType=="all"?"selected":""}>제목+내용</option>
									<option value="reg_date" ${schType=="reg_date"?"selected":""}>작성일</option>
								</select>
								<input type="text" name="kwd" value="${kwd}">
								<button type="button" class="btn-default" onclick="searchList();"><i class="bi bi-search"></i></button>
								<input type="hidden" name="page" value="${page}">
							</form>
						</div>
						<div class="col-md-3 text-end">
							<button type="button" class="btn-accent btn-md" onclick="location.href='${pageContext.request.contextPath}/admin/faqManage/write';">글쓰기</button>
						</div>
					</div>
				
				</div>
			</div>
		</div>
	</div>
</main>


<script>
    const ctx = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/dist/js/faqlist.js"></script>


<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>




</body>
</html>