<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Spring</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">

<!-- Quill Rich Text Editor -->
<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet">
<!-- Quill Editor Image Resize CSS -->
<link href="https://cdn.jsdelivr.net/npm/quill-resize-module@2.0.4/dist/resize.css" rel="stylesheet">

</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

	<div class="right-panel">
		<div class="page-title" data-aos="fade-up" data-aos-delay="200">
			<h2>공지사항</h2>
		</div>

		<div class="section p-5" data-aos="fade-up" data-aos-delay="200">
			<div class="section-body p-5">
				<div class="row gy-4 m-0">
					<div class="col-lg-12 board-section p-5 m-2" data-aos="fade-up" data-aos-delay="200">
						
						<div class="pb-2">
							<span class="small-title">${mode=='update'?'공지사항 수정':'공지사항 등록'}</span>
						</div>
					
						<form name="noticeForm" action="" method="post" enctype="multipart/form-data">
							<table class="table write-form">
								<tr>
									<td class="col-md-2 bg-light">제 목</td>
									<td>
										<input type="text" name="subject" class="form-control" maxlength="100" placeholder="Subject" value="${dto.subject}">
									</td>
								</tr>
	
								<tr>
									<td class="col-md-2 bg-light">공지여부</td>
									<td>
										<input type="checkbox" class="form-check-input" name="notice" id="notice" value="1" ${dto.notice==1 ? "checked":"" }>
										<label for="notice" class="form-check-label">공지</label>
									</td>
								</tr>
	
								<tr>
									<td class="col-md-2 bg-light">출력여부</td>
									<td>
										<input type="checkbox" class="form-check-input" name="showNotice" id="showNotice" value="1" ${mode=="write" || dto.showNotice==1 ? "checked":"" }>
										<label for="showNotice" class="form-check-label">표시</label>
									</td>
								</tr>
					
								<tr>
									<td class="col-md-2 bg-light">이 름</td>
									<td>
										<div class="row">
											<div class="col-md-6">
												<input type="text" name="name" class="form-control" readonly tabindex="-1" value="${sessionScope.member.name}">
											</div>
										</div>
									</td>
								</tr>
							
								<tr>
									<td class="col-md-2 bg-light">내 용</td>
									<td>
										<div id="editor">${dto.content}</div>
										<div class="pt-2 text-end"><button class="btn-default btn-sm" type="button" onclick="htmlViewerOpen();">소스보기</button></div>
										<input type="hidden" name="content">
									</td>
								</tr>
								
								<tr>
									<td class="col-md-2 bg-light">파일</td>
									<td>
										<input type="file" class="form-control" name="selectFile" multiple>
									</td>
								</tr>
								
								<c:if test="${mode=='update'}">
									<tr> 
										<td class="col-md-2 bg-light">첨부된파일</td>
										<td>
											<p class="form-control-plaintext">
												<c:forEach var="vo" items="${listFile}" varStatus="status">
													<span>
														<label class="delete-file" data-fileNum="${vo.fileNum}"><i class="bi bi-trash"></i></label> 
														${vo.originalFilename}&nbsp;|
													</span>
												</c:forEach>
												&nbsp;
											</p>
										</td>
									  </tr>
								</c:if>
							</table>
							
							<div class="text-center">
								<button type="button" class="btn-accent btn-md" onclick="sendOk();">${mode=='update'?'수정완료':'등록완료'}</button>
								<button type="reset" class="btn-default btn-md">다시입력</button>
								<button type="button" class="btn-default btn-md" onclick="location.href='${pageContext.request.contextPath}/admin/noticeManage/list';">${mode=='update'?'수정취소':'등록취소'}</button>
								<c:if test="${mode=='update'}">
									<input type="hidden" name="num" value="${dto.num}">
									<input type="hidden" name="page" value="${page}">
								</c:if>
							</div>
						</form>

					</div>
				</div>
			</div>
		</div>
	</div>
</main>

<div class="modal fade" id="myDialogModal" tabindex="-1" aria-labelledby="myDialogModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="myDialogModalLabel">HTML 소스보기</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
        			<div>
        				<textarea id="html-content" class="form-control"></textarea>
        			</div>
        			<div class="text-center pt-2">
        				<button type="button" class="btn-accent" onclick="htmlViewerUpdate();">변경</button>
        				<button type="button" class="btn-default" onclick="htmlViewerClose();">닫기</button>
        			</div>
			</div>
		</div>
	</div>
</div>

<!-- Quill Rich Text Editor -->
<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
<!-- Quill Editor Image Resize JS -->
<script src="https://cdn.jsdelivr.net/npm/quill-resize-module@2.0.4/dist/resize.js"></script>
<!-- Quill Editor 적용 JS -->
<script src="${pageContext.request.contextPath}/dist/js/qeditor2.js"></script>

<script type="text/javascript">
function hasContent(htmlContent) {
	htmlContent = htmlContent.replace(/<p[^>]*>/gi, ''); // p 태그 제거
	htmlContent = htmlContent.replace(/<\/p>/gi, '');
	htmlContent = htmlContent.replace(/<br\s*\/?>/gi, ''); // br 태그 제거
	htmlContent = htmlContent.replace(/&nbsp;/g, ' ');
	htmlContent = htmlContent.replace(/\s/g, ''); // 공백 제거
	
	return htmlContent.length > 0;
}

function sendOk() {
	const f = document.noticeForm;
	let str;
	
	str = f.subject.value.trim();
	if( ! str ) {
		alert('제목을 입력하세요. ');
		f.subject.focus();
		return;
	}

	let htmlContent = quill.root.innerHTML;
	if(! hasContent(htmlContent)) {
		alert('내용을 입력하세요. ');
		quill.focus();
		return;
	}
	f.content.value = htmlContent;
	
	f.action = '${pageContext.request.contextPath}/admin/noticeManage/${mode}';
	f.submit();
}

function htmlViewerOpen() {
	$('#html-content').val(quill.root.innerHTML)
	$('#myDialogModal').modal('show');
}

function htmlViewerUpdate() {
	quill.root.innerHTML = $('#html-content').val();
	$('#myDialogModal').modal('hide');
}

function htmlViewerClose() {
	$('#myDialogModal').modal('hide');
}
</script>

<c:if test="${mode=='update'}">
	<script type="text/javascript">
		$('.delete-file').click(function(){
			if(! confirm('선택한 파일을 삭제 하시겠습니까 ? ')) {
				return false;
			}
			
			let $span = $(this).closest('span');
			let fileNum = $(this).attr('data-fileNum');
			let url = '${pageContext.request.contextPath}/admin/noticeManage/deleteFile';
			
			$.ajaxSetup({ beforeSend: function(e) { e.setRequestHeader('AJAX', true); } });
			$.post(url, {fileNum:fileNum}, function(data){
				$span.remove();
			}, 'json').fail(function(xhr){
				console.log(xhr.responseText);
			});
		});
	</script>
</c:if>

<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>