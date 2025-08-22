<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>찜한 상품 목록</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" href="data:;base64,iVBORw0KGgo=">
    
    <style>
        .aspect-square { aspect-ratio: 1 / 1; }
        .like-icon {
            color: #ff6b6b;
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
			        <div class="sidebar-sticky">
			          <jsp:include page="/WEB-INF/views/layout/leftmypage.jsp"/>
			        </div>
			    </aside>
            
            <main class="col-span-1 lg:col-span-3">
            	<header class="mb-8">
		            <h1 class="text-3xl font-bold text-gray-900">찜한 상품</h1>
	    	        <p class="text-gray-600 mt-1">회원님이 찜한 상품 목록입니다.</p>    	        	
            	</header>
            
                <div class="grid grid-cols-1 md:grid-cols-1 lg:grid-cols-1 gap-6" id="product-list">
                    <c:forEach var="dto" items="${productLike}">
                        <div class="flex bg-white rounded-lg shadow-md overflow-hidden transform hover:shadow-xl transition-all duration-300">
                            <a href="<c:url value='/product/detail?product_id=${dto.product_id}'/>" class="flex items-center w-full p-4">
                                <div class="w-24 h-24 sm:w-32 sm:h-32 flex-shrink-0 mr-4 overflow-hidden rounded-lg">
                                    <img src="<c:url value='/uploads/product/${dto.thumbnail}'/>" alt="${dto.product_name}" class="w-full h-full object-cover">
                                </div>
                                <div class="flex-grow">
                                    <h2 class="text-lg font-semibold text-gray-800 truncate">${dto.product_name}</h2>
                                    <div class="flex items-center mt-2">
                                        <c:if test="${dto.status}">
                                            <span class="text-xs font-semibold px-2 py-1 rounded-full bg-gray-200 text-gray-700 mr-2">거래완료</span>
                                        </c:if>
                                        <p class="text-xl font-bold text-gray-900">
                                            <fmt:formatNumber value="${dto.price}" pattern="#,##0"/>원
                                        </p>
                                    </div>
                                    <div class="flex items-center text-sm text-gray-500 mt-3">
                                        <span class="mr-3">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 inline-block mr-1 like-icon" viewBox="0 0 20 20" fill="currentColor">
                                              <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
                                            </svg>
                                            <span>${dto.likecount}</span>
                                        </span>
                                    </div>
                                </div>
                                <div class="flex-shrink-0 self-start">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 like-icon" viewBox="0 0 20 20" fill="currentColor">
                                      <path fill-rule="evenodd" d="M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z" clip-rule="evenodd" />
                                    </svg>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
        
                    <c:if test="${empty productLike}">
                        <div class="col-span-full text-center py-12">
                            <p class="text-gray-500">찜한 상품이 없습니다.</p>
                        </div>
                    </c:if>
                </div>
            </main>  
          </div>
        </div>
    </body>
</html>
