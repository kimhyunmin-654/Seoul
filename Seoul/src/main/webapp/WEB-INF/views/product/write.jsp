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
    <script>
    $(function() {
    	
    	// --- 이미지 클릭으로 대표 이미지 선택 ---
    	$('#image-container').on('click', '.img-wrapper', function(e) {
    	    // 삭제 버튼 클릭 시에는 선택 이벤트 무시
    	    if ($(e.target).hasClass('delete-btn') || $(e.target).closest('.delete-btn').length > 0) {
    	        return;
    	    }
    	    
    	    // 모든 이미지에서 selected 클래스 제거
    	    $('.img-wrapper').removeClass('selected');
    	    
    	    // 클릭된 이미지에 selected 클래스 추가
    	    $(this).addClass('selected');
    	    
    	    // 선택된 이미지 정보 가져오기
    	    const imageType = $(this).data('type');
    	    const filename = $(this).data('filename');
    	    const imageId = $(this).data('image-id');
    	    
    	    console.log('선택된 대표 이미지:', imageType, filename);
    	    
    	    if (imageType === 'current_thumbnail') {
    	        // 현재 썸네일을 대표로 유지
    	        $('#newThumbnailFilename').val(filename);
    	        $('#oldThumbnailToMove').val('');
    	        $('#imageIdToPromote').val('');
    	    } else if (imageType === 'existing_image') {
    	        // 기존 추가 이미지를 대표로 선택
    	        const currentThumbnail = '${dto.thumbnail}';
    	        
    	        $('#newThumbnailFilename').val(filename);
    	        $('#oldThumbnailToMove').val(currentThumbnail);
    	        $('#imageIdToPromote').val(imageId);
    	    }
    	});
    	
    	
    	
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

        // --- 새로 추가할 이미지 미리보기 ---
        $('#addFiles').on('change', function(e) {
            $('.img-wrapper.new-preview').remove();
            const files = e.target.files;
            if (!files) return;

            $.each(files, function(i, file) {
                if (!file.type.match('image.*')) return;
                
                const reader = new FileReader();
                reader.onload = function(event) {
                    const imgWrapper = $('<div class="img-wrapper new-preview" data-type="new_image" data-filename="new_' + i + '"></div>');
                    const img = $('<img>').attr('src', event.target.result);
                    imgWrapper.append(img);
                    $('#image-container').append(imgWrapper);
                };
                reader.readAsDataURL(file);
            });
        });

        // --- 수정 시, 기존 이미지 삭제 예약 및 대표 이미지 선택상태 갱신 ---
        $('#image-container').on('click', '.delete-btn', function(e) {
        	e.stopPropagation();
        	
            if (!confirm('이 이미지를 삭제하시겠습니까?')) return;

            const imageId = $(this).data('image-id');
            const filename = $(this).data('filename');
            const form = $('form[name="productForm"]');
            const wrapper = $(this).closest('.img-wrapper');
            
            // 삭제될 이미지가 현재 선택된 대표 이미지인지 확인
			if(wrapper.hasClass('selected')) {
				wrapper.removeClass('selected');
            
	            const firstRemaining = $('.img-wrapper:visible').not(wrapper).first();
	            
	            if(firstRemaining.length > 0) {
	            	firstRemaining.addClass('selected').trigger('click');
	            }
            
			}
            
          	wrapper.hide();

            form.append(`<input type="hidden" name="deleteImageIds" value="\${imageId}">`);
            form.append(`<input type="hidden" name="deleteFilename" value="\${filename}">`);
        });
        
        $(document).ready(function() {
            const currentThumbnailWrapper = $('.img-wrapper[data-type="current_thumbnail"]');
            if (currentThumbnailWrapper.length > 0) {
                currentThumbnailWrapper.addClass('selected');
                $('#newThumbnailFilename').val(currentThumbnailWrapper.data('filename'));
            }
        });
         
    });
    </script>
</body>
</html>