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

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/eventManageWrite.css" type="text/css">

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

	<div class="right-panel">
		<div class="page-title pb-0 ms-3 mb-0" data-aos="fade-up" data-aos-delay="200">
			<h2 class="fs-2">이벤트</h2>
		</div>

		<div class="section p-4" data-aos="fade-up" data-aos-delay="200">
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
								<button class="nav-link" id="tab-upcoming" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="upcoming" aria-selected="true" data-tab="upcoming">진행 예정 이벤트</button>
							</li>
							<li class="nav-item" role="presentation">
								<button class="nav-link" id="tab-ended" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="ended" aria-selected="true" data-tab="ended">종료 이벤트</button>
							</li>
							<li class="nav-item" role="presentation">
								<button class="nav-link" id="tab-winner" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="winner" aria-selected="true" data-tab="winner">당첨자 추첨하기</button>
							</li>
						</ul>

						<div class="tab-content p-3 pt-4" id="nav-tabContent">
							<div class="pb-2">
								<span class="small-title">상세정보</span>
							</div>
												
							<table class="table table-bordered board-article">
								<thead>
									<tr>
										<th colspan="4" class="text-center">
											${dto.title}
										</th>
									</tr>
								</thead>
		
								<tbody>
									<tr>
										<th style="width: 14%">작성자</th>
										<td style="width: 46%">
											${dto.nickname}(${dto.login_id})
										</td>
										<th style="width: 14%">작성일</th>
										<td style="width: 26%">
											${dto.reg_date}
										</td>
									</tr>
									
									<c:if test="${not empty dto.update_id}">
										<tr>
											<th>수정자</th>
											<td>${dto.update_nickname}(${dto.login_update})</td>
											<th>수정일</th>
											<td>${dto.update_date}</td>
										</tr>
									</c:if>
									
									<tr>
										<th>이벤트 기간</th>
										<td>${dto.startDate} ~ ${dto.endDate}</td>
										<th>이벤트 타입</th>
										<td>${dto.event_type == 'NOTICE' ? '알림' : '응모'}</td>
									</tr>
									
									<c:if test="${dto.winner_number != 0 && dto.event_type == 'ENTRY'}">
										<tr>
											<th>발표일자</th>
											<td>${dto.winningDate}</td>
											<c:choose>
												<c:when test="${category == 'winner' || category == 'ended'}">
													<th>당첨할 인원 / 당첨 인원</th>
													<td>${dto.winner_number}명 / ${listEventWinner.size()}명</td>
												</c:when>
												<c:otherwise>
													<th>당첨할 인원 / 응모한 인원 </th>
													<td>${dto.winner_number}명 / ${dto.winner_number == 0 ? "-" : listEventTakers.size()}명</td>
												</c:otherwise>
											</c:choose>
										</tr>
									</c:if>

									<tr>
										<th>조회수</th>
										<td>${dto.hit_count}</td>
										<th>출력여부</th>
										<td>${dto.show_event == 1 ? "표시" : "숨김" }</td>
									</tr>
									
									<tr>
										<th style="width: 14%">
											<span style="vertical-align: top;">썸네일</span>
										</th>
										<td colspan="3" style="width: 86%">
											<img alt="업로드된 이미지" src="${pageContext.request.contextPath}/uploads/eventManage/${dto.saveFilename}" style="width: 250px; height: 180px; object-fit: fill;">
										</td>
									</tr>
									
									<tr>
										<th>내용</th>
										<td colspan="3" valign="top" height="200" class="article-content" style="border-bottom:none;">
											<div class="article-content-flex">
												<div>${dto.content}</div>
												<div class="article-content-buttons">
													<c:if test="${dto.event_type == 'ENTRY' && listEventWinner.size() == 0 && (category == 'winner' || category == 'ended') && listEventTakers.size() != 0}">
														<button type="button" class="btn-default btnEventWinnerInsert">응모이벤트 당첨자 추첨</button>		
													</c:if>
													<c:if test="${dto.event_type == 'ENTRY' && listEventWinner.size() != 0 && (category == 'winner' || category == 'ended') && listEventTakers.size() != 0 }">
														<button type="button" class="btn-default btnEventWinnerList">응모이벤트 당첨자 확인</button>		
													</c:if>
													<c:if test="${dto.event_type == 'ENTRY' && (category == 'winner' || category == 'ended') && listEventTakers.size() == 0}">
														<div style="color: red;">이벤트 응모자가 0명이라서 당첨자가 존재하지 않습니다.</div>
													</c:if>
												</div>
											</div>
										</td>
									</tr>
								
									<tr>
										<th>다음글</th>
										<td colspan="3">
											<c:if test="${not empty nextDto}">
												<a href="${pageContext.request.contextPath}/admin/eventManage/${category}/article?${query}&num=${nextDto.event_num}">${nextDto.title}</a>
											</c:if>
										</td>
									</tr>
									
									<tr>
										<th>이전글</th>
										<td colspan="3">
											<c:if test="${not empty prevDto}">
												<a href="${pageContext.request.contextPath}/admin/eventManage/${category}/article?${query}&num=${prevDto.event_num}">${prevDto.title}</a>
											</c:if>
										</td>
									</tr>
								</tbody>
							</table>
						
							<div class="row mb-2">
								<div class="col-md-6 align-self-center">
					    			<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/eventManage/${category}/update?num=${dto.event_num}&page=${page}';">수정</button>
		
							    	<c:choose>
							    		<c:when test="${listEventTakers.size() != 0}">
					    					<button type="button" class="btn-default" disabled>삭제</button>
							    		</c:when>
							    		<c:otherwise>
					    					<button type="button" class="btn-default" onclick="deleteOk();">삭제</button>
							    		</c:otherwise>
							    	</c:choose>
								</div>
								<div class="col-md-6 align-self-center text-end">
									<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/eventManage/${category}/list?${query}';">리스트</button>
								</div>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</main>

<!-- 이벤트 당첨자 추첨 대화상자 -->
<c:if test="${dto.event_type == 'ENTRY' && listEventWinner.size() == 0 && (category == 'winner' || category == 'ended') && listEventTakers.size() != 0}">
	<div class="modal fade" id="myWinnerInsertDialogModal" tabindex="-1" aria-labelledby="myWinnerInsertDialogModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="myWinnerInsertDialogModalLabel">이벤트 당첨자 발표</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
	        
					<form name="winnerForm" method="post">
						<table class="table mt-5 write-form">
							<tbody>
								<tr>
									<td class="col-md-3 bg-light">당첨할 인원</td>
									<td>${dto.winner_number}</td>
								</tr>
								<tr>
									<td class="col-md-3 bg-light">당첨 방식</td>
									<td>
										<input type="radio" class="form-check-input" name="winEvent" id="winEvent1" value="1">
										<label class="form-check-label pe-2" for="winEvent1">순위 없음</label>
										
										<input type="radio" class="form-check-input" name="winEvent" id="winEvent2" value="2">
										<label class="form-check-label" for="winEvent2">순위별 당첨</label>
									</td>
								</tr>
							</tbody>
						</table>
						
						<div class="text-center">
							<input type="hidden" name="event_num" value="${dto.event_num}">
							<input type="hidden" name="winner_number" value="${dto.winner_number}">
							<input type="hidden" name="page" value="${page}">
							<button type="button" class="btn-accent btnSendWinner">당첨자 추첨하기</button>
						</div>
					</form>
	        
				</div>
			</div>
		</div>
	</div>
</c:if>

<!-- 이벤트 당첨자 리스트 대화상자 -->
<c:if test="${dto.event_type == 'ENTRY' && listEventWinner.size() != 0}">
	<div class="modal fade" id="myWinnerListDialogModal" tabindex="-1" aria-labelledby="myWinnerListDialogModalLabel" aria-hidden="true">
		<div class="modal-dialog" style="max-width: 600px;">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="myWinnerListDialogModalLabel">이벤트 당첨자 리스트</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">

					<div class="winnerList-container">
						<c:forEach var="vo" items="${listEventWinner}" varStatus="status">
							<div class="item">
								<c:if test="${vo.rank != 0}">
									<span>
										${vo.rank}등 :
									</span>
								</c:if>
								<span style="font-weight: 500;">
									${vo.nickname}(${empty vo.login_id ? '비회원' : vo.login_id})
								</span>
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
		let url = '${pageContext.request.contextPath}/admin/eventManage/' + tab + '/list';
		location.href = url;
    });	
});

function deleteOk() {
	let params = 'num=${dto.event_num}&${query}';
	let url = '${pageContext.request.contextPath}/admin/eventManage/${category}/delete?' + params;
	
	if(confirm('해당 이벤트를 삭제하시겠습니까 ? ')) {
		location.href = url;
	}
}

$(function(){
	// 응모 이벤트 당첨자 추첨
	$('.btnEventWinnerInsert').click(function(){
		$('#myWinnerInsertDialogModal').modal('show');
	});
	
	$('form input[name=winEvent]').click(function(){
		const $tb = $(this).closest('tbody');
		let winEvent = $(this).val();
		
		if(winEvent === '1') { // 순위 없음
			$('form .rank-numbers').remove();
		} else { // 순위별 당첨
			if($('form[name=winnerForm] .rank-numbers').length >= 1) {
				return false;
			}
			
			let out = `
				<tr class="rank-numbers">
					<td class="bg-light col-sm-3">순위별인원</td>
					<td>
						<div class="row row-rank mb-1">
							<div class="col-auto p-1 pe-0"><span class="span-rank align-middle">1등 : </span></div>
							<div class="col-auto ps-0">
								<input type="hidden" name="rankNum" value="1">
								<input type="text" name="rankCount" class="form-control" style="width:100px;">
							</div>
							<div class="col-auto p-2 ps-0">
								<i class="bi bi-plus-square rank-plus"></i>&nbsp;
								<i class="bi bi-dash-square rank-minus"></i>
							</div>
						</div>
					</td>
				</tr>`;
			
			$tb.append(out);
		}
	});
	
	$('#myWinnerInsertDialogModal').on('click', '.rank-plus', function(){
		let $td = $(this).closest('td');
		let $div = $(this).closest('.row-rank');
		$div.clone(true).appendTo($td);
		$('.rank-numbers .row-rank').last().find('input[name=rankCount]').val('');
		
		rankCalc();
	});
	
	$('#myWinnerInsertDialogModal').on('click', '.rank-minus', function(){
		let $minus = $(this);
		let $td = $(this).closest('td');
		
		if($td.find('.row-rank').length === 1) {
			return false;
		}
		
		$minus.closest('.row-rank').remove();
		
		rankCalc();
	});

	function rankCalc() {
		let rank = 0;

		$('.rank-numbers .row-rank').each(function(){
			let $span = $(this).find('span');
			let $rankEL = $(this).find('input[name=rankNum]');
			
			rank++;
			$span.text(rank + '등 : ');
			$rankEL.val(rank);
		});
	}
	
	// 당첨자 추첨하기 버튼
	$('.btnSendWinner').click(function(){
		const f = document.winnerForm;
		
		let winEvent = $('form input[name=winEvent]:checked').val();
		if(winEvent === '2') { // 순위 있음
			let winnerNumber = ${dto.winner_number};
			let tot = 0;
			
			$('form input[name=rankCount]').each(function(){
				if(! /^[0-9]+$/.test($(this).val()) || parseInt($(this).val()) === 0) {
					alert('당첨 인원은 1이상의 숫자만 가능합니다.');
					return false;
				}
				
				tot += parseInt($(this).val());
			});
			
			if(winnerNumber !== tot) {
				alert('당첨 인원수의 합이 일치하지 않습니다.');
				return false;
			}
		}
		
		if(! confirm('이벤트 추첨을 진행하시겠습니까 ? ')) {
			return false;
		}
		
		f.action = '${pageContext.request.contextPath}/admin/eventManage/${category}/win';
		f.submit();
	});
});

$(function(){
	// 이벤트 당첨자 리스트
	$('.btnEventWinnerList').click(function(){
		$('#myWinnerListDialogModal').modal('show');
	});
});
</script>

<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>