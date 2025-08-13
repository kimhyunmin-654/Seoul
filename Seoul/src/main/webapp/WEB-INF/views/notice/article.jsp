<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        .aspect-square { aspect-ratio: 1 / 1; }
    </style>
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>
	<!-- Page Title -->
	<div class="page-title">
		<div class="container align-items-center" data-aos="fade-up">
			<h1>공지사항</h1>
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
									작성일 : ${dto.modify_date} | 조회 ${dto.hit_count}
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
												<a href="${pageContext.request.contextPath}/notice/download/${vo.fileNum}">
													${vo.original_filename}
													(<fmt:formatNumber value="${vo.filesize}" type="number"/>byte)
												</a>
												<c:if test="${not status.last}">|</c:if>
											</c:forEach>
										</p>
										<p class="border text-secondary mb-1 p-2">
											<i class="bi bi-folder2-open"></i>
											<a href="${pageContext.request.contextPath}/notice/zipdownload/${dto.num}">파일 전체 압축 다운로드(zip)</a>
										</p>
									</c:if>
								</td>
							</tr>

							<tr>
								<td colspan="2">
									이전글 : 
									<c:if test="${not empty prevDto}">
										<a href="${pageContext.request.contextPath}/notice/article/${prevDto.num}?${query}">${prevDto.subject}</a>
									</c:if>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									다음글 : 
									<c:if test="${not empty nextDto}">
										<a href="${pageContext.request.contextPath}/notice/article/${nextDto.num}?${query}">${nextDto.subject}</a>
									</c:if>
								</td>
							</tr>
						</tbody>
					</table>

					<div class="row mb-2">
						<div class="col-md-6 align-self-center">
							&nbsp;
						</div>
						<div class="col-md-6 align-self-center text-end">
							<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/notice/list?${query}';">리스트</button>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
</main>

</body>
</html>