<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>서울한바퀴</title>
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board2.css" type="text/css">
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

	<div class="right-panel">
		<div class="page-title">
			<h2>1:1 문의</h2>
		</div>

			<div class="section-body p-5">
				<div class="row gy-4 m-0">
					<div class="col-lg-12 board-section p-5 m-2" data-aos="fade-up" data-aos-delay="200">
						
						<div class="row p-2">
							<div class="col-md-12 ps-0 pb-1">
								<span class="sm-title fw-bold">문의사항</span>
							</div>
							
							<div class="col-md-2 text-center bg-light border-top border-bottom p-2">
								제 목
							</div>
							<div class="col-md-10  border-top border-bottom p-2">
								${dto.title}
							</div>
							<div class="col-md-2 text-center bg-light border-bottom p-2">
								이 름
							</div>
							<div class="col-md-4 border-bottom p-2">
								${dto.name}(${empty dto.login_id ? '비회원' : dto.login_id})
							</div>
	
							<div class="col-md-2 text-center bg-light border-bottom p-2">
								문의일자
							</div>
							<div class="col-md-4 border-bottom p-2">
								${dto.created_at}
							</div>
							<div class="col-md-2 text-center bg-light border-bottom p-2">
								처리결과
							</div>
							<div class="col-md-4 border-bottom p-2">
								${(empty dto.answer_id) ? "답변대기" : "답변완료"}
							</div>
	
							<div class="col-md-12 border-bottom mh-px-150">
								<div class="row h-100">
									<div class="col-md-2 text-center bg-light p-2 h-100 d-none d-md-block">
										내 용
									</div>
									<div class="col-md-10 p-2 h-100">
										${dto.content}
									</div>
								</div>
							</div>
	
							<c:if test="${not empty dto.answer}">
								<div class="col-md-12 ps-0 pt-3 pb-1">
									<span class="sm-title fw-bold">답변내용</span>
								</div>
	
								<div class="col-md-2 text-center bg-light border-top border-bottom p-2">
									담당자
								</div>
								<div class="col-md-4 border-top border-bottom p-2">
									관리자
								</div>
								<div class="col-md-2 text-center bg-light border-top border-bottom p-2">
									답변일자
								</div>
								<div class="col-md-4 border-top border-bottom p-2">
									${dto.answered_at}
								</div>
								
								<div class="col-md-12 border-bottom mh-px-150">
									<div class="row h-100">
										<div class="col-md-2 text-center bg-light p-2 h-100 d-none d-md-block">
											답 변
										</div>
										<div class="col-md-10 p-2 h-100">
											${dto.answer}
										</div>
									</div>
								</div>
							</c:if>
	
							<div class="col-md-6 p-2 ps-0">
								<div class="left-panel">
					    			<button type="button" class="btn-default" onclick="deleteOk('question');">문의삭제</button>
						    		
									<c:if test="${empty dto.answered_at}">
										<button type="button" class="btn-default" onclick="answerOk();">답변등록</button>
									</c:if>
									<c:if test="${not empty dto.answer_id && sessionScope.member.member_id==dto.answer_id}">
										<button type="button" class="btn-default" onclick="answerOk();">답변수정</button>
									</c:if>
									<c:if test="${not empty dto.answer_id && (sessionScope.member.member_id==dto.answer_id || sessionScope.member.userLevel >= 9)}"> <!-- 관리자 레벨 9  -->
										<button type="button" class="btn-default" onclick="deleteOk('answer');">답변삭제</button>
									</c:if>
									
								</div>
							</div>
							<div class="col-md-6 p-2 pe-0 text-end">
								<c:if test="${empty prevDto}">
									<button type="button" class="btn-default" disabled>이전글</button>
								</c:if>
								<c:if test="${not empty prevDto}">
									<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/inquiryManage/article?${query}&inquiry_id=${prevDto.inquiry_id}';">이전글</button>
								</c:if>
								<c:if test="${empty nextDto}">
									<button type="button" class="btn-default" disabled>다음글</button>
								</c:if>
								<c:if test="${not empty nextDto}">
									<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/inquiryManage/article?${query}&inquiry_id=${nextDto.inquiry_id}';">다음글</button>
								</c:if>
								
								<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/inquiryManage/list?${query}';">리스트</button>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
</main>

<!-- 답변 등록 및 답변 수정 대화상자 -->
<div class="modal fade" id="myDialogModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="myDialogModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="myDialogModalLabel">${empty dto.answer ? "답변 등록" : "답변 수정"}</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body p-2">
				<form name="answerForm" method="post">
					<div class="row">
						<div class="col-md-12 py-3"><span class="sm-title">답변 내용</span></div>
						<div class="col-md-12 mh-px-70">
							<textarea class="form-control" name="answer">${dto.answer}</textarea>
						</div>
						<div class="col-md-12 text-end py-3">
							<input type="hidden" name="inquiry_id" value="${dto.inquiry_id}">	
							<input type="hidden" name="page" value="${page}">
								   		
						    <button type="button" class="btn-accent btnAnswerSend">${empty dto.answer ? "등록완료" : "수정완료"}</button>
						    <button type="button" class="btn-default btnAnswerCancel">${empty dto.answer ? "답변취소" : "수정취소"}</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
function deleteOk(mode) {
	let s = mode === 'question' ? '질문' : '답변';
	
	if(confirm(s + '을 삭제 하시 겠습니까 ? ')) {
		let params = 'inquiry_id=${dto.inquiry_id}&${query}&mode=' + mode;
		let url = '${pageContext.request.contextPath}/admin/inquiryManage/delete?' + params;
		location.href = url;
	}
}

function answerOk() {
    console.log("answerOk 함수 호출됨"); // 추가된 로그
	const modal = new bootstrap.Modal('#myDialogModal');
	modal.show();
}
  
window.addEventListener('DOMContentLoaded', ev => {
	 console.log("DOMContentLoaded 이벤트 발생, 스크립트 실행 시작"); // 추가된 로그
    const myModalEl = document.getElementById('myDialogModal');
	myModalEl.addEventListener('shown.bs.modal', function () {
		const f = document.answerForm;
		f.answer.focus();
	});
    
	const btnSendEL = document.querySelector('.btnAnswerSend');
	const btnCancelEL = document.querySelector('.btnAnswerCancel');

	btnSendEL.addEventListener('click', e => {
		const f = document.answerForm;
		if(! f.answer.value.trim()) {
			f.answer.focus();
			return false;
		}
		
		f.action = '${pageContext.request.contextPath}/admin/inquiryManage/answer';
		f.submit();
	});

	btnCancelEL.addEventListener('click', function(e) {
		const f = document.answerForm;
		f.answer.value = `${dto.answer}`;
		
	    const modal = bootstrap.Modal.getInstance(myModalEl);
	    modal.hide();
	});
});
</script>

<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>
