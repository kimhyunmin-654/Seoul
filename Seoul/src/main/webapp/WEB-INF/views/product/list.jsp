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

    <div class="container mx-auto max-w-7xl p-4 sm:p-6 lg:p-8">
        <header class="mb-8">
            <h1 class="text-3xl font-bold text-gray-900">우리 동네 상품</h1>
            <p class="text-gray-600 mt-1">이웃들의 새로운 상품을 만나보세요.</p>
        </header>
        
        <input type="hidden" id="current-kwd" value="${param.kwd}">
        <input type="hidden" id="current-categoryId" value="${param.categoryId}">
        <input type="hidden" id="current-regionId" value="${param.regionId}">
        <input type="hidden" id="current-type" value="${param.type}">

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6" id="product-grid">
            <c:forEach var="dto" items="${list}">
                <div class="card-container">
                    <a href="<c:url value='/product/detail?productId=${dto.product_id}'/>" class="block bg-white rounded-lg shadow-md overflow-hidden transform hover:-translate-y-1 hover:shadow-xl transition-all duration-300">
                        <div class="aspect-square w-full overflow-hidden">
                            <img src="<c:url value='/uploads/product/${dto.thumbnail}'/>" alt="${dto.product_name}" class="w-full h-full object-cover">
                        </div>
                        <div class="p-4">
                            <h2 class="text-lg font-semibold text-gray-800 truncate" style="margin-bottom: 8px;">${dto.product_name}</h2>
                            <p class="text-xl font-bold text-gray-900" style="margin-bottom: 8px;">
                                <fmt:formatNumber value="${dto.price}" pattern="#,##0"/>원
                            </p>
                            <p class="text-sm text-gray-500 truncate" style="margin-bottom: 12px;">${dto.region_name}</p>
                            <div class="flex items-center text-sm text-gray-500 border-t pt-3 mt-3">
                                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1 text-gray-400" viewBox="0 0 20 20" fill="currentColor">
                                  <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
                                </svg>
                                <span>${dto.likeCount}</span>
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
    </div>

<script>
    $(function() {
        const loadMoreBtn = $('#load-more-btn');
        const productGrid = $('#product-grid');
        
        if(loadMoreBtn.length === 0) {
            return;
        }

        let currentPage = parseInt("${page}");

        loadMoreBtn.on('click', function() {
            currentPage++;

            const params = {
                page: currentPage,
                kwd: $('#current-kwd').val(),
                categoryId: $('#current-categoryId').val(),
                regionId: $('#current-regionId').val(),
                type: $('#current-type').val()
            };

            $.ajax({
                url: '/product/list/more',
                type: 'GET',
                data: params,
                dataType: 'json',
                success: function(data) {
                    if (data.list && data.list.length > 0) {
                        let cardHtml = '';
                        
                        $.each(data.list, function(index, product) {
                            cardHtml += `
                                <div class="card-container">
                                    <a href="/product/detail?productId=\${product.product_id}" class="block bg-white rounded-lg shadow-md overflow-hidden transform hover:-translate-y-1 hover:shadow-xl transition-all duration-300">
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
                },
                error: function(request, status, error) {
                    console.error("데이터를 불러오는 중 오류가 발생했습니다.", error);
                    alert('상품을 더 불러오는 데 실패했습니다.');
                }
            });
        });
    });
</script>
</body>
</html>