<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>hShop</title>
<jsp:include page="/WEB-INF/views/admin/product/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<!-- Quill Rich Text Editor -->
<link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet">
<!-- Quill Editor Image Resize CSS -->
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
			<h2><i class="bi bi-box"></i> 상품 관리 <span class="page-small-title">&nbsp;&nbsp;|&nbsp;&nbsp; Manages items</span></h2>
		</div>

		<div class="section p-5" data-aos="fade-up" data-aos-delay="200">
			<div class="section-body p-5">
				<div class="row gy-4 m-0">
					<div class="col-lg-12 board-section p-5 m-2" data-aos="fade-up" data-aos-delay="200">
						
						<div class="pb-2">
							<i class="bi bi-pencil-square"></i> <span class="small-title">${mode=='update'?'상품 수정':'상품 등록'}</span>
						</div>
					
						<form name="productForm" action="" method="post" enctype="multipart/form-data">
							<table class="table write-form">
								<tr>
									<td class="col-md-2 bg-light">카테고리</td>
									<td>
										<div class="row">
											<div class="col-md-6">
												<select name="parentNum" class="form-select">
													<option value="">메인 카테고리</option>
													<c:forEach var="vo" items="${listCategory}">
														<option value="${vo.categoryNum}" ${parentNum==vo.categoryNum?"selected":""}>${vo.categoryName}</option>
													</c:forEach>
												</select>
											</div>
											<div class="col-md-6">
												<select name="categoryNum" class="form-select">
													<option value="">하위 카테고리</option>
													<c:forEach var="vo" items="${listSubCategory}">
														<option value="${vo.categoryNum}" ${dto.categoryNum==vo.categoryNum?"selected":""}>${vo.categoryName}</option>
													</c:forEach>
												</select>
											</div>
										</div>
									</td>
								</tr>
							
								<tr>
									<td class="col-md-2 bg-light">상품명</td>
									<td>
										<input type="text" name="productName" class="form-control" value="${dto.productName}">
									</td>
								</tr>
							
								<tr>
									<td class="col-md-2 bg-light">상품가격</td>
									<td>
										<div class="row">
											<div class="col-md-6">
												<input type="text" name="price" class="form-control" value="${dto.price}">
											</div>
										</div>
									</td>
								</tr>
							
								<tr>
									<td class="col-md-2 bg-light">배송비</td>
									<td>
										<div class="row">
											<div class="col-md-6">
												<input type="text" name="delivery" class="form-control" value="${dto.delivery}">
											</div>
										</div>
										<small class="form-control-plaintext help-block">배송비가 0인 경우 무료 배송입니다.</small>
									</td>
								</tr>
								
								
								<tr>
								    <td class="col-md-2 bg-light">상품옵션</td>
								    <td>
								        <input type="text" name="optionName" value="${dto.option_name}" class="form-control" placeholder="예: 색상, 사이즈 등" />
								    </td>
								</tr>

								<tr>
									<td class="col-md-2 bg-light">상품진열</td>
									<td>
										<div class="py-2">
											<input type="radio" class="form-check-input" name="productShow" id="productShow1" value="1" ${dto.productShow==1 ? "checked":"" }>
											<label for="productShow1" class="form-check-label">상품진열</label>
											&nbsp;&nbsp;
											<input type="radio" class="form-check-input" name="productShow" id="productShow2" value="0" ${dto.productShow==0 ? "checked":"" }>
											<label for="productShow2" class="form-check-label">진열안함</label>
										</div>
									</td>
								</tr>
							
								<tr>
									<td class="col-md-2 bg-light">상품설명</td>
									<td>
										<div id="editor">${dto.content}</div>
										<input type="hidden" name="content">
									</td>
								</tr>
								
								<tr>
									<td class="col-md-2 bg-light">대표이미지</td>
									<td>
										<div class="preview-session">
											<label for="thumbnailFile" class="me-2" tabindex="0" title="이미지 업로드">
												<span class="image-viewer"></span>
												<input type="file" name="thumbnailFile" id="thumbnailFile" hidden="" accept="image/png, image/jpeg">
											</label>
										</div>
									</td>
								</tr>
								
								<tr>
									<td class="col-md-2 bg-light">추가이미지</td>
									<td>
										<div class="preview-session">
											<label for="addFiles" class="me-2" tabindex="0" title="이미지 업로드">
												<img class="image-upload-btn" src="${pageContext.request.contextPath}/dist/images/add_photo.png">
												<input type="file" name="addFiles" id="addFiles" hidden="" multiple accept="image/png, image/jpeg">
											</label>
											<div class="image-upload-list">
												<!-- 클래스 -> image-item:새로추가된이미지, image-uploaded:수정에서 등록된이미지 -->
												<!-- 수정일때 등록된 이미지 -->
												<c:forEach var="vo" items="${listFile}">
													<img class="image-uploaded" src="${pageContext.request.contextPath}/uploads/products/${vo.filename}"
														data-fileNum="${vo.fileNum}" data-filename="${vo.filename}">
												</c:forEach>
											</div>
										</div>
									</td>
								</tr>
							</table>
							
							<%-- classify: 특가같은 거라서 없앴는데 어떻게 해야하는가? --%>
							<div class="text-center">
								<c:url var="url" value="/admin/products/main/${classify}">
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
									<input type="hidden" name="prevOptionNum2" value="${empty dto.optionNum2 ? 0 : dto.optionNum2}">
								</c:if>
							</div>
						</form>

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
	let mode = '${mode}';
	
	if(mode === 'write') {
		// 등록인 경우
		let classify = '${classify}';
		$('select[name=classify]').val(classify);
		
		$('#productShow1').prop('checked', true);
	} else if(mode === 'update') {
		// 수정인 경우
		let count = Number('${dto.optionCount}') || 0;
		
		if(count === 0) {
			$('.product-option-1').hide();
			$('.product-option-2').hide();
		} else if(count === 1) {
			$('.product-option-2').hide();
		}		
	}
});

function hasContent(htmlContent) {
	htmlContent = htmlContent.replace(/<p[^>]*>/gi, ''); // p 태그 제거
	htmlContent = htmlContent.replace(/<\/p>/gi, '');
	htmlContent = htmlContent.replace(/<br\s*\/?>/gi, ''); // br 태그 제거
	htmlContent = htmlContent.replace(/&nbsp;/g, ' ');
	htmlContent = htmlContent.replace(/\s/g, ''); // 공백 제거
	
	return htmlContent.length > 0;
}

function sendOk() {
	const f = document.productForm;
	let mode = '${mode}';
	
	let str, b;
	
	if(! f.parentNum.value) {
		alert('카테고리를 선택하세요.');
		f.parentNum.focus();
		return;
	}

	if(! f.categoryNum.value) {
		alert('카테고리를 선택하세요.');
		f.categoryNum.focus();
		return;
	}
	
	if(! f.productName.value.trim()) {
		alert('상품명을 입력하세요.');
		f.productName.focus();
		return;
	}	
	
	if(!/^(\d){1,8}$/.test(f.price.value)) {
		alert('상품가격을 입력 하세요.');
		f.price.focus();
		return;
	}	

	if(!/^(\d){1,2}$/.test(f.discountRate.value)) {
		alert('할인율을 입력 하세요.');
		f.discountRate.focus();
		return;
	}	
	
	if(!/^(\d){1,7}$/.test(f.savedMoney.value)) {
		alert('적립금을 입력 하세요.');
		f.savedMoney.focus();
		return;
	}
	
	if(!/^(\d){1,8}$/.test(f.delivery.value)) {
		alert('배송비를 입력 하세요.');
		f.delivery.focus();
		return;
	}
	
	let optionCount = parseInt(f.optionCount.value);
	if(optionCount > 0) {
		if(! f.optionName.value.trim()) {
			alert('옵션명 입력 하세요.');
			f.optionName.focus();
			return;
		}
		
		b = true;
		$('form input[name=optionValues]').each(function(){
			if(! $(this).val().trim()) {
				b = false;
				return false;
			}
		});
		
		if(! b) {
			alert('옵션값을 입력 하세요.');
			return;
		}
	}
	
	if(optionCount > 1) {
		if(! f.optionName2.value.trim()) {
			alert('옵션명 입력 하세요.');
			f.optionName2.focus();
			return;
		}
		
		b = true;
		$('form input[name=optionValues2]').each(function(){
			if(! $(this).val().trim()) {
				b = false;
				return false;
			}
		});
		
		if(! b) {
			alert('옵션값을 입력 하세요.');
			return;
		}
	}
	
	b = false;
	for(let ps of f.productShow) {
		if( ps.checked ) {
			b = true;
			break;
		}
	}
	if( ! b ) {
		alert('상품진열 여부를 선택하세요.');
		f.productShow[0].focus();
		return;
	}
	
	const htmlViewEL = document.querySelector('textarea#html-view');
	let htmlContent = htmlViewEL ? htmlViewEL.value : quill.root.innerHTML;
	if(! hasContent(htmlContent)) {
		alert('상품설명을 입력하세요. ');
		if(htmlViewEL) {
			htmlViewEL.focus();
		} else {
			quill.focus();
		}
		return;
	}
	f.content.value = htmlContent;
	
	if(mode === 'write' && ! f.thumbnailFile.value) {
		alert('대표 이미지를 등록하세요.');
		f.thumbnailFile.focus();
		return false;
	}	
	
	f.action = '${pageContext.request.contextPath}/admin/products/${mode}/${classify}';
	f.submit();
}
</script>

<script type="text/javascript">
$(function(){
	// 메인 카테고리가 변경된 경우
	$('form select[name=parentNum]').change(function(){
		let parentNum = $(this).val();
		
		$('form select[name=categoryNum]').find('option')
			.remove().end()
			.append('<option value="">:: 카테고리 선택 ::</option>');	
		
		if(! parentNum) {
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/admin/products/listSubCategory';
		let formData = 'parentNum=' + parentNum;
		
		const fn = function(data) {
			$.each(data.listSubCategory, function(index, item){
				let categoryNum = item.categoryNum;
				let categoryName = item.categoryName;
				let s = '<option value="' + categoryNum + '">' + categoryName + '</option>';
				$('form select[name=categoryNum]').append(s);
			});
		};
		
		ajaxRequest(url, 'get', formData, 'json', fn);
	});

	// 옵션의 개수가 변경된 경우
	$('select[name=optionCount]').change(function(){
		let count = parseInt($(this).val());
		let mode = '${mode}';
		let savedCount = '${dto.optionCount}';
		let totalStock = '${dto.totalStock}';
		
		if(mode === 'update' && totalStock !== '0') {
			alert('옵션 변경이 불가능 합니다.');
			$(this).val(savedCount);
			return false;
		}
		
		if(count === 0) {
			$('.product-option-1').hide();
			$('.product-option-2').hide();
			
			
		} else if(count === 1) {
			$('.product-option-1').show();
			$('.product-option-2').hide();
			
			
		} else if(count === 2) {
			$('.product-option-1').show();
			$('.product-option-2').show();
		}
	});
});

$(function(){
	// 옵션 1 추가 버튼을 클릭한 경우	
	$('.btnOptionAdd').click(function(){
		let $el = $(this).closest('.option-area').find('.optionValue-area');
		if($el.find('.input-group').length >= 5) {
			alert('옵션은 최대 5개까지 가능합니다.');
			return false;
		}
		
		let $option = $('.option-area .optionValue-area .input-group:first-child').clone();
		
		$option.find('input[type=hidden]').remove();
		$option.find('input[name=optionValues]').removeAttr('value');
		$option.find('input[name=optionValues]').val('');
		$el.append($option);
	});
	
	// 옵션 1의 옵션값 제거를 클릭한 경우
	$('.option-area').on('click', '.option-minus', function(){
		let $minus = $(this);
		let $el = $minus.closest('.option-area').find('.optionValue-area');
		
		// 수정에서 등록된 자료 삭제
		let mode = '${mode}';
		if(mode === 'update' && $minus.parent('.input-group').find('input[name=detailNums]').length === 1) {
			// 저장된 옵션값중 최소 하나는 삭제되지 않도록 설정
			if($el.find('.input-group input[name=detailNums]').length <= 1) {
				alert('옵션값은 최소 하나이상 필요합니다.');	
				return false;
			}
			
			if(! confirm('옵션값을 삭제 하시겠습니까 ? ')) {
				return false;
			}
			
			let detailNum = $minus.parent('.input-group').find('input[name=detailNums]').val();
			let url = '${pageContext.request.contextPath}/admin/products/deleteOptionDetail';
			
			$.ajaxSetup({ beforeSend: function(e) { e.setRequestHeader('AJAX', true); } });
			$.post(url, {detailNum:detailNum}, function(data){
				if(data.state === 'true') {
					$minus.closest('.input-group').remove();
				} else {
					alert('옵션값을 삭제할 수 없습니다.');
				}
			}, 'json').fail(function(jqXHR){
				console.log(jqXHR.responseText);
			});
			
			return false;			
		}
		
		if($el.find('.input-group').length <= 1) {
			$el.find('input[name=optionValues]').val('');
			return false;
		}
		
		$minus.closest('.input-group').remove();
	});
});

$(function(){
	// 옵션 2 추가 버튼을 클릭한 경우	
	$('.btnOptionAdd2').click(function(){
		let $el = $(this).closest('.option-area2').find('.optionValue-area2');
		if($el.find('.input-group').length >= 5) {
			alert('옵션 값은 최대 5개까지 가능합니다.');
			return false;
		}
		let $option = $('.option-area2 .optionValue-area2 .input-group:first-child').clone();
		
		$option.find('input[type=hidden]').remove();
		$option.find('input[name=optionValues2]').removeAttr('value');
		$option.find('input[name=optionValues2]').val('');
		$el.append($option);
	});
	
	// 옵션 2의 옵션값 제거를 클릭한 경우
	$('.option-area2').on('click', '.option-minus2', function(){
		let $minus = $(this);
		let $el = $minus.closest('.option-area2').find('.optionValue-area2');
		
		// 수정에서 등록된 자료 삭제
		let mode = '${mode}';
		if(mode === 'update' && $minus.parent('.input-group').find('input[name=detailNums2]').length === 1) {
			// 저장된 옵션값중 최소 하나는 삭제되지 않도록 설정
			if($el.find('.input-group input[name=detailNums2]').length <= 1) {
				alert('옵션값은 최소 하나이상 필요합니다.');	
				return false;
			}
			
			if(! confirm('옵션값을 삭제 하시겠습니까 ? ')) {
				return false;
			}
			
			let detailNum = $minus.parent('.input-group').find('input[name=detailNums2]').val();
			let url = '${pageContext.request.contextPath}/admin/products/deleteOptionDetail';
			
			$.ajaxSetup({ beforeSend: function(e) { e.setRequestHeader('AJAX', true); } });
			$.post(url, {detailNum:detailNum}, function(data){
				if(data.state === 'true') {
					$minus.closest('.input-group').remove();
				} else {
					alert('옵션값을 삭제할 수 없습니다.');
				}
			}, 'json').fail(function(jqXHR){
				console.log(jqXHR.responseText);
			});
		}
		
		if($el.find('.input-group').length <= 1) {
			$el.find('input[name=optionValues2]').val('');
			return false;
		}
		
		$minus.closest('.input-group').remove();
	});
});
</script>

<script type="text/javascript">
// 단일 이미지 ---
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

// 다중 이미지 ---
// 수정인 경우 이미지 파일 삭제
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

// 다중 이미지 추가
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

<footer>
	<jsp:include page="/WEB-INF/views/admin/product/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/product/layout/footerResources.jsp"/>

</body>
</html>