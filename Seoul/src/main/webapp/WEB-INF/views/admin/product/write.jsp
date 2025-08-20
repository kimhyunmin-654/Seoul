<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<jsp:include page="/WEB-INF/views/admin/product/layout/headerResources.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/products.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/faqlist.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/chat.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/main2.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/shop.css" type="text/css">

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/quill-resize-module@2.0.4/dist/resize.css" rel="stylesheet">
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/product/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/product/layout/left.jsp"/>

	<div class="right-panel">
		<div class="page-title">
			<h2><i class="bi bi-box"></i> 상품 등록
				<span class="page-small-title">&nbsp;&nbsp;|&nbsp;&nbsp; Manages items</span>
			</h2>
		</div>

		<div class="section" data-aos="fade-up" data-aos-delay="200">
			<div class="market-wrap">
				<div class="market-card">

					<div class="market-head">
						<h2 class="market-title">
							<i class="bi bi-pencil-square"></i>
							${mode=='update' ? '상품 수정' : '상품 등록'}
						</h2>
					</div>

					<form name="productForm" action="${pageContext.request.contextPath}/admin/product/${mode}" method="post" enctype="multipart/form-data">

						<div class="mb-3">
						  <label class="form-label fw-bold">카테고리</label>
						  <div class="d-flex gap-2">
						    <select name="parentNum" id="parentNum" class="form-select">
						      <option value="">:: 카테고리 선택 ::</option>
						      <c:forEach var="vo" items="${categoryList}">
						        <option value="${vo.categoryNum}" ${parentNum==vo.categoryNum ? 'selected' : ''}>
						          ${vo.categoryName}
						        </option>
						      </c:forEach>
						    </select>
						
						    <select name="categoryNum" id="categoryNum" class="form-select">
						      <option value="">하위 카테고리</option>
						      <c:forEach var="vo" items="${listSubCategory}">
						        <option value="${vo.categoryNum}" ${dto.categoryNum==vo.categoryNum ? 'selected' : ''}>
						          ${vo.categoryName}
						        </option>
						      </c:forEach>
						    </select>
						  </div>
						</div>
						
						<div class="mb-3">
							<label class="form-label fw-bold">상품명</label>
							<input type="text" name="productName" class="form-control" value="${dto.productName}">
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">상품가격</label>
							<input type="text" name="price" class="form-control" value="${dto.price}">
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">배송비</label>
							<input type="text" name="delivery" class="form-control" value="${dto.delivery}">
							<small class="text-muted">배송비가 0인 경우 무료 배송입니다.</small>
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">상품옵션</label>
							<input type="text" name="optionName" value="${dto.optionName}" class="form-control" placeholder="예: 색상, 사이즈 등" />
						</div>
						
						<div class="mb-3">
						  <label class="form-label fw-bold">상품상태</label>
						  <select name="productState" class="form-select">
						    <option value="">:: 상태 선택 ::</option>
						    <option value="S" ${dto.productState == 'S' ? 'selected' : ''}>S</option>
						    <option value="A" ${dto.productState == 'A' ? 'selected' : ''}>A</option>
						    <option value="B" ${dto.productState == 'B' ? 'selected' : ''}>B</option>
						    <option value="C" ${dto.productState == 'C' ? 'selected' : ''}>C</option>
						    <option value="D" ${dto.productState == 'D' ? 'selected' : ''}>D</option>
						    <option value="E" ${dto.productState == 'E' ? 'selected' : ''}>E</option>
						    <option value="F" ${dto.productState == 'F' ? 'selected' : ''}>F</option>
						  </select>
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">상품진열</label><br>
							<div class="form-check form-check-inline">
								<input type="radio" class="form-check-input" name="productShow" id="productShow1" value="1" ${dto.productShow==1 ? "checked":"" }>
								<label for="productShow1" class="form-check-label">상품진열</label>
							</div>
							<div class="form-check form-check-inline">
								<input type="radio" class="form-check-input" name="productShow" id="productShow2" value="0" ${dto.productShow==0 ? "checked":"" }>
								<label for="productShow2" class="form-check-label">진열안함</label>
							</div>
						</div>

						<div class="mb-3">
							<label class="form-label fw-bold">상품설명</label>
							<div id="editor">${dto.content}</div>
							<input type="hidden" name="content">
						</div>

						<div class="mb-3">
						  <label class="form-label fw-bold">대표이미지</label>
						  <div class="preview-session">
						    <label for="thumbnailFile" class="me-2" tabindex="0" title="이미지 업로드">
						      <c:choose>
						        <c:when test="${not empty dto.thumbnail}">
						          <img class="image-viewer"
						               src="<c:url value='/uploads/product/${dto.thumbnail}'/>"
						               alt="대표이미지">
						        </c:when>
						        <c:otherwise>
						          <img class="image-viewer"
						               src="<c:url value='/dist/images/add_photo.png'/>"
						               alt="대표이미지 업로드">
						        </c:otherwise>
						      </c:choose>
						      <input type="file" name="thumbnailFile" id="thumbnailFile" hidden accept="image/png, image/jpeg">
						    </label>
						  </div>
						</div>
						
						<div class="mb-3">
						  <label class="form-label fw-bold">추가이미지</label>
						  <div class="preview-session">
						    <label for="addFiles" class="me-2" tabindex="0" title="이미지 업로드">
						      <img class="image-upload-btn" src="<c:url value='/dist/images/add_photo.png'/>" alt="추가이미지 업로드">
						      <input type="file" name="addFiles" id="addFiles" hidden multiple accept="image/png, image/jpeg">
						    </label>
						    <div class="image-upload-list">
						      <c:forEach var="vo" items="${files}">
						        <img class="image-uploaded"
						             src="<c:url value='/uploads/product/${vo.filename}'/>"
						             data-fileNum="${vo.fileNum}" data-filename="${vo.filename}">
						      </c:forEach>
						    </div>
						  </div>
						</div>

						<div class="text-center mt-4">
							<c:url var="url" value="/admin/product/list">
								<c:if test="${not empty page}">
									<c:param name="page" value="${page}"/>
								</c:if>
							</c:url>
							<button type="button" class="btn-accent btn-md" onclick="sendOk();">${mode=='update'?'수정완료':'등록완료'}</button>
							<button type="reset" class="btn-default btn-md">다시입력</button>
							<button type="button" class="btn-default btn-md" onclick="location.href='${url}';">${mode=='update'?'수정취소':'등록취소'}</button>
							<c:if test="${mode=='update'}">
								<input type="hidden" name="productNum" value="${dto.productNum}">
								<input type="hidden" name="thumbnail" value="${dto.thumbnail}">
								<input type="hidden" name="page" value="${page}">
								<input type="hidden" name="prevOptionNum" value="${empty dto.optionNum ? 0 : dto.optionNum}">
								<input type="hidden" name="optionCount" value="${dto.optionCount}">
							</c:if>
						</div>

					</form>

				</div>
			</div>
		</div>
	</div>
	
	
</main>

<script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
<script src="https://cdn.jsdelivr.net/npm/quill-resize-module@2.0.4/dist/resize.js"></script>
<script src="${pageContext.request.contextPath}/dist/js/qeditor.js"></script>
<script type="text/javascript">
/* 공백/태그 제거 후 내용 존재 여부 체크 */
function hasContent(htmlContent) {
  htmlContent = htmlContent.replace(/<p[^>]*>/gi, '');
  htmlContent = htmlContent.replace(/<\/p>/gi, '');
  htmlContent = htmlContent.replace(/<br\s*\/?>/gi, '');
  htmlContent = htmlContent.replace(/&nbsp;/g, ' ');
  htmlContent = htmlContent.replace(/\s/g, '');
  return htmlContent.length > 0;
}

function sendOk() {
  const f = document.productForm;
  const mode = '${mode}'; // write | update

  if (!f.parentNum.value) { alert('카테고리를 선택하세요.'); f.parentNum.focus(); return; }
  if (!f.categoryNum.value) { alert('카테고리를 선택하세요.'); f.categoryNum.focus(); return; }
  if (!f.productName.value.trim()) { alert('상품명을 입력하세요.'); f.productName.focus(); return; }

  if (!/^(\d){1,8}$/.test(f.price.value)) { alert('상품가격을 입력 하세요.'); f.price.focus(); return; }
  if (!/^(\d){1,8}$/.test(f.delivery.value)) { alert('배송비를 입력 하세요.'); f.delivery.focus(); return; }

  // 옵션 검증 (optionCount 사용)
  const optionCount = parseInt(f.optionCount ? f.optionCount.value : '0', 10);
  if (optionCount > 0) {
    if (!f.optionName.value.trim()) {
      alert('옵션명을 입력 하세요.');
      f.optionName.focus();
      return;
    }
    const optionInputs = document.querySelectorAll('form input[name="optionValues"]');
    for (const el of optionInputs) {
      if (!el.value.trim()) {
        alert('옵션값을 입력 하세요.');
        el.focus();
        return;
      }
    }
  }

  // 상품진열 여부 체크
  let checked = false;
  const showNodes = f.productShow?.length ? f.productShow : [f.productShow];
  for (const ps of showNodes) {
    if (ps && ps.checked) { checked = true; break; }
  }
  if (!checked) {
    alert('상품진열 여부를 선택하세요.');
    if (showNodes[0]) showNodes[0].focus();
    return;
  }

  // 상품설명
  const htmlViewEL = document.querySelector('textarea#html-view');
  let htmlContent;
  if (htmlViewEL) {
    htmlContent = htmlViewEL.value;
  } else if (typeof quill !== 'undefined' && quill?.root) {
    htmlContent = quill.root.innerHTML;
  } else {
    htmlContent = (document.querySelector('#editor')?.innerHTML || '').toString();
  }

  if (!hasContent(htmlContent)) {
    alert('상품설명을 입력하세요.');
    if (htmlViewEL) htmlViewEL.focus();
    else if (typeof quill !== 'undefined') quill.focus();
    return;
  }
  f.content.value = htmlContent;

  // 등록 시 대표 이미지 필수
  if (mode === 'write' && !f.thumbnailFile.value) {
    alert('대표 이미지를 등록하세요.');
    f.thumbnailFile.focus();
    return;
  }

  // 최종 제출
  f.action = '${pageContext.request.contextPath}/admin/product/${mode}';
  f.submit();
}

// ===== 이미지 미리보기 =====
const thumbEl = document.getElementById('thumbnailFile');
if (thumbEl) {
  thumbEl.addEventListener('change', function (event) {
    const file = event.target.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = function (e) {
      const img = document.querySelector('.image-viewer');
      if (img) img.src = e.target.result;
    };
    reader.readAsDataURL(file);
  });
}

const addFilesEl = document.getElementById('addFiles');
if (addFilesEl) {
  addFilesEl.addEventListener('change', function (event) {
    const files = event.target.files;
    const previewContainer = document.querySelector('.image-upload-list');
    if (!previewContainer) return;
    previewContainer.innerHTML = '';
    Array.from(files).forEach(file => {
      const reader = new FileReader();
      reader.onload = function (e) {
        const img = document.createElement('img');
        img.className = 'image-uploaded';
        img.src = e.target.result;
        previewContainer.appendChild(img);
      };
      reader.readAsDataURL(file);
    });
  });
}

// ===== 카테고리 변경 시 하위 카테고리 로드 =====
document.addEventListener('DOMContentLoaded', function () {
  const parentSelect = document.getElementById('parentNum');
  const categoryNumSelect = document.getElementById('categoryNum');
  if (!parentSelect || !categoryNumSelect) return;

  parentSelect.addEventListener('change', function () {
    const parentNum = this.value;

    // 기존 옵션 초기화
    categoryNumSelect.innerHTML = '<option value="">하위 카테고리</option>';
    if (!parentNum) return;

    fetch('${pageContext.request.contextPath}/admin/product/category/sub?parentNum=' + encodeURIComponent(parentNum))
      .then(res => res.json())
      .then(data => {
        data.forEach(vo => {
          const opt = document.createElement('option');
          opt.value = vo.categoryNum;
          opt.textContent = vo.categoryName;
          categoryNumSelect.appendChild(opt);
        });
      })
      .catch(err => console.error('하위 카테고리 불러오기 실패:', err));
  });
});
</script>

<footer>
	<jsp:include page="/WEB-INF/views/admin/product/layout/footer.jsp"/>
</footer>
<jsp:include page="/WEB-INF/views/admin/product/layout/footerResources2.jsp"/>

</body>
</html>