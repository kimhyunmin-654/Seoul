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

<style type="text/css">
  .tab-pane { min-height: 300px; }
</style>

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
						<div class="pb-2">
							<span class="small-title">상세정보</span>
						</div>
					
						<table class="table board-article">
							<thead>
								<tr>
									<td colspan="2" class="text-center">
										${dto.title}
									</td>
								</tr>
							</thead>
	
							<tbody>
								<tr>
									<td colspan="2">
										이벤트 타입 : ${dto.event_type == 'NOTICE' ? '알림' : '응모'}
									</td>
								</tr>
								<tr>
									<td width="50%">
										이벤트 기간 : ${dto.startDate} ~ ${dto.endDate}
									</td>
									<td width="50%" class="text-end">
										조회수 : ${dto.hit_count}
									</td>
								</tr>
								
								<c:if test="${dto.winner_number != 0 && dto.event_type == 'ENTRY'}">
									<tr>
										<c:choose>
											<c:when test="${listEventTakers.size() == 0 && (category == 'winner' || category == 'ended')}">
												<td colspan="2">
													<div style="color: red; text-align: center;">이벤트 응모자가 0명이라서 당첨자가 존재하지 않습니다.</div>
												</td>
											</c:when>
											<c:when test="${listEventWinner.size() == 0 && (category == 'winner' || category == 'ended')}">
												<td colspan="2">
													<div style="color: red; text-align: center;">당첨이 곧 진행 예정입니다.</div>
												</td>
											</c:when>
											<c:otherwise>
												<td width="50%">
													당첨일자 : ${dto.winningDate}
												</td>
											</c:otherwise>
										</c:choose>
										<td width="50%" class="text-end">
											<c:choose>
												<c:when test="${listEventWinner.size() != 0 && (category == 'winner' || category == 'ended')}">
													당첨 인원 : ${listEventWinner.size()}명
												</c:when>
												<c:when test="${category == 'progress'}">
													당첨 인원 : ${dto.winner_number}
												</c:when>
											</c:choose>
										</td>
									</tr>
								</c:if>
								
								<c:if test="${listEventWinner.size() != 0 && category == 'winner' && not empty userWinner && dto.event_type == 'ENTRY'}">
									<tr>
										<td colspan="2" align="center">
											<p class="form-control-plaintext">
												<span>축하합니다.</span>
												<span style="color: blue; font-weight: 600;">${sessionScope.member.nickname}</span>님은
												<c:if test="${userWinner.rank != 0}">
													<span>이벤트에 <label style="color: tomato; font-weight: 500;">${userWinner.rank}</label>등으로 당첨되었습니다 </span>
												</c:if>
												<c:if test="${userWinner.rank == 0}">
													<span>이벤트에 당첨되었습니다.</span>
												</c:if>
											</p>
										</td>
									</tr>
								</c:if>
								
								<tr>
									<td colspan="2" valign="top" height="200" class="article-content" style="${dto.winner_number != 0 ? 'border-bottom: none;' : ''}">
										${dto.content}
									</td>
								</tr>
	
								<c:if test="${dto.winner_number != 0 && category == 'progress' && dto.event_type == 'ENTRY'}">
									<tr>
										<td colspan="2" class="text-center p-3">
											<button type="button" class="btn-default btnApplyEvent" ${ isUserEventTakers ? "disabled" : "" }> ${ isUserEventTakers ? "이벤트 응모 완료" : "이벤트 응모하기" } </button>
										</td>
									</tr>
								</c:if>
	
								<c:if test="${listEventWinner.size() != 0 && dto.winner_number != 0 && (category == 'winner' || category == 'ended') && dto.event_type == 'ENTRY'}">
									<tr>
										<td colspan="2" class="text-center p-3">
											<button type="button" class="btn-default btnEventWinnerList"> 응모이벤트 당첨자 확인하기 </button>
										</td>
									</tr>
								</c:if>
	
								<tr>
									<td colspan="2">
										다음글 : 
										<c:if test="${not empty nextDto}">
											<a href="${pageContext.request.contextPath}/event/${category}/article?${query}&num=${nextDto.event_num}">${nextDto.title}</a>
										</c:if>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										이전글 : 
										<c:if test="${not empty prevDto}">
											<a href="${pageContext.request.contextPath}/event/${category}/article?${query}&num=${prevDto.event_num}">${prevDto.title}</a>
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
								<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/event/${category}/list?${query}';">리스트</button>
							</div>
						</div>
					</div>				

				</div>
			</div>
		</div>
	</div>

</main>


<c:if test="${listEventWinner.size() != 0 && dto.event_type == 'ENTRY'}">
	<script type="text/javascript">
		$(function(){
			$('.btnEventWinnerList').click(function(){
				$('#eventWinnerModal').modal('show');	
			});
		});
	</script>
	
	<div class="modal fade" id="eventWinnerModal" tabindex="-1" aria-labelledby="eventWinnerModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="eventWinnerModalLabel">이벤트 당첨자 리스트</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body pt-1 text-center">
	                 <div class="row row-cols-4 g-1">
	                 	<c:forEach var="vo" items="${listEventWinner}" varStatus="status">
	                 		<div class="col">
	                 			<div class="border">
		                 			<c:if test="${vo.rank != 0}">
										<span>
											${vo.rank}등 :
										</span>
									</c:if>
									<span style="font-weight: 500;">
										${vo.nickname}
									</span>
								</div>
	                 		</div>
	                 	</c:forEach>
	                 </div>
				</div>
			</div>
		</div>
	</div>
</c:if>


<script type="text/javascript">
$(function(){
	let menu = '${category}';
	$('#tab-' + menu).addClass('active');
	
    $('button[role="tab"]').on('click', function(e){
		const tab = $(this).attr('data-tab');
		let url = '${pageContext.request.contextPath}/event/' + tab + '/list';
		location.href = url;
    });
});

$(function() {
	$('.btnApplyEvent').click(function() {
		if(! confirm('이벤트에 응모하시겠습니까 ? ')) {
			return false;
		}
		
		const $btn = $(this);
		let event_num = '${dto.event_num}';
		let params = {event_num:event_num};
		let url = '${pageContext.request.contextPath}/event/progress/apply';
		
		const fn = function(data) {
			let state = data.state;
			
			if(state === 'true') {
				$btn.prop('disabled', true);
				$btn.text('이벤트 응모 완료');
			} else if(state === 'ended') {
				alert('이벤트 응모기간이 지났습니다.');
			} else if(state === 'upcoming') {
				alert('이벤트 응모 시작 전입니다.');
			} else {
				alert('이벤트 응모는 한번만 가능합니다.');
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>