<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 목록</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
    <style>
        .aspect-square { aspect-ratio: 1 / 1; }
    </style>
</head>
<body class="bg-gray-100">

        <header>	
		    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
        </header>
        
        
    	<div class="container mx-auto max-w-7xl p-4 sm:p-6 lg:p-8">
            
            <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
            	
            	<aside class="col-span-1 sidebar">
			        <div class="sidebar-sticky">
			          <jsp:include page="/WEB-INF/views/layout/left.jsp"/>
			        </div>
			    </aside>
            
          
            <main class="col-span-1 lg:col-span-3">
            	<header class="mb-8">
		            <h1 class="text-3xl font-bold text-gray-900">우리 동네 상품</h1>
	    	        <p class="text-gray-600 mt-1">이웃들의 새로운 상품을 만나보세요.</p>    	        	
            	</header>
            

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-3 gap-6" id="product-grid">
            <c:forEach var="dto" items="${list}">
                <div class="card-container">
                    <a href="<c:url value='/product/detail?product_id=${dto.product_id}'/>" class="block bg-white rounded-lg shadow-md overflow-hidden transform hover:-translate-y-1 hover:shadow-xl transition-all duration-300">
                        <div class="aspect-square w-full overflow-hidden">
                            <img src="<c:url value='/uploads/product/${dto.thumbnail}'/>" alt="${dto.product_name}" class="w-full h-full object-cover">
                        </div>
                        <div class="p-4">
                            <h2 class="text-lg font-semibold text-gray-800 truncate" style="margin-bottom: 8px;">${dto.product_name}</h2>
                            <p class="text-xl font-bold text-gray-900" style="margin-bottom: 8px;">
                                <fmt:formatNumber value="${dto.price}" pattern="#,##0"/>원
                            </p>
                            <p class="text-sm text-gray-500 truncate" style="margin-bottom: 12px;">${dto.region_name}</p>
                             <div class="flex items-center text-sm text-gray-500 border-t pt-3 mt-3 like-button" data-product-id="${dto.product_id}">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
                                  <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
                                </svg>
                                <span class="like-count">${dto.likeCount}</span>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>

            <c:if test="${empty list}">
                <div class="col-span-full text-center py-12">
                    <p class="text-gray-500">아직 등록된 상품이 없습니다.</p>
                </div>
            </c:if>
        </div>
		
        <div class="mt-12 text-center">
            <c:if test="${page < totalPage}">
                 <button type="button" id="load-more-btn" class="bg-white hover:bg-gray-100 text-gray-800 font-semibold py-3 px-8 border border-gray-300 rounded-lg shadow-md">
                    더보기
                </button>
            </c:if>
         </div>
       </main>  
     </div>
   </div>
 	<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"></jsp:include>
 	<jsp:include page="/WEB-INF/views/layout/leftResources.jsp"></jsp:include>
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
<script src="${pageContext.request.contextPath }/dist/js/util-jquery.js"></script>
<script>
    $(function() {
		
        let currentPage = parseInt("${page}");
        let currentKwd = "${cond.kwd}";
        let currentCategoryId = "${cond.category_id}";
       	let currentRegionId = "${cond.region_id}";
        let currentType = "${cond.type}";
        
        let url = '/product/list/ajax';
        let searchEl = $('.searchbar input[name=kwd]');
    	
        const productGrid = $('#product-grid');
        const loadMoreBtn = $('#load-more-btn');
        
        // '더보기' 요청
        function loadMore() {
        	
        	
        	currentPage++;
        	
            const params = {
                page: currentPage,
                kwd: currentKwd,
                category_id: currentCategoryId,
                region_id: currentRegionId,
                type: currentType
            };
            
            const callback = function(data) {
            	if (data.list && data.list.length > 0) {
                    let cardHtml = '';
                    
                    $.each(data.list, function(index, product) {
                        cardHtml += `
                            <div class="card-container">
                                <a href="/product/detail?product_id=\${product.product_id}" class="block bg-white rounded-lg shadow-md overflow-hidden transform hover:-translate-y-1 hover:shadow-xl transition-all duration-300">
                                    <div class="aspect-square w-full overflow-hidden">
                                        <img src="/uploads/product/\${product.thumbnail}" alt="\${product.product_name}" class="w-full h-full object-cover">
                                    </div>
                                    <div class="p-4">
                                        <h2 class="text-lg font-semibold text-gray-800 truncate" style="margin-bottom: 8px;">\${product.product_name}</h2>
                                        <p class="text-xl font-bold text-gray-900" style="margin-bottom: 8px;">
                                            \${new Intl.NumberFormat('ko-KR').format(product.price)}원
                                        </p>
                                        <p class="text-sm text-gray-500 truncate" style="margin-bottom: 12px;">\${product.region_name}</p>
                                        <div class="flex items-center text-sm text-gray-500 border-t pt-3 mt-3">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
                                              <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
                                            </svg>
                                            <span>\${product.likeCount}</span>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        `;
                    });
                    
                    productGrid.append(cardHtml);
            }
            	
	           	if (currentPage >= data.totalPage) {
	                   loadMoreBtn.hide();
	               }
        	
        };
        
        ajaxRequest(url, 'GET', params, 'json', callback);
    };
        
        // '검색 필터링' 요청
        function applyFilter() {
        	currentPage = 1;
        	
        	const params = {
       			page: currentPage,
                kwd: currentKwd,
                category_id: currentCategoryId,
                region_id: currentRegionId,
                type: currentType
        	};
        	
        	const callback = function(data) {
        		productGrid.empty();
        		if(data.list && data.list.length > 0) {
					let cardHtml = '';
                    
                    $.each(data.list, function(index, product) {
                        cardHtml += `
                            <div class="card-container">
                                <a href="/product/detail?product_id=\${product.product_id}" class="block bg-white rounded-lg shadow-md overflow-hidden transform hover:-translate-y-1 hover:shadow-xl transition-all duration-300">
                                    <div class="aspect-square w-full overflow-hidden">
                                        <img src="/uploads/product/\${product.thumbnail}" alt="\${product.product_name}" class="w-full h-full object-cover">
                                    </div>
                                    <div class="p-4">
                                        <h2 class="text-lg font-semibold text-gray-800 truncate" style="margin-bottom: 8px;">\${product.product_name}</h2>
                                        <p class="text-xl font-bold text-gray-900" style="margin-bottom: 8px;">
                                            \${new Intl.NumberFormat('ko-KR').format(product.price)}원
                                        </p>
                                        <p class="text-sm text-gray-500 truncate" style="margin-bottom: 12px;">\${product.region_name}</p>
                                        <div class="flex items-center text-sm text-gray-500 border-t pt-3 mt-3">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
                                              <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
                                            </svg>
                                            <span>\${product.likeCount}</span>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        `;
                    });
                    
                    productGrid.append(cardHtml);
        		}
        		
        		if (currentPage >= data.totalPage) {
        			loadMoreBtn.hide();
        		} else {
        			loadMoreBtn.show();
        		}
        	};
        	
        	ajaxRequest(url, 'GET', params, 'json', callback);
        };
        
		
        loadMoreBtn.on('click', loadMore);
        
        $(document).on('click', '.sub-region-link', function(e) {  
        	e.preventDefault();
        	
        	// 넘겨줄 키워드 빈 문자열 처리 및 검색창 비우기
        	currentKwd = '';
        	searchEl.val('');
        	
        	currentRegionId = $(this).data('region-id');
        	applyFilter();        	
        });
        
        $('.searchbar').on('submit', function(e) {
        	e.preventDefault();
        	
        	currentKwd = searchEl.val();
        	
        	applyFilter();
        	
        });
        
        // 좋아요 버튼 클릭 이벤트 리스너 추가 (수정된 부분)
        $(document).on('click', '.like-button', function(e) {
            e.preventDefault();
            e.stopPropagation();

            const productId = $(this).data('product-id');
            const likeCountSpan = $(this).find('.like-count');
            
            $.ajax({
                url: '/product/like',
                type: 'POST',
                data: {
                    product_id: productId
                },
                success: function(response) {
                    if (response.result) {
                        // 좋아요가 성공적으로 처리되었을 때, 좋아요 수 업데이트
                        likeCountSpan.text(response.likeCount);
                    }
                },
                error: function(error) {
                    console.log("좋아요 처리 실패: ", error);
                    alert("좋아요 처리 중 오류가 발생했습니다.");
                }
            });
        });

                
    });

   
</script>
</body>
</html>