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
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

	<div class="right-panel">
		<div class="page-title" data-aos="fade-up" data-aos-delay="200">
			<h2>공지사항</h2>
		</div>

		<div class="section p-5" data-aos="fade-up" data-aos-delay="200">
			<div class="section-body p-5">
				<div class="row gy-4 m-0">
					<div class="col-lg-12 board-section p-5 m-2" data-aos="fade-up" data-aos-delay="200">
						
						<div class="pb-2">
							<span class="small-title">상세정보</span>
						</div>
										
						<table class="table board-article">
							<thead>
								<tr>
									<td colspan="2" class="text-center">
										${dto.subject}
									</td>
								</tr>
							</thead>
	
							<tbody>
								<tr>
									<td width="50%">
										작성자 : 관리자
									</td>
									<td width="50%" class="text-end">
										작성일 : ${dto.reg_date}
									</td>
								</tr>
								
									<tr>
										<td width="50%">
											수정자 : 관리자
										</td>
										<td width="50%" class="text-end">
											수정일 : ${dto.modify_date}
										</td>
									</tr>

								<tr>
									<td width="50%">
										조회수 : ${dto.hit_count}
									</td>
									<td width="50%" class="text-end">
										출 력 : ${dto.showNotice == 1 ? "표시" : "숨김" }
									</td>
								</tr>
								
								<tr>
									<td colspan="2" valign="top" height="200" class="article-content" style="border-bottom:none;">
										${dto.content}
									</td>
								</tr>
	
								<tr>
									<td colspan="2">
										<c:if test="${listFile.size() != 0}">
											<p class="border text-secondary mb-1 p-2">
												<i class="bi bi-folder2-open"></i>
												<c:forEach var="vo" items="${listFile}" varStatus="status">
													<a href="${pageContext.request.contextPath}/admin/noticeManage/download/${vo.fileNum}">
														${vo.original_filename}
														(<fmt:formatNumber value="${vo.filesize}" type="number"/>byte)
													</a>
													<c:if test="${not status.last}">|</c:if>
												</c:forEach>
											</p>
											<p class="border text-secondary mb-1 p-2">
												<i class="bi bi-folder2-open"></i>
												<a href="${pageContext.request.contextPath}/admin/noticeManage/zipdownload/${dto.num}">파일 전체 압축 다운로드(zip)</a>
											</p>
										</c:if>
									</td>
								</tr>
	
								<tr>
									<td colspan="2">
										이전글 : 
										<c:if test="${not empty prevDto}">
											<a href="${pageContext.request.contextPath}/admin/noticeManage/article/${prevDto.num}?${query}">${prevDto.subject}</a>
										</c:if>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										다음글 : 
										<c:if test="${not empty nextDto}">
											<a href="${pageContext.request.contextPath}/admin/noticeManage/article/${nextDto.num}?${query}">${nextDto.subject}</a>
										</c:if>
									</td>
								</tr>
							</tbody>
						</table>
	
						<div class="row mb-2">
							<div class="col-md-6 align-self-center">
				    			<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/noticeManage/update?num=${dto.num}&page=${page}';">수정</button>
								<button type="button" class="btn-default" onclick="deleteOk();">삭제</button>
							</div>
							<div class="col-md-6 align-self-center text-end">
								<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/noticeManage/list?${query}';">리스트</button>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</main>
	
<script type="text/javascript">
	function deleteOk() {
		let params = 'num=${dto.num}&${query}';
		let url = '${pageContext.request.contextPath}/admin/noticeManage/delete?' + params;
	
		if(confirm('위 자료를 삭제 하시 겠습니까 ? ')) {
			location.href = url;
		}
	}
</script>

<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>