<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${dto.product_name}-서울한바퀴</title>
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
<jsp:include page="/WEB-INF/views/layout/header.jsp" />
<script src="https://cdn.tailwindcss.com"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap"
	rel="stylesheet">
<style>
body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #f3f4f6;
} 
.glass-pane {
	background: white;
	border: 1px solid #e5e7eb; 
}

.glow-button {
	box-shadow: 0 4px 15px rgba(251, 146, 60, 0.3);
}

#prev-btn, #next-btn {
	background-color: rgba(0, 0, 0, 0.3); 
	border-radius: 9999px; 
	color: white;
	transition: background-color 0.2s; 
}


#prev-btn:hover, #next-btn:hover {
	background-color: rgba(0, 0, 0, 0.5);
}
</style>
</head>
<body class="text-gray-800">

	<div class="container mx-auto max-w-7xl p-4 sm:p-6 lg:p-8">
		<div class="grid grid-cols-1 lg:grid-cols-4 gap-6">

			<aside class="col-span-1">
				<div class="sticky top-8">
					<jsp:include page="/WEB-INF/views/layout/leftProduct.jsp" />
				</div>
			</aside>

			<main class="col-span-1 lg:col-span-3">
				<div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

					<div class="lg:col-span-2 flex flex-col gap-8">
						<div
							class="relative aspect-square bg-gray-200 rounded-2xl shadow-lg overflow-hidden group">
							<div id="image-carousel"
								class="flex transition-transform duration-500 ease-in-out h-full">
								
								<img src="<c:url value='/uploads/product/${dto.thumbnail}'/>"
									alt="${dto.product_name}"
									class="w-full h-full object-cover flex-shrink-0">

								
								<c:forEach var="image" items="${listFile}">
									<img src="<c:url value='/uploads/product/${image.filename}'/>"
										alt="${dto.product_name} 추가 이미지"
										class="w-full h-full object-cover flex-shrink-0">
								</c:forEach>
							</div>
							<button id="prev-btn"
								class="absolute top-1/2 left-4 -translate-y-1/2 bg-black/30 hover:bg-black/50 p-3 rounded-full text-white z-10">
								<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6"
									fill="none" viewBox="0 0 24 24" stroke="currentColor">
									<path stroke-linecap="round" stroke-linejoin="round"
										stroke-width="2" d="M15 19l-7-7 7-7" /></svg>
							</button>
							<button id="next-btn"
								class="absolute top-1/2 right-4 -translate-y-1/2 bg-black/30 hover:bg-black/50 p-3 rounded-full text-white z-10">
								<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6"
									fill="none" viewBox="0 0 24 24" stroke="currentColor">
									<path stroke-linecap="round" stroke-linejoin="round"
										stroke-width="2" d="M9 5l7 7-7 7" /></svg>
							</button>
						</div>

						<div class="glass-pane p-6 rounded-2xl shadow-lg">
							<h2 class="text-2xl font-bold text-gray-900 mb-4">상품 상세 정보</h2>
							<div class="prose max-w-none text-gray-600">
								<p>
									<c:out value="${dto.content}" escapeXml="false" />
								</p>
							</div>
						</div>
					</div>

					<div class="flex flex-col space-y-6">
						<div class="glass-pane p-6 rounded-2xl shadow-lg">
							<div class="text-sm text-gray-500">${dto.category_name}・
								${dto.region_name}</div>
							<h1 class="text-3xl font-bold text-gray-900 leading-tight mt-2">${dto.product_name}</h1>
							<div class="flex items-center mt-4 space-x-3">							
							<a href="<c:url value='/member/prolist?member_id=${dto.member_id}'/>">
								<img src="<c:url value='/uploads/member/${dto.sellerAvatar}'/>"
									alt="판매자 아바타" class="w-10 h-10 rounded-full">
							</a>
									
									
								<div>
									<div class="font-semibold text-gray-800">${dto.nickName}</div>
									<div class="text-sm text-gray-500">매너온도 등급</div>
								</div>
							</div>
							<div
								class="mt-4 pt-4 border-t border-gray-200 flex items-center space-x-4 text-sm text-gray-500">
								<span>조회 ${dto.hitCount}</span> <span> ・ </span> <span>찜
									${dto.likeCount}</span>
							</div>
						</div>

						<div class="glass-pane p-6 rounded-2xl flex flex-col flex-grow">
							
							<div class="relative">
								<div class="mb-6">
									<p class="text-sm font-medium text-gray-500">판매 가격</p>
									<p class="text-5xl font-bold text-orange-600 my-2">
										<fmt:formatNumber value="${dto.price}" pattern="#,##0" />
										원
									</p>
								</div>
								
								<div class="absolute top-0 right-0">
									<button id="more-menu-btn"
										class="p-2 rounded-full hover:bg-gray-100">
										<svg xmlns="http://www.w3.org/2000/svg"
											class="h-6 w-6 text-gray-500" fill="none" viewBox="0 0 24 24"
											stroke="currentColor">
                  							<path stroke-linecap="round" stroke-linejoin="round"
												stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01" />
                						</svg>
									</button>

									
									<div id="more-menu-dropdown"
										class="hidden absolute right-0 mt-2 w-48 bg-white rounded-md shadow-xl z-20">
										<div class="py-1">
											<c:choose>
												
												<c:when
													test="${sessionScope.member.member_id == dto.member_id}">
													<a href="<c:url value='/product/update?product_id=${dto.product_id}'/>"
														class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">수정하기</a>

													<form action="<c:url value='/product/delete'/>"
														method="post"
														onsubmit="return confirm('정말 상품을 삭제하시겠습니까?');">
														<input type="hidden" name="product_id"
															value="${dto.product_id}">
														<button type="submit"
															class="w-full text-left block px-4 py-2 text-sm text-red-600 hover:bg-gray-100">삭제하기</button>
													</form>
												</c:when>

												
												<c:otherwise>
													<a href="#"
														class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">신고하기</a>
												</c:otherwise>
											</c:choose>
										</div>
									</div>
								</div>
							</div>
							
							<div class="mt-auto space-y-3">
								<c:choose>
								    <c:when test="${isLiked}">
								        <button type="button" id="like-btn" 
								                class="w-full bg-orange-600 text-white font-bold text-lg py-4 rounded-lg transition-colors">
								            ❤️ 찜취소
								        </button>
								    </c:when>
								    <c:otherwise>
								        <button type="button" id="like-btn" 
								                class="w-full bg-white hover:bg-orange-50 text-orange-600 font-bold text-lg py-4 rounded-lg border-2 border-orange-500 transition-colors">
								            🤍 찜하기
								        </button>
								    </c:otherwise>
								</c:choose>
							<c:if test="${empty sessionScope.member or sessionScope.member.member_id != dto.member_id}">
							  <button type="button"
							          class="w-full bg-orange-500 hover:bg-orange-600 text-white font-bold text-lg py-4 rounded-lg transition-all duration-300 transform hover:scale-105 glow-button btn-open-chat"
							          data-product-id="${dto.product_id}"
							          data-seller-id="${dto.member_id}"
							          data-seller-nick="${dto.nickName}">
							    채팅하기
							  </button>
							</c:if>
							</div>
						</div>
					</div>
				</div>
			</main>
		</div>
	</div>

	<div id="product-template">
		<input type="hidden" id="web-contextPath"
			value="${pageContext.request.contextPath}"> <input
			type="hidden" id="product-productNum" value="${dto.product_id}">
		<input type="hidden" id="product-productName"
			value="${dto.product_name}"> <input type="hidden"
			id="product-price" value="${dto.price}"> <input type="hidden"
			id="product-thumbnail" value="${dto.thumbnail}">
	</div>
	
	<script>
		(function() {
	        const message = "${message}";
	        const messageId = "${messageId}";
	
	        if (message && messageId) {
	            
	            if (!sessionStorage.getItem(messageId)) {
	                alert(message);
	                sessionStorage.setItem(messageId, 'shown');
	            }
	        }
	    })();
	</script>
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
        
        $(function() {
        	
        	 const moreMenuBtn = $('#more-menu-btn');
             const moreMenuDropdown = $('#more-menu-dropdown');

             
             moreMenuBtn.on('click', function(event) {
                 event.stopPropagation(); 
                 moreMenuDropdown.toggleClass('hidden');
             });

            
             $(document).on('click', function() {
                 if (!moreMenuDropdown.hasClass('hidden')) {
                     moreMenuDropdown.addClass('hidden');
                 }
             });
             
             // 찜하기 버튼 클릭 이벤트
             const likeBtn = $('#like-btn');
             const productId = "${dto.product_id}";
             const likeCountSpan = $('#like-count');
             
             let isLiked = '${isLiked}' === 'true';

             
             
             function updateLikeButtonUI() {
                 if (isLiked) {
                     likeBtn.html('❤️ 찜취소');
                     likeBtn.removeClass('bg-white text-orange-600 border-orange-500').addClass('bg-orange-600 text-white');
                 } else {
                     likeBtn.html('🤍 찜하기');
                     likeBtn.removeClass('bg-orange-600 text-white').addClass('bg-white text-orange-600 border-orange-500');
                 }
             }

             updateLikeButtonUI();

             likeBtn.on('click', function() {
                 const url = isLiked ? '${pageContext.request.contextPath}/productLike/deleteProductLike' : '${pageContext.request.contextPath}/productLike/insertProductLike';
                 
                 $.ajax({
                     url: url,
                     type: 'POST',
                     data: {
                         product_id: productId
                     },
                     dataType: 'json',
                     success: function(data) {
                         if (data.state === 'login_required') {
                             alert('찜하기는 로그인 후 이용 가능합니다.');
                             return;
                         }

                         if (data.state === 'true') {
                             isLiked = !isLiked;
                             const currentCount = parseInt(likeCountSpan.text());
                             if (isLiked) {
                                 likeCountSpan.text(currentCount + 1);
                             } else {
                                 likeCountSpan.text(currentCount > 0 ? currentCount - 1 : 0);
                             }
                             updateLikeButtonUI();
                         }
                     },
                     error: function(xhr, status, error) {
                         console.error("찜하기 요청 실패: " + status, error);
                         alert("찜하기 기능에 오류가 발생했습니다.");
                     }
                 });
             });
        	
        	
        });     
    </script>

<script>
    const ctx = '${pageContext.request.contextPath}';
</script>     
<script src="${pageContext.request.contextPath}/dist/js/detailchat.js"></script> 
<script src="${pageContext.request.contextPath}/dist/js/leftProduct.js"></script>

</body>
</html>