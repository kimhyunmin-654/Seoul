<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/products.css" type="text/css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="icon" href="data:;base64,iVBORw0KGgo=">
</head>
<body>

<main class="main-container">

  <div class="right-panel">
    <!-- 페이지 제목 -->
    <div class="page-title" data-aos="fade-up" data-aos-delay="200">
      <h2>내 물건 관리</h2>
    </div>

    <!-- 본문 섹션 -->




			<div class="market-wrap">
			  <div class="market-card">
			  
			  <div class="market-head">
				  <h5 class="market-title">
				    ${mode=='update' ? '내 물건 수정' : '내 물건 팔기'}
				  </h5>
			  </div>
			  			  
            <!-- 폼 시작 -->
            <form name="productForm" id="productForm" action="${actionUrl}" method="post" enctype="multipart/form-data">

              <!-- 대표이미지 -->
              <div class="mb-3">
                <label class="form-label fw-bold">대표이미지</label>
                <div class="preview-session">
                  <label for="thumbnailFile" class="me-2" tabindex="0" title="이미지 업로드">
                    <span class="image-viewer"></span>
                    <input type="file" name="thumbnailFile" id="thumbnailFile" hidden="" accept="image/png, image/jpeg">
                  </label>
                </div>
              </div>

              <!-- 추가이미지 -->
              <div class="mb-3">
                <label class="form-label fw-bold">추가이미지</label>
                <div class="preview-session">
                  <label for="addFiles" class="me-2" tabindex="0" title="이미지 업로드">
                    <img class="image-upload-btn" src="${pageContext.request.contextPath}/dist/images/add_photo.png">
                    <input type="file" name="addFiles" id="addFiles" hidden="" multiple accept="image/png, image/jpeg">
                  </label>
                  <div class="image-upload-list">
                    <c:forEach var="vo" items="${listFile}">
                      <img class="image-uploaded" src="${pageContext.request.contextPath}/uploads/products/${vo.filename}"
                           data-fileNum="${vo.fileNum}" data-filename="${vo.filename}">
                    </c:forEach>
                  </div>
                </div>
              </div>

              <!-- 제목 -->
              <div class="mb-3">
                <label class="form-label fw-bold">제목</label>
                <input type="text" name="productName" class="form-control" value="${dto.productName}" required maxlength="200">
              </div>

              <!-- 상세설명 -->
              <div class="mb-3">
                <label class="form-label fw-bold">자세한 설명</label>
                <textarea rows="8" name="content" class="form-control" required>${dto.content}</textarea>
              </div>

              <!-- 카테고리 -->
              <div class="mb-3">
                <label class="form-label fw-bold">카테고리</label>
                <div class="row">
                  <div class="col-md-6">
                    <select name="regionId" id="regionId" class="form-select" required>
                      <option value="">:: 지역 카테고리 ::</option>
                      <c:forEach var="r" items="${regions}">
                        <option value="${r.regionId}" ${dto.regionId==r.regionId?'selected':''}>${r.regionName}</option>
                      </c:forEach>
                    </select>
                  </div>
                  <div class="col-md-6">
                    <select name="categoryId" id="categoryId" class="form-select" required>
                      <option value="">:: 상품 카테고리 ::</option>
                      <c:forEach var="cvo" items="${categories}">
                        <option value="${cvo.categoryId}" ${dto.categoryId==cvo.categoryId?'selected':''}>${cvo.categoryName}</option>
                      </c:forEach>
                    </select>
                  </div>
                </div>
              </div>

              <!-- 거래유형 -->
              <div class="mb-3">
                <label class="form-label fw-bold">거래유형</label>
                <select name="type" class="form-select" required>
                  <option value="">:: 선택 ::</option>
                  <option value="판매" ${dto.type=='판매'?'selected':''}>판매</option>
                  <option value="나눔" ${dto.type=='나눔'?'selected':''}>나눔</option>
                  <option value="경매" ${dto.type=='경매'?'selected':''}>경매</option>
                </select>
              </div>

              <!-- 가격 -->
              <div class="mb-3">
                <label class="form-label fw-bold">상품가격</label>
                <div class="row">
                  <div class="col-md-6">
                    <input type="number" name="price" class="form-control" value="${dto.price}" min="0" step="1" required>
                  </div>
                  <div class="col-md-6 d-flex align-items-center">
                    <span class="text-muted small ms-2">나눔 선택 시 0원으로 설정 권장</span>
                  </div>
                </div>
              </div>

              <!-- 판매상태 (수정 모드에서만) -->
              <c:if test="${mode=='update'}">
                <div class="mb-3">
                  <label class="form-label fw-bold">판매상태</label>
                  <select name="status" class="form-select" required>
                    <option value="판매중" ${dto.status=='판매중'?'selected':''}>판매중</option>
                    <option value="예약중" ${dto.status=='예약중'?'selected':''}>예약중</option>
                    <option value="판매완료" ${dto.status=='판매완료'?'selected':''}>판매완료</option>
                  </select>
                </div>
              </c:if>

              <!-- 버튼 -->
              <div class="text-center">
                <c:url var="backUrlBuilt" value="${backUrl}">
                  <c:if test="${not empty page}">
                    <c:param name="page" value="${page}"/>
                  </c:if>
                </c:url>

                <button type="submit" class="btn-accent btn-md">
                  ${mode=='update' ? '수정완료' : '등록완료'}
                </button>
                <button type="reset" class="btn-default btn-md">다시입력</button>
                <button type="button" class="btn-default btn-md" onclick="location.href='${backUrlBuilt}';">${mode=='update' ? '수정취소' : '등록취소'}</button>

                <c:if test="${mode=='update'}">
                  <input type="hidden" name="productId" value="${dto.productId}">
                  <input type="hidden" name="page" value="${page}">
                </c:if>
              </div>

            </form>
            <!-- 폼 끝 -->

          </div>
        </div>       
    </div>

</main>

<script type="text/javascript">
//단일 이미지 ---
window.addEventListener('DOMContentLoaded', evt => {
	const imageViewer = document.querySelector('form .image-viewer');
	const inputEL = document.querySelector('form input[name=thumbnailFile]');
	
	let uploadImage = '${dto.thumbnail}';
	let img;
	if( uploadImage ) { // 수정인 경우
		img = '${pageContext.request.contextPath}/uploads/products/' + uploadImage;
	} else {
		img = '${pageContext.request.contextPath}/dist/images/add_photo.png';
	}
	imageViewer.textContent = '';
	imageViewer.style.backgroundImage = 'url(' + img + ')';
	
	inputEL.addEventListener('change', ev => {
		let file = ev.target.files[0];
		if(! file) {
			let img;
			if( uploadImage ) { // 수정인 경우
				img = '${pageContext.request.contextPath}/uploads/products/' + uploadImage;
			} else {
				img = '${pageContext.request.contextPath}/dist/images/add_photo.png';
			}
			imageViewer.textContent = '';
			imageViewer.style.backgroundImage = 'url(' + img + ')';
			
			return;
		}
		
		if(! file.type.match('image.*')) {
			inputEL.focus();
			return;
		}
		
		const reader = new FileReader();
		reader.onload = e => {
			imageViewer.textContent = '';
			imageViewer.style.backgroundImage = 'url(' + e.target.result + ')';
		};
		reader.readAsDataURL(file);
	});
});

//다중 이미지 ---
//수정인 경우 이미지 파일 삭제
window.addEventListener('DOMContentLoaded', evt => {
	const fileUploadList = document.querySelectorAll('form .image-upload-list .image-uploaded');
	
	for(let el of fileUploadList) {
		el.addEventListener('click', () => {
			/*
			let listEl = document.querySelectorAll('form .image-upload-list .image-uploaded');
			if(listEl.length <= 1) {
				alert('등록된 이미지가 2개 이상인 경우만 삭제 가능합니다.');
				return false;
			}
			*/
			
			if(! confirm('선택한 파일을 삭제 하시겠습니까 ?')) {
				return false;
			}
				
			let url = '${pageContext.request.contextPath}/admin/products/deleteFile';
			// let fileNum = el.getAttribute('data-fileNum');
			let fileNum = el.dataset.filenum;
			let filename = el.dataset.filename;

			$.ajaxSetup({ beforeSend: function(e) { e.setRequestHeader('AJAX', true); } });
			$.post(url, {fileNum:fileNum, filename:filename}, function(data){
				el.remove();
			}, 'json').fail(function(xhr){
				console.log(xhr.responseText);
			});
			
		});
	}
});

//다중 이미지 추가
window.addEventListener('DOMContentLoaded', evt => {
	var sel_files = [];
	
	const imageListEL = document.querySelector('form .image-upload-list');
	const inputEL = document.querySelector('form input[name=addFiles]');
	
	// sel_files[] 에 저장된 file 객체를 <input type="file">로 전송하기
	const transfer = () => {
		let dt = new DataTransfer();
		for(let f of sel_files) {
			dt.items.add(f);
		}
		inputEL.files = dt.files;
	}

	inputEL.addEventListener('change', ev => {
		if(! ev.target.files || ! ev.target.files.length) {
			transfer();
			return;
		}
		
		for(let file of ev.target.files) {
			if(! file.type.match('image.*')) {
				continue;
			}

			sel_files.push(file);
     	
			let node = document.createElement('img');
			node.classList.add('image-item');
			node.setAttribute('data-filename', file.name);

			const reader = new FileReader();
			reader.onload = e => {
				node.setAttribute('src', e.target.result);
			};
			reader.readAsDataURL(file);
     	
			imageListEL.appendChild(node);
		}
		
		transfer();		
	});
	
	imageListEL.addEventListener('click', (e)=> {
		if(e.target.matches('.image-item')) {
			if(! confirm('선택한 파일을 삭제 하시겠습니까 ?')) {
				return false;
			}
			
			let filename = e.target.getAttribute('data-filename');
			
			for(let i = 0; i < sel_files.length; i++) {
				if(filename === sel_files[i].name){
					sel_files.splice(i, 1);
					break;
				}
			}
		
			transfer();
			
			e.target.remove();
		}
	});	
});
</script>


</body>
</html>
