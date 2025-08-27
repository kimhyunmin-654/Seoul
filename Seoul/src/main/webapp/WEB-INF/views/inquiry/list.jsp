<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>서울한바퀴</title>
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
<style type="text/css">
  /* 전체 레이아웃 및 컨테이너 */
  body {
    background-color: #f8f9fa;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif;
  }
  
  .main-container {
    max-width: 1200px;
    margin: auto;
    padding: 3rem 1rem;
  }
  
  .board-container {
    background-color: #fff;
    border-radius: 0.5rem;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  }

  /* 페이지 헤더 */
  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem 1.5rem;
  }
  
  .page-header .title-text {
    font-size: 1rem;
    font-weight: 500;
  }
  
  .page-header .page-info {
    font-size: 0.9rem;
    color: #6c757d;
  }

  /* 테이블 */
  .table-responsive {
    overflow-x: auto;
  }
  
  .board-list {
    width: 100%;
    border-collapse: collapse;
  }
  
  .board-list thead th {
    background-color: #f1f3f5;
    border-bottom: 1px solid #dee2e6;
    padding: 0.75rem;
    font-weight: 600;
    color: #495057;
    text-align: center;
  }
  
  .board-list tbody td {
    border-bottom: 1px solid #e9ecef;
    padding: 1.25rem 0.75rem;
    vertical-align: middle;
    font-size: 0.95rem;
  }

  .board-list tbody tr:hover {
    background-color: #f8f9fa;
  }

  .board-list a {
    text-decoration: none;
    color: #333;
  }

  .board-list .badge-notice {
    background-color: #0d6efd;
    color: #fff;
    font-size: 0.75rem;
    font-weight: 500;
    padding: 0.3em 0.6em;
    border-radius: 0.25rem;
    vertical-align: middle;
    margin-right: 0.5rem;
  }

  /* 페이지네이션 */
  .page-navigation {
    text-align: center;
    padding: 1.5rem 0;
    color: #6c757d;
  }
  
  /* 검색/버튼 영역 */
  .button-search-area {
    padding: 1rem 1.5rem 1.5rem;
  }
  
  .form-search .input-group {
    width: auto;
  }
  
  .form-search select,
  .form-search input {
    border-color: #dee2e6;
  }
  
  .btn-accent {
    background-color: #495057;
    border-color: #495057;
    color: #fff;
  }
  
  .btn-accent:hover {
    background-color: #343a40;
    border-color: #343a40;
  }

  .btn-default {
    background-color: #e9ecef;
    border-color: #e9ecef;
    color: #495057;
  }
  
  .btn-default:hover {
    background-color: #dee2e6;
    border-color: #dee2e6;
  }
</style>
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="main-container">
	<div class="row justify-content-center">
		<div class="col-md-11 board-container">
		
			<div class="page-header">
				<div class="title-text">1:1문의 목록</div>
				<div class="page-info">
					${dataCount}개(${page}/${total_page} 페이지)
				</div>
			</div>
			
			<div class="table-responsive">
				<table class="board-list">
					<colgroup>
						<col style="width: 80px;">
						<col>
						<col style="width: 120px;">
						<col style="width: 120px;">
						<col style="width: 100px;">
					</colgroup>
					<thead>
						<tr>
							<th class="text-center">번호</th>
							<th class="text-center">제목</th>
							<th class="text-center">작성자</th>
							<th class="text-center">문의일자</th>
							<th class="text-center">처리결과</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="dto" items="${list}">
							<tr>
								<td class="text-center">${dto.listnum}</td>
								<td class="text-center">
									<a href="${articleUrl}&inquiry_id=${dto.inquiry_id}">${dto.title}</a>
								</td>
								<td class="text-center">${dto.name}</td>
								<td class="text-center">${dto.created_at}</td>
								<td class="text-center">
								<span class="badge ${empty dto.answered_at ? 'text-bg-secondary' : 'text-bg-success'}">
									${(empty dto.answered_at)?"답변대기":"답변완료"}
								</span>
								</td>
							</tr>
						</c:forEach>
					</tbody>					
				</table>
			</div>

			<div class="page-navigation">
				${dataCount == 0 ? "등록된 게시물이 없습니다." : paging}
			</div>

			<div class="row button-search-area">
				<div class="col-md-3">
					<button type="button" class="btn btn-default rounded-pill" onclick="location.href='${pageContext.request.contextPath}/inquiry/list';" title="새로고침"><i class="bi bi-arrow-clockwise"></i></button>
				</div>
				<div class="col-md-6 text-center">
					<form name="searchForm" class="form-search d-inline-block">
						<div class="input-group">
							<select name="schType" class="form-select">
								<option value="all" ${schType=="all"?"selected":""}>제목+내용</option>
								<option value="reg_date" ${schType=="reg_date"?"selected":""}>작성일</option>
								<option value="subject" ${schType=="subject"?"selected":""}>제목</option>
								<option value="question" ${schType=="question"?"selected":""}>내용</option>
							</select>
							<input type="text" name="kwd" value="${kwd}" class="form-control">
							<button type="button" class="btn btn-default" onclick="searchList();"><i class="bi bi-search"></i></button>
						</div>
					</form>
				</div>
				<div class="col-md-3 text-end">
					<button type="button" class="btn btn-accent rounded-pill" onclick="location.href='${pageContext.request.contextPath}/inquiry/write';">문의등록</button>
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
	
	const formData = new FormData(f);
	let params = new URLSearchParams(formData).toString();
	
	let url = '${pageContext.request.contextPath}/inquiry/list';
	location.href = url + '?' + params;
}
</script>

</body>
</html>