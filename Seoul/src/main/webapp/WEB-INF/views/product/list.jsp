<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상품 목록</title>
    <link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .aspect-square { aspect-ratio: 1 / 1; }
        @layer base {
        	a:link,
        	a:visited,
        	a:hover,
        	a:active {
        		text-decoration:none !important;
        	}
        }
        .active-filters-container {
	    display: flex;
	    align-items: center;
	    gap: 12px;
	    padding: 12px 16px;
	    background-color: #f8fafc;
	    border: 1px solid #e2e8f0;
	    border-radius: 8px;
	    flex-wrap: wrap;
		}
		
		.active-filters-label {
		    white-space: nowrap;
		}
		
		.active-filters-chips {
		    display: flex;
		    gap: 8px;
		    flex-wrap: wrap;
		    flex: 1;
		    min-width: 0;
		}
		
		.main-filter-chip {
		    display: inline-flex;
		    align-items: center;
		    gap: 6px;
		    background-color: #f97316;
		    color: white;
		    padding: 6px 12px;
		    border-radius: 20px;
		    font-size: 0.875rem;
		    font-weight: 500;
		    white-space: nowrap;
		}
		
		.main-filter-chip .filter-type {
		    opacity: 0.8;
		    font-size: 0.8rem;
		}
		
		.main-clear-chip-btn {
		    background: none;
		    border: none;
		    color: white;
		    cursor: pointer;
		    padding: 0;
		    margin-left: 2px;
		    font-size: 1.1rem;
		    line-height: 1;
		    width: 18px;
		    height: 18px;
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    border-radius: 50%;
		    transition: background-color 0.2s;
		}
		
		.main-clear-chip-btn:hover {
		    background-color: rgba(255, 255, 255, 0.2);
		}
		
		.clear-all-filters {
		    white-space: nowrap;
		    text-decoration: underline;
		    transition: color 0.2s;
		}
		
		.clear-all-filters:hover {
		    text-decoration: none;
		}
		
		
		@media (max-width: 768px) {
		    .active-filters-container {
		        padding: 8px 12px;
		        gap: 8px;
		    }
		    
		    .active-filters-label {
		        font-size: 0.8rem;
		    }
		    
		    .main-filter-chip {
		        font-size: 0.8rem;
		        padding: 4px 8px;
		    }
		}
    </style>
</head>
<body class="bg-gray-100">

        <header>	
		    <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
		    
        </header>
        
        
    	<div class="container mx-auto max-w-7xl p-4 sm:p-6 lg:p-8">
            
            <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
            	
            	<aside class="col-span-1 sidebar">
			        <div class="sidebar-container">
			          <jsp:include page="/WEB-INF/views/layout/leftProduct.jsp"/>
			        </div>
			    </aside>
            
          
            <main class="col-span-1 lg:col-span-3">
            	<header class="mb-8">
			        
			        <div id="active-filters" class="active-filters-container mb-4" style="display: none;">
			            <div class="active-filters-label">
			                <span class="text-sm text-gray-600 font-medium">적용된 필터:</span>
			            </div>
			            <div class="active-filters-chips"></div>
			            <button class="clear-all-filters text-sm text-orange-600 hover:text-orange-700 font-medium">
			                모든 필터 지우기
			            </button>
			        </div>
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
                <div class="col-span-full"> 
        	            <div class="flex flex-col items-center justify-center text-center py-24 text-gray-500">
        	                <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-16 w-16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        	                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        	                </svg>
        	                <h3 class="mt-4 text-xl font-semibold text-gray-800">검색 결과가 없습니다.</h3>
        	            </div>
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
		if (typeof window.currentCategoryId === 'undefined') {
		    window.currentCategoryId = "${cond.category_id}";
		}
		if (typeof window.currentRegionId === 'undefined') {
		    window.currentRegionId = "${cond.region}";
		}

       	$(function() {
		
        let currentPage = parseInt("${page}");
        let currentKwd = "${cond.kwd}";
        let currentType = "${cond.type}";
        
        let url = '/product/list/ajax';
        let searchEl = $('.searchbar input[name=kwd]');
    	
        const productGrid = $('#product-grid');
        const loadMoreBtn = $('#load-more-btn');
        
        // 더보기 요청
        function loadMore() {
        	
        	
        	currentPage++;
        	
            const params = {
                page: currentPage,
                kwd: currentKwd,
                category_id: window.currentCategoryId,
                region: window.currentRegionId,
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
        
        // 데이터 필터링 요청
        window.applyFilter = function() {
        	currentPage = 1;
        	
        	const params = {
       			page: currentPage,
                kwd: currentKwd,
                category_id: window.currentCategoryId,
                region: window.currentRegionId,
                type: 'NORMAL'
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
        		} else {
        			const noResultHtml = `
        				<div class="col-span-full"> 
        	            <div class="flex flex-col items-center justify-center text-center py-24 text-gray-500">
        	                <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-16 w-16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        	                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
        	                </svg>
        	                <h3 class="mt-4 text-xl font-semibold text-gray-800">검색 결과가 없습니다.</h3>
        	            </div>
        	        </div>
        	        `;
        	        productGrid.html(noResultHtml);
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
        
        
        
        $('.searchbar').on('submit', function(e) {
        	e.preventDefault();
        	
        	currentKwd = searchEl.val();
        	
        	window.applyFilter();
        	
        });
        
        // 필터링 화면 동적 변화
 
    function updateMainFilterChips() {
        const activeFiltersContainer = document.getElementById('active-filters');
        const chipsContainer = activeFiltersContainer.querySelector('.active-filters-chips');
        
        if (!activeFiltersContainer || !chipsContainer) {
            return;
        }
        
       
        chipsContainer.innerHTML = '';
        
        let hasActiveFilters = false;
        
        
        if (window.currentRegionId) {
            const regionElement = document.querySelector(`.sub-region-link[data-region-id="${window.currentRegionId}"]`);
            if (regionElement) {
                const regionText = regionElement.textContent.trim();
                const chipHtml = `
                    <span class="main-filter-chip" data-filter-type="region" data-filter-id="${window.currentRegionId}">
                        <span class="filter-type">지역:</span> ${regionText}
                        <button class="main-clear-chip-btn" data-filter-type="region">&times;</button>
                    </span>
                `;
                chipsContainer.innerHTML += chipHtml;
                hasActiveFilters = true;
            }
        }
        
        
        if (window.currentCategoryId) {
            const categoryElement = document.querySelector(`.category-link[data-category-id="${window.currentCategoryId}"]`);
            if (categoryElement) {
                const categoryText = categoryElement.textContent.trim();
                const chipHtml = `
                    <span class="main-filter-chip" data-filter-type="category" data-filter-id="${window.currentCategoryId}">
                        <span class="filter-type">카테고리:</span> ${categoryText}
                        <button class="main-clear-chip-btn" data-filter-type="category">&times;</button>
                    </span>
                `;
                chipsContainer.innerHTML += chipHtml;
                hasActiveFilters = true;
            }
        }
        
        
        activeFiltersContainer.style.display = hasActiveFilters ? 'flex' : 'none';
        
        
      }
        
   		// 좋아요 버튼 클릭
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
                        
                        likeCountSpan.text(response.likeCount);
                    }
                },
                error: function(error) {
                    
                    alert("좋아요 처리 중 오류가 발생했습니다.");
                }
            });
        });
		
        
                
    });

   
</script>
<script src="${pageContext.request.contextPath}/dist/js/leftProduct.js"></script>
</body>
</html>