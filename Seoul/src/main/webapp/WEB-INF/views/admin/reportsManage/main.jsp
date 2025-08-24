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
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>
	
	<div class="right-panel">
		<div class="page-title">
			<h2>신고 관리</h2>
		</div>
		
		<div class="section p-5">
			<div class="section-body p-5">
				<div class="row gy-4 m-0">
					<div class="col-lg-12 board-section p-5 m-2">
						<ul class="nav nav-tabs" id="myTab" role="tablist">
							<li class="nav-item" role="presentation">
								<button class="nav-link active" id="tab-all" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="all" aria-selected="true" data-tab="all">신고 목록</button>
							</li>
							<li class="nav-item" role="presentation">
								<button class="nav-link" id="tab-group" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-controls="group" aria-selected="true" data-tab="group">신고 통계</button>
							</li>
						</ul>
						
						<div class="tab-content p-3 pt-4" id="nav-content">
							<div class="row mb-2">
								<div class="col-md-4 align-self-center">
									<select id="selectStatus" class="form-select">
										<option value="0" ${report_status==0 ? "selected":""}>전체</option>
										<option value="1" ${report_status==1 ? "selected":""}>접수완료</option>
										<option value="2" ${report_status==2 ? "selected":""}>처리완료</option>
										<option value="3" ${report_status==3 ? "selected":""}>기각</option>
									</select>								
								</div>	
								<div class="col-md-8 align-self-center text-end">
									&nbsp;
								</div>
							</div>
							
							<div class="reports-list"></div>

							<div class="row mt-3 reports-search">
								<div class="col-md-3">
									<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/reportsManage/main';" title="새로고침"><i class="bi bi-arrow-clockwise"></i></button>
								</div>
								<div class="col-md-6 text-center">
									<form name="searchForm" class="form-search">
										<select name="schType">
											<option value="all" ${schType=="all"?"selected":""}>신고사유</option>
											<option value="target_title" ${schType=="target_title"?"selected":""}>콘텐츠</option>
											<option value="nickname" ${schType=="nickname"?"selected":""}>신고자</option>
											<option value="report_date" ${schType=="report_date"?"selected":""}>신고접수일</option>
										</select>
										<input type="text" name="kwd" value="${kwd}">
										<input type="hidden" name="status" value="0">
										<button type="button" class="btn-default" onclick="searchList();"><i class="bi bi-search"></i></button>
									</form>
								</div>
								<div class="col-md-3 text-end">&nbsp;</div>
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
	let page = '${page}';
	listPage(page);
	
	$('button[role="tab"]').on('click', function(e) {
		const tab = $(this).attr('aria-controls');
		
		const f = document.searchForm;
		f.status.value = '0';
		f.schType.value = 'all';
		f.kwd.value = "";
		
		if(tab === 'all') {
			$('.reports-search').show();
		} else {
			$('.reports-search').hide();
		}
		
		listPage(1);
	});
	
	$('#selectStatus').change(function() {
		const status = $(this).val();
		const f = document.searchForm;
		
		f.status.value = status;
		
		listPage(1);
	});
});

function searchList() {
	listPage(1);
}

$(function() {
	const $inputEL = $('form input[name="kwd"]');
	$inputEL.on('keydown', function(evt) {
		if(evt.key === 'Enter') {
			evt.preventDefault();
			
			listPage(1);
		}
	});
});


function listPage(page) {
	const tab = $('button[role="tab"].active').attr('aria-controls');
	const f = document.searchForm;
	
	let params = 'status=' + f.status.value + '&pageNo=' + page;
	if(tab === 'all' && f.kwd.value.trim()) {
		const formData = new FormData(f);
		params += '&' + new URLSearchParams(formData).toString();
	}
	
	const url = '${pageContext.request.contextPath}/admin/reportsManage/list/' + tab;
	const fn = function(data) {
		const selector = '.reports-list';
		$(selector).html(data);
	};
	
	ajaxRequest(url, 'get', params, 'text', fn);
}

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>