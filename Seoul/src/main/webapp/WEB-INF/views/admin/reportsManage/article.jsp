<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>서울 한바퀴</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/tabs.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">

<style type="text/css">
table.reports-content th {
	background-color: #f8f9fa;
	text-align: left;
	white-space: nowrap;
	font-weight: 600;
}
</style>

</head>
<body>


<header>
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

	<div class="right-panel">
		<div class="page-title pb-0 ms-3 mb-0" data-aos="fade-up" data-aos-delay="200">
			<h2 class="fs-2">신고 관리</h2>
		</div>

		<div class="section p-4" data-aos="fade-up" data-aos-delay="200">
			<div class="section-body p-5">
				<div class="row gy-4 m-0">
					<div class="col-lg-12 board-section p-5 m-2">

						<div class="card shadow-sm mb-3">
							<div class="card-header bg-light-secondary py-3">
								<strong>신고 상세 정보</strong>
							</div>
							<div class="card-body">
							
								<table class="table table-bordered reports-content">
									<tbody>
										<tr>
											<th style="width: 15%;">콘텐츠</th>
											<td style="width: 35%;">${report.target_title}</td>
											<th style="width: 15%;">처리상태</th>
											<td style="width: 35%;">
												<c:choose>
													<c:when test="${report.report_status == 1}">접수완료</c:when>
													<c:when test="${report.report_status == 2}">처리완료</c:when>
													<c:when test="${report.report_status == 3}">기각</c:when>
													<c:otherwise>미확인</c:otherwise>
												</c:choose>
											</td>
										</tr>
										<tr>
											<th>대상 글번호</th>
											<td>${report.target_num} (${report.target_table})</td>
											<th>대상 글 신고건수</th>
											<td>
												${reportsCount}
											</td>
										</tr>
										<tr>
											<th>신고자</th>
											<td>${report.reporter_name} (${report.reported_by})</td>
											<th>신고일자</th>
											<td>${report.report_date}</td>
										</tr>
										<tr>
											<th>신고유형</th>
											<td>
												${report.reason_code}
											</td>
											<th>신고자 IP</th>
											<td>${report.report_ip}</td>
										</tr>
										<tr>
											<th valign="middle">신고상세내용</th>
											<td colspan="3">
												<div class="p-2">${report.reason_detail}</div>
											</td>
										</tr>
								
										<c:if test="${not empty report.handled_by}">
											<tr>
												<th>처리담당자</th>
												<td>${report.processor_name} (${report.handled_by})</td>
												<th>처리일자</th>
												<td>${report.handled_date}</td>
											</tr>
											<tr>
												<th valign="middle">처리상세내용</th>
												<td colspan="3">
													<div class="p-2">${report.handling_note}</div>
												</td>
											</tr>
										</c:if>
									</tbody>
								</table>
								
								<div class="d-flex justify-content-between align-items-center">
									<div>
										<button type="button" class="btn-default me-2" onclick="reportProcess('one');">신고처리</button>
										<button type="button" class="btn-default" onclick="reportProcess('all');">신고 일괄처리</button>
									</div>
									
									<div>
										<button type="button" class="btn-default me-2" onclick="postsView()">글 상세내용</button>
										<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/reportsManage/main?${query}';">리스트</button>
									</div>
								</div>
																
        					</div>
        				</div>
						
						<div class="card shadow-sm">
							<div class="card-header bg-light-secondary py-3">
								<strong>동일 게시글 신고 리스트</strong>
							</div>
							
							<div class="card-body reports-list"></div>
						</div>						

					</div>
				</div>
			</div>
		</div>
	</div>
</main>

<!-- 신고 조치 -->
<div class="modal fade" id="reportHandledDialogModal" tabindex="-1" 
		data-bs-backdrop="static" data-bs-keyboard="false"
		aria-labelledby="reportHandledDialogModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="reportHandledDialogModalLabel">신고 처리</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<form name="reportsForm" method="post" class="p-3 border rounded">
				    <div class="row mb-3">
				        <div class="col-md-6">
				            <label for="report_status" class="form-label">신고 처리 상태</label>
				            <select name="report_status" id="report_status" class="form-select">
				                <option value="2">처리완료</option>
				                <option value="3">기각</option>
				            </select>
				        </div>
				        <div class="col-md-6">
				            <label for="report_action" class="form-label">조치 유형</label>
				            <select name="report_action" id="report_action" class="form-select">
				                <option value="blind">블라인드 처리</option>
				                <option value="delete">글 삭제</option>
				                <option value="none">무처리</option>
				                <option value="unlock">블라인드 해제</option>
				            </select>
				        </div>
				    </div>
				
				    <div class="mb-3">
				        <label for="handling_note" class="form-label">조치 사항</label>
				        <textarea name="handling_note" id="handling_note" class="form-control" style="height: 120px;" placeholder="조치 상세내용을 입력해주세요"></textarea>
				    </div>
				
				    <!-- hidden inputs -->
				    <input type="hidden" name="report_num" value="${report.report_num}">
				    <input type="hidden" name="target_table" value="${report.target_table}">
				    <input type="hidden" name="target_num" value="${report.target_num}">
				    <input type="hidden" name="target_type" value="${report.target_type}">
				    <input type="hidden" name="mode" value="all">
				
				    <input type="hidden" name="status" value="${report_status}">
				    <input type="hidden" name="page" value="${page}">
				    <input type="hidden" name="schType" value="${schType}">
				    <input type="hidden" name="kwd" value="${kwd}">

				    <div class="text-end">
						<button type="button" class="btn-accent" onclick="reportProcessSaved();"> 등록 </button>
						<button type="button" class="btn-default" data-bs-dismiss="modal"> 취소 </button>
				    </div>
				</form>
			</div>
		</div>
	</div>
</div>

<!-- 게시글 내용 -->
<div class="modal fade" id="postsDialogModal" tabindex="-1" aria-labelledby="postsDialogModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
        
            <div class="modal-header">
                <h5 class="modal-title" id="postsDialogModalLabel">글 내용</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            
            <div class="modal-body">
            	<c:choose>
            		<c:when test="${empty target}">
            			<p class="text-center p-3">삭제된 게시글입니다.</p>
            		</c:when>
            		<c:otherwise>
						<table class="table table-bordered reports-content">
							<tbody>
								<tr>
									<th style="width: 15%;">작성자</th>
									<td style="width: 35%;">${target.writer} (${target.writer_id})</td>
									<th style="width: 15%;">블라인드 여부</th>
									<td style="width: 35%;">${target.block == 1 ? "O" : "X"}</td>
								</tr>
								<c:if test="${not empty target.region_id}">
									<th>지역</th>
									<td style="width: 85%;" colspan="3">${region_name}</td>
								</c:if>
								<c:if test="${not empty target.subject}">
									<tr>
										<th style="width: 15%;">제목</th>
										<td style="width: 85%;" colspan="3">${target.subject}</td>
									</tr>
								</c:if>
								<c:if test="${report.target_table == 'product'}">
									<tr>
										<th>썸네일</th>
										<td style="width: 85%;" colspan="3">
											<img alt="${target.subject}" src="${pageContext.request.contextPath}/uploads/product/${target.thumbnail}">
										</td>
									</tr>
									<tr>
										<th style="width: 15%;">가격</th>
										<td style="width: 35%;">${not empty target.price ? target.price : '0'}원</td>
										<th style="width: 15%;">타입</th>
										<td style="width: 35%;">${target.type == 'NORMAL' ? '중고상품' : '경매'} (${target.status})</td>
									</tr>
								</c:if>
								<tr>
									<th style="width: 15%;">내용</th>
									<td style="width: 85%;" colspan="3">${target.content}</td>
								</tr>
								<!-- 이미지 파일 -->
							</tbody>
						</table>
            		</c:otherwise>
            	</c:choose>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-default" data-bs-dismiss="modal">닫기</button>
            </div>
            
        </div>
    </div>
</div>

<script type="text/javascript">
$(function() {
	listPage(1);
});

// 동일 게시물 신고 리스트
function listPage(page) {
	const url = '${pageContext.request.contextPath}/admin/reportsManage/listRelated';
	const params = 'report_num=${report_num}&target_num=${report.target_num}&target_table=${report.target_table}&pageNo=' + page;
	const fn = function(data) {
		$('.reports-list').html(data);
	}
	
	ajaxRequest(url, 'get', params, 'text', fn);
}

// 신고처리 대화상자
function reportProcess(mode) {
	const f = document.reportsForm;
	
	f.mode.value = mode;
	f.report_status.value = '2';
	f.report_action.value = 'blind';
	f.handling_note.value = '';
	
	if(mode === 'one') {
		$('#reportHandledDialogModalLabel').html('신고 처리');
	} else {
		$('#reportHandledDialogModalLabel').html('동일 글 일괄처리');
	}
	
	$('#reportHandledDialogModal').modal('show');
}

// 신고 처리
function reportProcessSaved() {
	const f = document.reportsForm;
	
	if(! f.handling_note.value.trim()) {
		alert('조치 상세내용 입력은 필수입니다.');
		return;
	}
	
	f.action = '${pageContext.request.contextPath}/admin/reportsManage/update';
	f.submit();
}

// 글 상세내용
function postsView() {
	$('#postsDialogModal').modal('show');
}

// 기각 -> 무처리
$(function() {
	$('#report_status').change(function() {
		let rStatus = $(this).val();
		
		if(rStatus === '3') {
			$('#report_action').val('none');
		} else {
			$('#report_action').val('blind');
		}
	});
});

</script>

<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>