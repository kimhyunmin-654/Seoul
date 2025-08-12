<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Seoul</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>

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

	<div class="page-title">
		<div class="container align-items-center" data-aos="fade-up">
			<h1>FAQ 관리</h1>
			<div class="page-title-underline-accent"></div>
		</div>
	</div>
    
	<div class="section">
		<div class="container" data-aos="fade-up" data-aos-delay="100">
			<div class="row justify-content-center">
				<div class="col-md-10 board-section my-4 p-5">

					<div class="pb-2">
						<span class="small-title">FAQ 등록</span>
					</div>

					<form name="postForm" action="" method="post" enctype="multipart/form-data">
						<table class="table write-form">
							<tr>
								<td class="col-md-2 bg-light">제 목</td>
								<td>
									<input type="text" name="question" class="form-control" maxlength="100" placeholder="question" value="${dto.question}">
								</td>
							</tr>

							<tr>
								<td class="col-md-2 bg-light">작성자</td>
								<td>
									<div class="row">
										<div class="col-md-6">
											<input type="text" name="name" class="form-control" readonly tabindex="-1" value="${sessionScope.member.nickname}">
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
																					
						</table>
						
						<div class="text-center">
							<button type="button" class="btn-accent btn-md" onclick="sendOk();">${mode == 'update' ? '수정완료' : '등록완료' }</button>
							<button type="reset" class="btn-default btn-md">다시입력</button>
							<button type="button" class="btn-default btn-md" onclick="location.href='${pageContext.request.contextPath}/admin/faqManage/list';">${mode == 'update' ? '수정취소' : '등록취소' }</button>
							<c:if test="${mode=='update'}">
								<input type="hidden" name="faq_id" value="${dto.faq_id}">
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

function sendOk() {
	const f = document.postForm;
	let str;
	
	str = f.question.value.trim();
	if( ! str ) {
		alert('제목을 입력하세요. ');
		f.question.focus();
		return;
	}

	const htmlViewEL = document.querySelector('textarea#html-view');
	let htmlContent = htmlViewEL ? htmlViewEL.value : quill.root.innerHTML;
	if(! hasContent(htmlContent)) {
		alert('내용을 입력하세요. ');
		if(htmlViewEL) {
			htmlViewEL.focus();
		} else {
			quill.focus();
		}
		return;
	}
	f.content.value = htmlContent;

	f.action = '${pageContext.request.contextPath}/admin/faqManage/${mode}';
	f.submit();
}


</script>

<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>