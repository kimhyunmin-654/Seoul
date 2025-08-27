<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>서울 한바퀴</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/leftmypage.css" type="text/css">

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/tabs.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/eventmypageList.css" type="text/css">
</head>

<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

	<main>
	    <div class="wrap">
	        <div class="content-wrapper">
	            <jsp:include page="/WEB-INF/views/layout/leftmypage.jsp" />
	
	            <div class="content-column">
	                <div class="board-section">
	                    <h2>이벤트 참여 내역</h2>
	                    <p>회원님이 참여하신 이벤트 목록입니다.</p>
	                    
						<div class="list-info">
							<span class="list-title">글목록</span> 
							<span class="list-count">${dataCount}개(${current_page}/${total_page} 페이지)</span>
						</div>
	
	                    <div class="event-list">
	                        <c:forEach var="event" items="${eventList}" varStatus="status">
								<a href="/event/${event.category}/article?num=${event.event_num}" class="event-card">
									<div class="event-thumbnail">
										<img alt="이벤트 썸네일${status.count}" src="${pageContext.request.contextPath}/uploads/eventManage/${event.saveFilename}">
									</div>
									<div class="event-content">
										<div class="event-title">
											${event.title}
										</div>
										<div class="event-info-group">
											<span><strong>이벤트 기간</strong> ${event.startDate} ~ ${event.endDate} | </span>
											<span><strong>참여일</strong> ${event.reg_date}</span>
										</div>
									</div>
								</a>
	                        </c:forEach>
	                        <c:if test="${empty eventList}">
	                            <div class="no-event-message">
	                                참여한 이벤트가 없습니다.
	                            </div>
	                        </c:if>
	                    </div>
	                    
	                    <div class="page-navigation">
	                    	${paging}
	                    </div>
	                    
	                </div>
	            </div>
	        </div>
	    </div>
	</main>
</body>
</html>