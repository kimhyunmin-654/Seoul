<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${mode == 'update'}">상품 수정</c:when>
            <c:otherwise>내 물건 팔기</c:otherwise>
        </c:choose>
         - 서울한바퀴
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container { max-width: 800px; }
        .form-label { font-weight: 600; }
        .image-container {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 1rem;
            padding: 1.5rem;
            border: 2px dashed #dee2e6;
            border-radius: 0.5rem;
            min-height: 140px;
            background-color: #f8f9fa;
        }
        .img-wrapper {
            position: relative;
            width: 120px;
            height: 120px;
            border-radius: 0.5rem;
            overflow: hidden;
            border: 3px solid transparent;
            cursor: pointer;
            transition: all 0.3s ease;
            transform: scale(1);
        }
        .img-wrapper:hover {
		    transform: scale(1.02);
		}
        .img-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .img-wrapper.selected {
        	border: 3px solid #0d6efd;
		    transform: scale(1.05);
		    box-shadow: 0 4px 12px rgba(13, 110, 253, 0.3); 
        }
        .img-wrapper.selected::after {
		    content: "대표";
		    position: absolute;
		    bottom: 4px;
		    left: 4px;
		    background: #0d6efd;
		    color: white;
		    padding: 2px 6px;
		    border-radius: 4px;
		    font-size: 11px;
		    font-weight: bold;
		    z-index: 10;
		}
        
        .delete-btn {
            position: absolute;
            top: 4px;
            right: 4px;
            width: 24px;
            height: 24px;
            background-color: rgba(0, 0, 0, 0.7);
            color: white;
            border: none;
            border-radius: 50%;
            font-weight: bold;
            cursor: pointer;
            opacity: 0;
            transition: opacity 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 5;
        }
        .img-wrapper:hover .delete-btn {
            opacity: 1;
        }
		.img-wrapper:not(.selected):hover {
		    border: 3px solid #86b7fe;
		    box-shadow: 0 2px 8px rgba(13, 110, 253, 0.2);
		}
		
    </style>
</head>
<body>
    <div class="container my-5">
        <h2 class="text-center mb-4">
            <c:choose>
                <c:when test="${mode == 'update'}">상품 정보 수정하기 ✍️</c:when>
                <c:otherwise>판매할 상품 정보 입력하기 📦</c:otherwise>
            </c:choose>
        </h2>

        <form name="productForm" 
              action="<c:url value='/product/${not empty mode and mode == "update" ? "update" : "write"}'/>" 
              method="post" enctype="multipart/form-data">

            <%-- 수정 모드일 때만 productId를 함께 전송 --%>
            <c:if test="${mode == 'update'}">
                <input type="hidden" name="product_id" value="${dto.product_id}">
            </c:if>

            <!-- 1. 이미지 영역 -->
            <div class="mb-4">
                <label for="addFiles" class="form-label">상품 이미지 (대표 이미지 선택, 최대 5장)</label>
                <input type="file" name="addFiles" id="addFiles" class="form-control" multiple accept="image/*">
                
                <div class="image-container" id="image-container">
                    <%-- 수정 모드: 기존 이미지 표시 --%>
                    <c:if test="${mode == 'update'}">
                    	<%-- 현재 대표 이미지(썸네일) 표시 --%>
                        <c:if test="${not empty dto.thumbnail}">
                            <div class="img-wrapper selected" data-type="current_thumbnail" data-filename="${dto.thumbnail }">
                                <img src="<c:url value='/uploads/product/${dto.thumbnail}'/>">
                                <button type="button" class="delete-btn" data-filename="${dto.thumbnail}">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" style="width:16px; height:16px;" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" /></svg>
                                </button>
                            </div>    
                        </c:if>
                        <%-- 추가 이미지들 표시 --%>
                        <c:forEach var="image" items="${imageList}" varStatus="status">
                            <div class="img-wrapper" id="image-wrapper-${image.image_id}" data-type="existing_image" data-filename="${image.filename }" data-image-id="${image.image_id }">
                                <img src="<c:url value='/uploads/product/${image.filename}'/>">
                                <button type="button" class="delete-btn" data-image-id="${image.image_id}" data-filename="${image.filename}">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" style="width:16px; height:16px;" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" /></svg>
                                </button>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
                <input type="hidden" name="thumbnailIndex" id="thumbnailIndex" value="0">
                <input type="hidden" name="newThumbnailFilename" id="newThumbnailFilename" value="${dto.thumbnail}">
			    <input type="hidden" name="oldThumbnailToMove" id="oldThumbnailToMove" value="">
			    <input type="hidden" name="imageIdToPromote" id="imageIdToPromote" value="">
            </div>

            <!-- 2. 핵심 정보 영역 -->
            <div class="mb-3">
                <label for="product_name" class="form-label">상품명</label>
                <input type="text" name="product_name" id="product_name" class="form-control" value="${dto.product_name}" required>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="category_id" class="form-label">카테고리</label>
                    <select name="category_id" id="category_id" class="form-select" required>
                        <option value="">선택</option>
                        <c:forEach var="category" items="${categoryList}">
                            <option value="${category.category_id}" ${dto.category_id == category.category_id ? 'selected' : ''}>${category.category_name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6">
                    <label for="region_id" class="form-label">거래 지역</label>
                    <select name="region_id" id="region_id" class="form-select" required>
                        <option value="">선택</option>
                        <c:forEach var="region" items="${regionList}">
                            <option value="${region.region_id}" ${dto.region_id == region.region_id ? 'selected' : ''}>${region.region_name}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <hr class="my-4">

            <!-- 3. 가격 및 판매 방식 영역 -->
            <div class="mb-3">
                <label class="form-label">판매 방식</label>
                <div>
                    <input type="radio" name="type" id="typeNormal" value="NORMAL" class="form-check-input" ${empty dto.type || dto.type == 'NORMAL' ? 'checked' : ''}>
                    <label for="typeNormal" class="form-check-label me-3">일반 판매</label>
                    <input type="radio" name="type" id="typeAuction" value="AUCTION" class="form-check-input" ${dto.type == 'AUCTION' ? 'checked' : ''}>
                    <label for="typeAuction" class="form-check-label">경매 진행</label>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3" id="price-field">
                    <label for="price" class="form-label">판매 가격</label>
                    <input type="text" name="price" id="price" class="form-control" value="${dto.price}" pattern="^[0-9]+$">
                </div>
                <div class="col-md-6 mb-3" id="start-price-field">
                    <label for="start_price" class="form-label">경매 시작가</label>
                    <input type="number" name="start_price" id="start_price" class="form-control" value="${dto.start_price}">
                </div>
                <div class="col-md-6 mb-3" id="end-time-field">
                    <label for="end_time" class="form-label">경매 마감일</label>
                    <input type="datetime-local" name="end_time" id="end_time" class="form-control" value="${dto.end_time}">
                </div>
            </div>

            <!-- 4. 상세 설명 영역 -->
            <div class="mb-4">
                <label for="content" class="form-label">상세 설명</label>
                <textarea name="content" id="content" class="form-control" rows="8" required>${dto.content}</textarea>
            </div>

            
			<div class="d-flex justify-content-center" style="gap: 0.5rem;">
			    
			    <button type="button" class="btn btn-secondary btn-lg" onclick="history.back();">취소하기</button>

			    <button type="submit" class="btn btn-primary btn-lg">
			        <c:choose>
			            <c:when test="${mode == 'update'}">수정 완료</c:when>
			            <c:otherwise>등록하기</c:otherwise>
			        </c:choose>
			    </button>
			</div>
        </form>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
<script type="text/javascript">
$(function() {
    // --- 전역 변수 ---
    const form = $('form[name="productForm"]');
    const imageContainer = $('#image-container');
    const fileInput = $('#addFiles');
    const mode = "${mode}";
    
	// --- UI 상태 관리 함수 ---
    function updateFormUI() {
        const isAuction = $('#typeAuction').is(':checked');
        $('#price-field').toggle(!isAuction);
        $('#price').prop('disabled', isAuction);
        
        $('#start-price-field, #end-time-field').toggle(isAuction);
        $('#start_price').prop('disabled', !isAuction);
        $('#end_time').prop('disabled', !isAuction);
    }

    $('input[name="type"]').on('change', updateFormUI);
    updateFormUI(); // 페이지 로드 시 초기 상태 설정

    
    let sel_files = []; // 새로 추가된 파일 목록을 관리하는 배열
    let thumbnailFile = null; // '대표 이미지'로 선택된 실제 File 객체를 저장

    // --- 함수: input 태그의 실제 파일 목록 업데이트 ---
    function updateFileInput() {
        const dataTransfer = new DataTransfer();
        sel_files.forEach(file => dataTransfer.items.add(file));
        fileInput[0].files = dataTransfer.files;
    }
    
    // --- 함수: 특정 미리보기를 대표로 지정 ---
    function selectThumbnail(wrapperElement) {
        imageContainer.find('.img-wrapper').removeClass('selected');
        wrapperElement.addClass('selected');

        if (mode === 'update') {
            // 수정 모드: 파일명을 hidden input에 저장
	            const imageType = wrapperElement.data('type');
        		const currentThumbnail = "${dto.thumbnail}";
        		const isThumbnailWillDelete = $(`input[name="deleteFilename"][value="\${currentThumbnail}"]`).length > 0;
	
	            if (imageType === 'current_thumbnail') {
		            // 현재 썸네일을 그대로 대표 이미지로 유지
		            const filename = wrapperElement.data('filename');
		            $('#newThumbnailFilename').val(filename);
		            $('#oldThumbnailToMove').val('');
		            $('#imageIdToPromote').val('');
	
	            } else if (imageType === 'existing_image') {
	
		            // 기존에 있던 추가 이미지로 대표 이미지를 변경
		            const imageId = wrapperElement.data('image-id');
		            const filename = wrapperElement.data('filename');
		            $('#newThumbnailFilename').val(filename);
		            $('#imageIdToPromote').val(imageId);
					
		            if(isThumbnailWillDelete) {
		            	$('#oldThumbnailToMove').val('');
		            } else {
		            	$('#oldThumbnailToMove').val(currentThumbnail);
		            }
		            
	            } else if(imageType === 'new_image') {
	            	// 새로 첨부한 이미지를 대표 이미지로 설정
	                const fileIdentifier = wrapperElement.data('identifier');
	                const file = sel_files.find(f => (f.name + f.lastModified) === fileIdentifier);
	                
	                if (file) {
	                    $('#newThumbnailFilename').val(file.name); // 새 파일명을 썸네일로 설정
	                    $('#imageIdToPromote').val(''); 
	                    
	                    if(isThumbnailWillDelete) {
	                    	$('#oldThumbnailToMove').val('');
	                    } else {
	                    	$('#oldThumbnailToMove').val(currentThumbnail);
	                    }
	                    
	                    thumbnailFile = file;
                   }
                }
	            
    	} else {
    		// 등록 모드: 선택된 File 객체를 변수에 저장
            const fileIdentifier = wrapperElement.data('identifier');
            thumbnailFile = sel_files.find(f => (f.name + f.lastModified) === fileIdentifier);
    	}
        
    }
        
  
    // --- 이벤트 핸들러 ---

    // 1. 새 파일 선택 시: 미리보기 생성
    fileInput.on('change', function(e) {
        imageContainer.find('.new-preview').remove();
        sel_files = Array.from(e.target.files || []);
        
        const hasThumbnail = imageContainer.find('.img-wrapper.selected').length > 0;
        
        if(!hasThumbnail) {
	        thumbnailFile = sel_files.length > 0 ? sel_files[0] : null; // 첫 파일을 기본 대표로 지정    	
        }
        

        $.each(sel_files, function(i, file) {
            if (!file.type.match('image.*')) return;
            const fileIdentifier = file.name + file.lastModified;

            const reader = new FileReader();
            reader.onload = function(event) {
                const imgWrapper = $('<div class="img-wrapper new-preview"></div>')
                    .data('type', 'new_image').data('identifier', fileIdentifier);
                const img = $('<img>').attr('src', event.target.result);
                const deleteBtn = $('<button type="button" class="delete-btn"><svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" style="width:16px; height:16px;" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" /></svg></button>');
                
                imgWrapper.append(img).append(deleteBtn);
                imageContainer.append(imgWrapper);

                if ((mode !== 'update' || !hasThumbnail) && i === 0) { // 첫 이미지를 시각적으로 '선택됨' 표시
                    selectThumbnail(imgWrapper);
                }
            };
            reader.readAsDataURL(file);
        });
    });

    // 2. 이미지 클릭 시: 대표 이미지로 선택
    imageContainer.on('click', '.img-wrapper', function(e) {
        if ($(e.target).closest('.delete-btn').length > 0) return;
        selectThumbnail($(this));
    });

    // 3. 삭제 버튼 클릭 시
    imageContainer.on('click', '.delete-btn', function(e) {
        e.stopPropagation();
        if (!confirm('이 이미지를 삭제하시겠습니까?')) return;

        const wrapper = $(this).closest('.img-wrapper');
        const wasSelected = wrapper.hasClass('selected');
        
        if (wrapper.data('type') === 'new_image') {
            // 새로 추가된 미리보기 삭제
            const fileIdentifier = wrapper.data('identifier');
            sel_files = sel_files.filter(f => (f.name + f.lastModified) !== fileIdentifier);
            updateFileInput();
        } else if (wrapper.data('type') === 'current_thumbnail') {
        	const filename = wrapper.data('filename');
        	if(filename !== undefined) {
        		form.append('<input type="hidden" name="deleteFilename" value="' + filename + '">');
        	} 
        } else {
            // 기존 이미지 삭제 (삭제 예약)
            const imageId = wrapper.data('image-id');
            const filename = wrapper.data('filename');
            
            if(imageId !== undefined && filename !== undefined) {

            	form.append('<input type="hidden" name="deleteImageIds" value="' + imageId + '">');
	            form.append('<input type="hidden" name="deleteFilename" value="' + filename + '">');
            }
        }
        
        wrapper.remove(); // 공통: 화면에서 제거

        // 삭제된 이미지가 대표였다면, 남은 이미지 중 첫 번째를 새 대표로 지정
        if (wasSelected) {
             const firstRemaining = imageContainer.find('.img-wrapper').first();
             if (firstRemaining.length > 0) {
                selectThumbnail(firstRemaining);
             } else {
                thumbnailFile = null; // 남은 이미지 없으면 대표도 없음
             }
        }
    });
    
    // 4. 폼 제출 직전: 최종 썸네일 인덱스 계산
    form.on('submit', function(e) {
    	
    	// 이미지 유효성 검사
    	const totalImages = imageContainer.find('.img-wrapper').length;
    	
    	if(totalImages === 0) {
    		e.preventDefault();
    		alert('상품 이미지를 등록해 주세요');
    		return false;
    	}
    	
        if (mode !== 'update') {
            let thumbnailIndex = 0;
            if (thumbnailFile) {
                // 최종 파일 목록에서, 대표로 지정된 파일이 몇 번째인지 찾음
                thumbnailIndex = sel_files.findIndex(f => (f.name + f.lastModified) === (thumbnailFile.name + thumbnailFile.lastModified));
                if (thumbnailIndex === -1) thumbnailIndex = 0; // 혹시 못찾으면 0번
            }
            $('#thumbnailIndex').val(thumbnailIndex);
        } else {
        	
        	const selectedWrapper = imageContainer.find('.img-wrapper.selected');
        	
        	if(selectedWrapper.length > 0 && selectedWrapper.data('type') === 'new_image') {
				// 새로 추가된 이미지가 썸네일로 선택된 경우        		
	        	if(thumbnailFile && sel_files.length > 0) {
	        		let thumbnailIndex = sel_files.findIndex(f => (f.name + f.lastModified) === (thumbnailFile.name + thumbnailFile.lastModified));
	        		if(thumbnailIndex !== -1) {
	        			$('#thumbnailIndex').val(thumbnailIndex);
	        		}
	        	}
        	} else {
        		$('#thumbnailIndex').val(-1);
        	}
        	
        }
        
    });

   
});
</script>
    </body>
</html>