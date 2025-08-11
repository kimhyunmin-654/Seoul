<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${dto.product_name} - 서울한바퀴</title>
    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f3f4f6; } /* 밝은 회색 배경 */
        .glass-pane { 
            background: white;
            border: 1px solid #e5e7eb; /* 연한 회색 테두리 */
        }
        .glow-button { 
             box-shadow: 0 4px 15px rgba(251, 146, 60, 0.3);
        }
    </style>
</head>
<body class="text-gray-800">

    <div class="container mx-auto max-w-7xl p-4 sm:p-6 lg:p-8">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            
            <div class="lg:col-span-2 flex flex-col gap-8">
                <div class="relative aspect-square bg-gray-200 rounded-2xl shadow-lg overflow-hidden group">
                    <div id="image-carousel" class="flex transition-transform duration-500 ease-in-out h-full">
                        <%-- 썸네일 이미지를 첫 번째로 표시 --%>
                        <img src="<c:url value='/uploads/product/${dto.thumbnail}'/>" alt="${dto.product_name}" class="w-full h-full object-cover flex-shrink-0">
                        
                        <%-- 추가 이미지가 있다면 반복문으로 표시 --%>
                        <c:forEach var="image" items="${listFile}">
                            <img src="<c:url value='/uploads/product/${image.filename}'/>" alt="${dto.product_name} 추가 이미지" class="w-full h-full object-cover flex-shrink-0">
                        </c:forEach>
                    </div>
                    <button id="prev-btn" class="absolute top-1/2 left-4 -translate-y-1/2 bg-black/30 hover:bg-black/50 p-3 rounded-full text-white transition-opacity duration-300 opacity-0 group-hover:opacity-100">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" /></svg>
                    </button>
                    <button id="next-btn" class="absolute top-1/2 right-4 -translate-y-1/2 bg-black/30 hover:bg-black/50 p-3 rounded-full text-white transition-opacity duration-300 opacity-0 group-hover:opacity-100">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" /></svg>
                    </button>
                </div>
                
                <div class="glass-pane p-6 rounded-2xl shadow-lg">
                    <h2 class="text-2xl font-bold text-gray-900 mb-4">상품 상세 정보</h2>
                    <div class="prose max-w-none text-gray-600">
                        <p><c:out value="${dto.content}" escapeXml="false"/></p>
                    </div>
                </div>
            </div>

            <div class="flex flex-col space-y-6">
                <div class="glass-pane p-6 rounded-2xl shadow-lg">
                    <div class="text-sm text-gray-500">${dto.category_name} ・ ${dto.region_name}</div>
                    <h1 class="text-3xl font-bold text-gray-900 leading-tight mt-2">${dto.product_name}</h1>
                    <div class="flex items-center mt-4 space-x-3">
                        <img src="<c:url value='/uploads/member/${dto.sellerAvatar}'/>" alt="판매자 아바타" class="w-10 h-10 rounded-full">
                        <div>
                            <div class="font-semibold text-gray-800">${dto.nickName}</div>
                            <div class="text-sm text-gray-500">매너온도 등급</div>
                        </div>
                    </div>
                </div>

                <div class="glass-pane p-6 rounded-2xl flex flex-col flex-grow">
                    <%-- 가격 표시 --%>
                    <div class="mb-6">
                        <p class="text-sm font-medium text-gray-500">판매 가격</p>
                        <p class="text-5xl font-bold text-orange-600 my-2">
                            <fmt:formatNumber value="${dto.price}" pattern="#,##0"/>원
                        </p>
                    </div>
                    
                    <%-- 액션 버튼 --%>
                    <div class="mt-auto space-y-3">
                        <button type="button" class="w-full bg-white hover:bg-orange-50 text-orange-600 font-bold text-lg py-4 rounded-lg border-2 border-orange-500 transition-colors">
                            🤍 찜하기
                        </button>
                        <button type="button" class="w-full bg-orange-500 hover:bg-orange-600 text-white font-bold text-lg py-4 rounded-lg transition-all duration-300 transform hover:scale-105 glow-button">
                            채팅하기
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
	<div id="product-template">
	<input type="hidden" id="web-contextPath" value="${pageContext.request.contextPath}">
	<input type="hidden" id="product-productNum" value="${dto.product_id}">
	<input type="hidden" id="product-productName" value="${dto.product_name}">
	<input type="hidden" id="product-price" value="${dto.price}">
	<input type="hidden" id="product-thumbnail" value="${dto.thumbnail}">	
	</div>
	
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // 이미지 캐러셀 로직
            const carousel = document.getElementById('image-carousel');
            if(carousel) {
                const prevBtn = document.getElementById('prev-btn');
                const nextBtn = document.getElementById('next-btn');
                const images = carousel.querySelectorAll('img');
                const imageCount = images.length;
                let currentIndex = 0;

                if (imageCount > 1) {
                    function updateCarousel() {
                        carousel.style.transform = `translateX(-\${currentIndex * 100}%)`;
                    }
                    nextBtn.addEventListener('click', () => {
                        currentIndex = (currentIndex + 1) % imageCount;
                        updateCarousel();
                    });
                    prevBtn.addEventListener('click', () => {
                        currentIndex = (currentIndex - 1 + imageCount) % imageCount;
                        updateCarousel();
                    });
                } else {
                     prevBtn.style.display = 'none';
                     nextBtn.style.display = 'none';
                }
            }
        });
    </script>

<footer>
	
</footer>

</body>
</html>