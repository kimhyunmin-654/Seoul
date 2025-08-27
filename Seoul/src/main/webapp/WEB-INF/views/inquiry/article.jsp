<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>서울한바퀴</title>
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
  /* 기본 버튼 스타일 */
  .btn-custom-default {
    background-color: #f1f3f5;
    border: 1px solid #e9ecef;
    color: #495057;
    font-weight: 500;
    padding: 0.5rem 1rem;
    border-radius: 0.5rem;
    transition: all 0.2s ease-in-out;
  }
  .btn-custom-default:hover {
    background-color: #e9ecef;
    border-color: #dee2e6;
    transform: translateY(-2px);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  }

  /* 삭제 버튼 스타일 (빨간색) */
  .btn-custom-delete {
    background-color: #dc3545;
    border-color: #dc3545;
    color: #fff;
    font-weight: 500;
    padding: 0.5rem 1rem;
    border-radius: 0.5rem;
    transition: all 0.2s ease-in-out;
  }
  .btn-custom-delete:hover {
    background-color: #c82333;
    border-color: #bd2130;
    transform: translateY(-2px);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  }

  /* 비활성화된 버튼 스타일 */
  .btn:disabled {
    background-color: #e9ecef;
    border-color: #dee2e6;
    color: #adb5bd;
    cursor: not-allowed;
    opacity: 0.7;
    transform: none;
    box-shadow: none;
  }

  /* 메인 섹션 컨테이너 */
  .board-section {
    background-color: #fff;
    border-radius: 0.5rem;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  }
  .sm-title {
    font-size: 1.2rem;
    color: #212529;
  }

</style>
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>
    
	<div class="section">
		<div class="container" data-aos="fade-up" data-aos-delay="100">
			<div class="row justify-content-center">
				<div class="col-md-10 board-section my-4 p-5">

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
							${dto.name}
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
							${(empty dto.answered_at)?"답변대기":"답변완료"}
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
					</div>

					<div class="row py-2 mb-2">
						<div class="col-md-6 align-self-center">
							<button type="button" class="btn-custom-delete" onclick="deleteOk();">질문삭제</button>
						</div>
						<div class="col-md-6 align-self-center text-end">
							<c:if test="${empty prevDto}">
								<button type="button" class="btn-custom-default" disabled>이전글</button>
							</c:if>
							<c:if test="${not empty prevDto}">
								<button type="button" class="btn-custom-default" onclick="location.href='${pageContext.request.contextPath}/inquiry/article?${query}&inquiry_id=${prevDto.inquiry_id}';">이전글</button>
							</c:if>
							<c:if test="${empty nextDto}">
								<button type="button" class="btn-custom-default" disabled>다음글</button>
							</c:if>
							<c:if test="${not empty nextDto}">
								<button type="button" class="btn-custom-default" onclick="location.href='${pageContext.request.contextPath}/inquiry/article?${query}&inquiry_id=${nextDto.inquiry_id}';">다음글</button>
							</c:if>

							<button type="button" class="btn-custom-default" onclick="location.href='${pageContext.request.contextPath}/inquiry/list?${query}';">리스트</button>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
function deleteOk() {
	if(confirm('문의를 삭제 하시겠습니까 ?')) {
		let params = 'inquiry_id=${dto.inquiry_id}&${query}';
		let url = '${pageContext.request.contextPath}/inquiry/delete?' + params;
		location.href = url;
	}
}
</script>


</body>
</html>