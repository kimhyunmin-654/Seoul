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

<!-- Quill Rich Text Editor -->
<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet">
<!-- Quill Editor Image Resize CSS -->
<link href="https://cdn.jsdelivr.net/npm/quill-resize-module@2.0.4/dist/resize.css" rel="stylesheet">

<style type="text/css">
.thumbnail-upload-box {
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
}

#fileName {
    visibility: hidden;
}

.show-file-name {
    visibility: visible;
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
		<div class="page-title" data-aos="fade-up" data-aos-delay="200">
			<h2>이벤트</h2>
		</div>

		<div class="section p-5" data-aos="fade-up" data-aos-delay="200">
			<div class="section-body p-5">
				<div class="row gy-4 m-0">
					<div class="col-lg-12 board-section p-5 m-2" data-aos="fade-up" data-aos-delay="200">
						
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
							<div class="pb-2">
								<span class="small-title">${ mode=='update' ? '이벤트 수정' : '이벤트 등록' }</span>
							</div>
							
							<form name="eventForm" action="" method="post" enctype="multipart/form-data">
								<table class="table write-form">
									<tr>
										<td class="col-md-2 bg-light">제 목</td>
										<td>
											<input type="text" name="title" class="form-control" maxlength="100" placeholder="Title" value="${dto.title}">
										</td>
									</tr>
		
									<tr>
										<td class="col-md-2 bg-light">타 입</td>
										<td>
											<select name="event_type" class="form-control" id="event_type_select" ${mode == 'update' ? 'disabled' : '' } onclick="selectedEntryType();">
												<option value="NOTICE" <c:if test="${dto.event_type == 'NOTICE'}">selected</c:if> >알림</option>
												<option value="ENTRY" <c:if test="${dto.event_type == 'ENTRY'}">selected</c:if> >응모</option>
											</select>
											<c:if test="${mode == 'update'}">
												<input type="hidden" name="event_type" id="hidden_event_type" value="${dto.event_type}">
											</c:if>
										</td>
									</tr>
		
									<tr>
										<td class="col-md-2 bg-light">시작일자</td>
										<td>
											<div class="row">
												<div class="col-md-5 pe-2">
													<input type="date" name="sday" class="form-control" value="${dto.sday}">
												</div>
												<div class="col-md-5">
													<input type="time" name="stime" class="form-control" value="${dto.stime}">
												</div>
											</div>
										</td>
									</tr>

									<tr>
										<td class="col-md-2 bg-light">종료일자</td>
										<td>
											<div class="row">
												<div class="col-md-5 pe-2">
													<input type="date" name="eday" class="form-control" value="${dto.eday}">
												</div>
												<div class="col-md-5">
													<input type="time" name="etime" class="form-control" value="${dto.etime}">
												</div>
											</div>
										</td>
									</tr>
		
									<!-- 응모일때만 -->
									<tr class="entry-only">
										<td class="col-md-2 bg-light">당첨인원</td>
										<td>
											<div class="row">
												<div class="col-md-5">
													<input type="text" name="winner_number" class="form-control" placeholder="Number" value="${empty dto ? '0' : dto.winner_number}">
												</div>
											</div>
											<small class="form-control-plaintext help-block">당첨 인원이 0이면 당첨자가 없습니다.</small>
										</td>
									</tr>
		
									<tr class="entry-only">
										<td class="col-md-2 bg-light">발표일자</td>
										<td>
											<div class="row">
												<div class="col-md-5 pe-2">
													<input type="date" name="wday" class="form-control" value="${dto.wday}">
												</div>
												<div class="col-md-5">
													<input type="time" name="wtime" class="form-control" value="${dto.wtime}">
												</div>
											</div>
											<small class="form-control-plaintext help-block">당첨 인원이 0이면 발표일자는 저장되지 않습니다.</small>
										</td>
									</tr>
						
						
									<tr>
										<td class="col-md-2 bg-light">이 름</td>
										<td>
											<div class="row">
												<div class="col-md-5">
													<input type="text" name="nickname" class="form-control" readonly tabindex="-1" value="${sessionScope.member.nickname}">
												</div>
											</div>
										</td>
									</tr>
									
									<tr>
									    <td class="col-md-2 bg-light">썸네일</td>
									    <td>
									        <div class="thumbnail-upload-box">
									            <input type="file" name="selectFile" id="selectFile" required>
									        </div>
									    </td>
									</tr>
								
									<tr>
										<td class="col-md-2 bg-light">내 용</td>
										<td>
											<div id="editor">${dto.content}</div>
											<input type="hidden" name="content">
										</td>
									</tr>
									
									<!-- 
									<c:if test="${mode=='update'}">
										<tr>
											<td class="col-md-2 bg-light">첨부된파일</td>
											<td> 
												<p class="form-control-plaintext">
													<c:if test="${not empty dto.saveFilename}">
														<a href="javascript:deleteFile('${dto.event_num}');"><i class="bi bi-trash"></i></a>
														${dto.originalFilename}
													</c:if>
													&nbsp;
												</p>
											</td>
										</tr>
									</c:if>
									-->
									
		
									<tr>
										<td class="col-md-2 bg-light">출력여부</td>
										<td>
											<input type="checkbox"  class="form-check-input" name="show_event" id="show_event" value="1" ${mode=="write" || dto.show_event==1 ? "checked":"" }>
											<label for="show_event" class="form-check-label">표시</label>
										</td>
									</tr>
								</table>
								
								<div class="text-center">
									<button type="button" class="btn-accent btn-md" onclick="sendOk();">${mode=='update' ? '수정완료' : '등록완료'}</button>
									<button type="reset" class="btn-default btn-md">다시입력</button>
									<button type="button" class="btn-default btn-md" onclick="location.href='${pageContext.request.contextPath}/admin/eventManage/${category}/list';">${mode=='update'?'수정취소':'등록취소'}</button>
									<c:if test="${mode=='update'}">
										<input type="hidden" name="event_num" value="${dto.event_num}">
										<input type="hidden" name="saveFilename" value="${dto.saveFilename}">
										<input type="hidden" name="originalFilename" value="${dto.originalFilename}">
										<input type="hidden" name="page" value="${page}">
									</c:if>
								</div>
							</form>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
</main>

<!-- Quill Rich Text Editor -->
<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
<!-- Quill Editor Image Resize JS -->
<script src="https://cdn.jsdelivr.net/npm/quill-resize-module@2.0.4/dist/resize.js"></script>
<!-- Quill Editor 적용 JS -->
<script src="${pageContext.request.contextPath}/dist/js/qeditor.js"></script>

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

// 파일 용량
function checkFileSize(fileInput) {
	const maxSize = 2 * 1024 * 1024;
	
	if (!fileInput.files || fileInput.files.length === 0) return true;
	
	const file = fileInput.files[0];
	if(file.size > maxSize) {
		return false;
	}
	
	return true;
}

// event_type에 따라 폼 다르게 설정
function selectedEntryType() {
	let selectedType = $('#event_type_select').val();
	
	if(selectedType === 'ENTRY') {
		$('.entry-only').show();
	} else {
		$('.entry-only').hide();
	}
}

$(function() {
	selectedEntryType();
	
	$('#event_type_select').on('change', selectedEntryType);
});


function isValidDateString(dateString) {
	try {
		const date = new Date(dateString);
		const [year, month, day] = dateString.split("-").map(Number);
		
		return date instanceof Date && !isNaN(date) && date.getDate() === day;
	} catch(e) {
		return false;
	}
}

function hasContent(htmlContent) {
	htmlContent = htmlContent.replace(/<p[^>]*>/gi, '');
	htmlContent = htmlContent.replace(/<\/p>/gi, '');
	htmlContent = htmlContent.replace(/<br\s*\/?>/gi, '');
	htmlContent = htmlContent.replace(/&nbsp;/g, ' ');
	htmlContent = htmlContent.replace(/\s/g, '');
	
	return htmlContent.length > 0;
}

function sendOk() {
	const f = document.eventForm;
	let str;
	
	str = f.title.value.trim();
	if( ! str ) {
		alert('제목을 입력하세요.');
		f.title.focus();
		return;
	}

	if(! isValidDateString(f.sday.value)) {
		alert('이벤트 시작날짜를 입력하세요.');
		f.sday.focus();
		return;
	}
	
	if(! f.stime.value) {
		alert('이벤트 시작시간을 입력하세요.');
		f.stime.focus();
		return;
	}


	if(! isValidDateString(f.eday.value)) {
		alert('이벤트 종료날짜를 입력하세요.');
		f.eday.focus();
		return;
	}
	
	if(! f.etime.value) {
		alert('이벤트 종료시간을 입력하세요.');
		f.etime.focus();
		return;
	}
	
	let sd = new Date(f.sday.value + ' ' + f.stime.value);
	let ed = new Date(f.eday.value + ' ' + f.etime.value);
	
	if( sd.getTime() >= ed.getTime() ) {
		alert('이벤트 시작날짜는 종료날짜보다 이전이어야 합니다.');
		f.sday.focus();
		return;
	}

	let mode = '${mode}';
	if( mode === 'write' && new Date().getTime() > ed.getTime() ) {
		alert('이벤트 종료날짜는 현재날짜보다 이후여야 합니다.');
		f.eday.focus();
		return;
	}
	
	// 응모일 때
	if(!/^[1-9][0-9]*$/.test(f.winner_number.value) && ( f.event_type.value === 'ENTRY' || $('#hidden_event_type').val() === 'ENTRY' )) {
		alert('당첨인원은 1 이상의 정수만 가능합니다.');
		f.winner_number.focus();
		return;
	}
	
	if(f.event_type.value === 'ENTRY' || $('#hidden_event_type').val() === 'ENTRY') {
    	if(! isValidDateString(f.wday.value)) {
    		alert('이벤트 발표일자를 입력하세요.');
    		f.wday.focus();
    		return;
    	}
    	
    	if(! /^[0-2][0-9]:[0-5][0-9]$/.test(f.wtime.value)) {
    		alert('이벤트 발표시간을 입력하세요.');
    		f.wtime.focus();
    		return;
    	}
    	
		let wd = new Date(f.wday.value + ' ' + f.wtime.value);
    	if( wd.getTime() < ed.getTime() ) {
    		alert('당첨일자는 종료날짜보다 작을수 없습니다.');
    		f.wday.focus();
    		return;
    	}    		
	}
	
	const htmlViewEL = document.querySelector('textarea#html-view');
	let htmlContent = htmlViewEL ? htmlViewEL.value : quill.root.innerHTML;
	if(! hasContent(htmlContent)) {
		alert('내용을 입력하세요.');
		if(htmlViewEL) {
			htmlViewEL.focus();
		} else {
			quill.focus();
		}
		return;
	}
	f.content.value = htmlContent;
	
	if(! f.selectFile.value) {
		alert('썸네일은 필수입니다.');
		return false;
	}
	
	// 파일
	if(! checkFileSize(f.selectFile)) {
		alert('파일 최대 용량은 2MB 입니다.');
		
		f.selectFile.value = "";
		f.selectFile.focus();
		
		return false;
	}

	f.action = '${pageContext.request.contextPath}/admin/eventManage/${category}/${mode}';
	f.submit();
}
</script>

<c:if test="${mode=='update'}">
	<script type="text/javascript">
		function deleteFile(event_num) {
			if(! confirm('파일을 삭제하시겠습니까 ? ')) {
				return false;
			}
			
			let url = '${pageContext.request.contextPath}/admin/eventManage/${category}/deleteFile?eventType=${event_type}&num=' + event_num + '&page=${page}';
			location.href = url;
		}
	</script>
</c:if>

<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>