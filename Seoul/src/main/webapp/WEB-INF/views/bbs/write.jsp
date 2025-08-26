<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>서울 한바퀴</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">

<!-- Quill Rich Text Editor -->
<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet">
<!-- Quill Editor Image Resize CSS -->
<link href="https://cdn.jsdelivr.net/npm/quill-resize-module@2.0.4/dist/resize.css" rel="stylesheet">
</head>

<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>
	<!-- Page Title -->
	<div class="page-title">
		<div class="container align-items-center">
			<h1>${region_name} 한바퀴</h1>
			<div class="page-title-underline-accent"></div>
		</div>
	</div>

	<!-- Page Content -->    
	<div class="section">
		<div class="container">
			<div class="row justify-content-center">
				<div class="col-md-10 board-section my-4 p-5">

					<div class="pb-2">
						<span class="small-title">${mode=='update' ? '게시글 수정' : '게시글 등록'}</span>
					</div>

					<form name="boardForm" action="" method="post" enctype="multipart/form-data">
						<table class="table write-form">
							<tr>
								<td class="col-md-2 bg-light">제 목</td>
								<td>
									<input type="text" name="subject" class="form-control" maxlength="100" placeholder="Subject" value="${dto.subject}">
								</td>
							</tr>

							<tr>
								<td class="col-md-2 bg-light">이 름</td>
								<td>
									<div class="row">
										<div class="col-md-6">
											<input type="text" name="nickname" class="form-control" readonly tabindex="-1" value="${sessionScope.member.nickname}">
										</div>
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
							
							<tr>
								<td class="col-md-2 bg-light">파 일</td>
								<td>
									<input type="file" class="form-control" name="selectFile">
								</td>
							</tr>
							
							<c:if test="${mode=='update'}">
								<tr>
									<td class="col-md-2 bg-light">첨부된파일</td>
									<td> 
										<p class="form-control-plaintext">
											<c:if test="${not empty dto.saveFilename}">
												<a href="javascript:deleteFile('${dto.num}');"><i class="bi bi-trash"></i></a>
												${dto.originalFilename}
											</c:if>
											&nbsp;
										</p>
									</td>
								</tr>
							</c:if>
						</table>
						
						<div class="text-center">
							<button type="button" class="btn-accent btn-md" onclick="sendOk();">${mode=='update'?'수정완료':'등록완료'}</button>
							<button type="reset" class="btn-default btn-md">다시입력</button>
							<button type="button" class="btn-default btn-md" onclick="location.href='${pageContext.request.contextPath}/bbs/list?region=${region_code}';">${mode=='update'?'수정취소':'등록취소'}</button>
							<input type="hidden" name="region_id" value="${region_code}">
							<c:if test="${mode=='update'}">
								<input type="hidden" name="num" value="${dto.num}">
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

</main>

<!-- Quill Rich Text Editor -->
<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
<!-- Quill Editor Image Resize JS -->
<script src="https://cdn.jsdelivr.net/npm/quill-resize-module@2.0.4/dist/resize.js"></script>
<!-- Quill Editor 적용 JS -->
<script src="${pageContext.request.contextPath}/dist/js/qeditor.js"></script>

<script type="text/javascript">
function hasContent(htmlContent) {
	htmlContent = htmlContent.replace(/<p[^>]*>/gi, '');
	htmlContent = htmlContent.replace(/<\/p>/gi, '');
	htmlContent = htmlContent.replace(/<br\s*\/?>/gi, '');
	htmlContent = htmlContent.replace(/&nbsp;/g, ' ');
	htmlContent = htmlContent.replace(/\s/g, '');
	
	return htmlContent.length > 0;
}

function checkFileSize(fileInput) {
	const maxSize = 2 * 1024 * 1024;
	
	if (!fileInput.files || fileInput.files.length === 0) return true;
	
	file = fileInput.files[0];
	if(file.size > maxSize) {
		return false;
	}
	
	return true;
}

function sendOk() {
	const f = document.boardForm;
	let subject;
	
	subject = f.subject.value.trim();
	if(! subject) {
		alert('제목을 입력하세요.');
		f.subject.focus();
		return;
	}
	
	if(! checkFileSize(f.selectFile)) {
		alert('최대 용량은 2MB 입니다.');
		
		f.selectFile.value = "";
		f.selectFile.focus();
		
		return;
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
	
	f.action = '${pageContext.request.contextPath}/bbs/${mode}?region=${region_code}';
	f.submit();
}
</script>

<c:if test="${mode=='update'}">
	<script type="text/javascript">
		function deleteFile(num) {
			if(! confirm('파일을 삭제하시겠습니까 ? ')) {
				return false;
			}
			
			let url = '${pageContext.request.contextPath}/bbs/deleteFile?region=${region_code}&num=' + num + '&page=${page}';
			location.href = url;
		}
	</script>
</c:if>

</body>
</html>