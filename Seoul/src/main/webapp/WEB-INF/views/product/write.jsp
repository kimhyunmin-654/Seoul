<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 물건 팔기</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container { max-width: 800px; }
        .form-label { font-weight: 600; }
        #auction-fields {
            background-color: #fff8e1;
            border: 1px solid #ffecb3;
            border-radius: 8px;
            padding: 1.5rem;
            margin-top: 1rem;
        }
    </style>
</head>
<body>
    <div class="container my-5">
        <h2 class="text-center mb-4">어떤 물건을 판매하시나요? 📦</h2>

        <form name="productForm" action="<c:url value='/product/write'/>" method="post" enctype="multipart/form-data">
            
            <div class="mb-3">
                <label for="product_name" class="form-label">상품명</label>
                <input type="text" class="form-control" id="product_name" name="product_name" required placeholder="상품의 이름을 알려주세요">
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="category_id" class="form-label">카테고리</label>
                    <select class="form-select" id="category_id" name="category_id" required>
                        <option value="">카테고리 선택</option>
                        <option value="1">디지털기기</option>
                        <%-- 컨트롤러에서 categoryList를 받아와 동적으로 생성 --%>
                    </select>
                </div>
                <div class="col-md-6">
                    <label for="region_id" class="form-label">거래 지역</label>
                    <select class="form-select" id="region_id" name="region_id" required>
                        <option value="">지역 선택</option>
                        <option value="R001">강남구</option>
                    </select>
                </div>
            </div>
            
            <div class="mb-3">
                 <label for="price" class="form-label">판매 가격 (일반 판매 시)</label>
                 <input type="number" class="form-control" id="price" name="price" placeholder="판매할 가격(원)을 입력하세요">
            </div>

            <div class="mb-3">
                <label for="content" class="form-label">상세 설명</label>
                <textarea class="form-control" id="content" name="content" rows="8" required placeholder="구매자가 궁금해할 만한 상품의 상태, 특징 등을 자세히 적어주세요."></textarea>
            </div>

            <div class="mb-3">
                <label for="selectFile" class="form-label">상품 이미지 (첫 번째가 대표 이미지)</label>
                <input type="file" class="form-control" id="selectFile" name="selectFile" multiple>
            </div>

            <hr class="my-4">

            <div class="mb-3">
                <label class="form-label">판매 방식</label>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="type" id="typeNormal" value="NORMAL" checked>
                    <label class="form-check-label" for="typeNormal">
                        일반 판매
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="type" id="typeAuction" value="AUCTION">
                    <label class="form-check-label" for="typeAuction">
                        경매 진행 🔨
                    </label>
                </div>
            </div>

            <div id="auction-fields" style="display: none;">
                <h4 class="mb-3">🔨 경매 정보 입력</h4>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="start_price" class="form-label">경매 시작가</label>
                        <input type="number" class="form-control" id="start_price" name="start_price" placeholder="경매를 시작할 가격을 입력하세요">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="end_time" class="form-label">경매 마감일</label>
                        <input type="datetime-local" class="form-control" id="end_time" name="end_time">
                    </div>
                </div>
            </div>

            <div class="d-grid gap-2 mt-4">
                <button type="submit" class="btn btn-primary btn-lg">판매 등록하기</button>
            </div>
            
        </form>
    </div>

    <script>
	    document.addEventListener('DOMContentLoaded', function() {
	        const form = document.querySelector('form[name="productForm"]');
	        const radioButtons = document.querySelectorAll('input[name="type"]');
	        const auctionFieldsDiv = document.getElementById('auction-fields');
	        const startPriceInput = document.getElementById('start_price');
	        const endTimeInput = document.getElementById('end_time');
	        const priceInput = document.getElementById('price');
	
	        function toggleAuctionFields(isAuction) {
	            if (isAuction) {
	                // 경매 선택: 필드를 보이고, 활성화
	                auctionFieldsDiv.style.display = 'block';
	                startPriceInput.disabled = false;
	                endTimeInput.disabled = false;
	
	                // 경매 선택 시 일반 가격 필드는 비활성화 (선택 사항)
	                priceInput.disabled = true;
	
	            } else {
	                // 일반 선택: 필드를 숨기고, 비활성화
	                auctionFieldsDiv.style.display = 'none';
	                startPriceInput.disabled = true;
	                endTimeInput.disabled = true;
	
	                // 일반 선택 시 일반 가격 필드는 활성화
	                priceInput.disabled = false;
	            }
	        }
	
	        // 라디오 버튼 변경 시 함수 호출
	        radioButtons.forEach(function(radio) {
	            radio.addEventListener('change', function() {
	                toggleAuctionFields(this.value === 'AUCTION');
	            });
	        });
	
	        // 페이지 로드 시 초기 상태 설정
	        const initialType = document.querySelector('input[name="type"]:checked').value;
	        toggleAuctionFields(initialType === 'AUCTION');
	
	        // 폼 제출 전 마지막 정리 (선택 사항이지만 안전함)
	        form.addEventListener('submit', function(event) {
	            const selectedType = document.querySelector('input[name="type"]:checked').value;
	            if (selectedType === 'NORMAL') {
	                // 일반 판매 시 경매 필드 값이 남아있을 수 있으니 비워줌
	                startPriceInput.value = '';
	                endTimeInput.value = '';
	            } else { // AUCTION
	                priceInput.value = '';
	            }
	        });
	    });
	</script>
</body>
</html>