<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>서울 한바퀴</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/tabs.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/eventList.css" type="text/css">

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>

	<!-- Page Title -->
	<div class="page-title">
		<div class="container align-items-center">
			<h1>이벤트</h1>
			<div class="page-title-underline-accent"></div>
		</div>
	</div>

	<!-- Page Content -->    
	<div class="section">
		<div class="container">
			<div class="row justify-content-center">
				<div class="col-md-10 board-section my-4 p-5">
				
					<ul class="nav nav-tabs" id="myTab" role="tablist">
						<li class="nav-item" role="presentation">
							<button class="nav-link" id="tab-progress" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="progress" aria-selected="true" data-tab="progress">진행 중인 이벤트</button>
						</li>
						<li class="nav-item" role="presentation">
							<button class="nav-link" id="tab-upcoming" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="upcoming" aria-selected="true" data-tab="upcoming">진행 예정 이벤트</button>
						</li>
						<li class="nav-item" role="presentation">
							<button class="nav-link" id="tab-ended" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="ended" aria-selected="true" data-tab="ended">종료 이벤트</button>
						</li>
						<li class="nav-item" role="presentation">
							<button class="nav-link" id="tab-winner" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="winner" aria-selected="true" data-tab="winner">응모 이벤트 당첨자 발표</button>
						</li>
					</ul>

					<div class="tab-content p-3 pt-4" id="nav-content">
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
						
						<div class="event-list-container">
						    <c:if test="${empty list}">
						        <p>등록된 이벤트가 없습니다.</p>
						    </c:if>
						    <c:if test="${not empty list}">
						        <c:forEach var="dto" items="${list}" varStatus="status">
					        		<a href="${articleUrl}&num=${dto.event_num}" class="event-card">
						        		<div class="event-thumbnail">
						        			<img alt="이벤트 썸네일${status.count}" src="${pageContext.request.contextPath}/uploads/eventManage/${dto.saveFilename}">
						        		</div>
						        		<div class="event-title" data-num="${dto.event_num}">${dto.title}</div>
						        		<div class="event-dates"> ${dto.startDate} ~ ${dto.endDate}
						        		<c:if test="${dto.labelDDay != 'more'}">
											<span class="dDay-badge">${dto.labelDDay}</span>
										</c:if>
										</div>
						        	</a>
						        </c:forEach>
						    </c:if>
						</div>
					
						<div class="page-navigation">
							${paging}
						</div>
					
						<div class="row mt-2">
							<div class="col-md-2">
								<button type="button" class="btn-default" onclick="location.href='${pageConext.request.contextPath}/event/${category}/list';" title="새로고침"><i class="bi bi-arrow-clockwise"></i></button>
							</div>
						</div>
					</div>
				
				</div>
			</div>
		</div>
	</div>

</main>

<script type="text/javascript">
$(function() {
	let menu = '${category}';
	$('#tab-' + menu).addClass('active');
	
	$('button[role="tab"]').on('click', function(e) {
		const tab = $(this).attr('data-tab');
		let url = '${pageContext.request.contextPath}/event/' + tab + '/list';
		location.href = url;
	});
});

$(function() {
	$('#event_type_selected').on('change', function() {
		const f = document.eventForm;
		eType = f.event_type.value;
		
		let params = 'eventType=' + encodeURIComponent(eType);
		
		let url = '${pageContext.request.contextPath}/event/${category}/list';
		location.href = url + '?' + params;
	});
});

</script>

</body>
</html>