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
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/tabs.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/eventList.css" type="text/css">
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

	<div class="right-panel">
		<div class="page-title">
			<h2>이벤트</h2>
		</div>

		<div class="section p-5">
			<div class="section-body p-5">
				<div class="row gy-4 m-0">
					<div class="col-lg-12 board-section p-5 m-2">
						
						<ul class="nav nav-tabs" id="myTab" role="tablist">
							<li class="nav-item" role="presentation">
								<button class="nav-link" id="tab-all" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="all" aria-selected="true" data-tab="all">전체 이벤트</button>
							</li>
							<li class="nav-item" role="presentation">
								<button class="nav-link" id="tab-progress" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="progress" aria-selected="true" data-tab="progress">진행 중인 이벤트</button>
							</li>
							<li class="nav-item" role="presentation">
								<button class="nav-link" id="tab-ended" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="ended" aria-selected="true" data-tab="ended">종료 이벤트</button>
							</li>
							<li class="nav-item" role="presentation">
								<button class="nav-link" id="tab-upcoming" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="upcoming" aria-selected="true" data-tab="upcoming">진행 예정 이벤트</button>
							</li>
							<li class="nav-item" role="presentation">
								<button class="nav-link" id="tab-winner" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="winner" aria-selected="true" data-tab="winner">당첨자 추첨하기</button>
							</li>
						</ul>

						<div class="tab-content p-3 pt-4" id="nav-tabContent">
							<div class="row align-items-center py-1 mb-2">
								<div class="col-md-6 align-self-center">
									<span class="small-title">글목록</span> <span class="dataCount">${dataCount}개(${page}/${total_page} 페이지)</span>
								</div>	
								<c:if test="${category != 'winner'}">
									<div class="col-md-6 align-self-center text-end">
									<form name="eventForm" id="event_type_selected" class="d-inline-flex align-items-center">
										<label for="event_type" class="me-2 mb-0">타입 :</label>
										<select name="event_type" id="event_type" class="custom-select-box">
											<option value="all" ${event_type == 'all' ? 'selected' : ''}>전체</option>
											<option value="ENTRY" ${event_type == 'ENTRY' ? 'selected' : ''}>응모</option>
											<option value="NOTICE" ${event_type == 'NOTICE' ? 'selected' : ''}>알림</option>
										</select>
									</form>
									</div>
								</c:if>
							</div>
						
							<table class="table table-hover board-list">
								<thead>
									<tr>
										<th width="60">번호</th>
										<th>제목</th>
										<th width="150">이벤트 시작일</th>
										<th width="150">이벤트 종료일</th>
										<th width="100">${category=="winner" ? "발표" : "이벤트 타입"}</th> <!-- winner:발표, 그 외: 이벤트 성격(일반, 추첨) -->
									</tr>
								</thead>
								<tbody>
									<c:forEach var="dto" items="${list}" varStatus="status">
										<tr> 
											<td>${dataCount - (page-1) * size - status.index}</td>
											<td class="left">
												<div class="text-wrap"><a href="${articleUrl}&num=${dto.event_num}">${dto.title}</a></div>
											</td>
											<td>${dto.startDate}</td>
											<td>${dto.endDate}</td>
											<td>${category=="winner" ? ( dto.applyCount == 0 ? "완료" : (dto.winnerCount == 0 ? "예정" : "완료") ) : (dto.event_type == 'NOTICE' ? '알림' : '응모') }</td>
										</tr>
									</c:forEach>
								</tbody>					
							</table>
						
							<div class="page-navigation">
								${dataCount == 0 ? "등록된 게시물이 없습니다." : paging}
							</div>
		
							<div class="row mt-3">
								<div class="col-md-6">
									<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/eventManage/${category}/list';" title="새로고침"><i class="bi bi-arrow-clockwise"></i></button>
								</div>
								<div class="col-md-6 text-end">
									<button type="button" class="btn-accent btn-md" onclick="location.href='${pageContext.request.contextPath}/admin/eventManage/${category}/write';">이벤트등록</button>
								</div>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</main>

<script type="text/javascript">
$(function(){
	let menu = '${category}';
	$('#tab-' + menu).addClass('active');
	
    $('button[role="tab"]').on('click', function(e){
		const tab = $(this).attr('data-tab');
		let url = '${pageContext.request.contextPath}/admin/eventManage/' + tab + '/list';
		location.href = url;
    });	
});

$(function() {
	$('#event_type_selected').on('change', function() {
		const f = document.eventForm;
		eType = f.event_type.value;
		
		let params = 'eventType=' + encodeURIComponent(eType);
		
		let url = '${pageContext.request.contextPath}/admin/eventManage/${category}/list';
		location.href = url + '?' + params;
	});
});
</script>

<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>