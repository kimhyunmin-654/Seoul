<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>판매자: ${seller_name}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" href="data:;base64,iVBORw0KGgo=">
    
    <style>
        .aspect-square { aspect-ratio: 1 / 1; }
        .like-icon {
            color: #ff6b6b;
        }
        @layer base {
		    a:link,
		    a:visited,
		    a:hover,
		    a:active {
		      text-decoration: none !important;
		    }
  		}
    </style>
</head>
<body class="bg-gray-100">

    <header>	
        <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
    </header>
      
	
    
    <div class="container mx-auto max-w-7xl p-4 sm:p-6 lg:p-8">
        <div class="grid grid-cols-1 md:grid-cols-4 lg:grid-cols-5 gap-6">
            
            <aside class="col-span-1">
                <div class="sidebar-sticky">
                    <jsp:include page="/WEB-INF/views/layout/leftProduct.jsp"/>
                </div>
            </aside>

            <main class="col-span-1 md:col-span-3 lg:col-span-4">
                <header class="mb-8">
                    <h1 class="text-3xl font-bold text-gray-900">${seller_name}님의 상점입니다.</h1>
                </header>
            
                <div class="border-b border-gray-200">
                    <nav class="-mb-px flex space-x-8">
                        <a href="<c:url value='/member/prolist?member_id=${member_id}'/>" class="whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm <c:if test="${param.tab == null}">border-indigo-500 text-indigo-600</c:if><c:if test="${param.tab != null}">border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300</c:if>">
                            판매물품
                        </a>
                        <a href="<c:url value='/member/prolist?member_id=${member_id}&tab=reviews'/>" class="whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm <c:if test="${param.tab == 'reviews'}">border-indigo-500 text-indigo-600</c:if><c:if test="${param.tab != 'reviews'}">border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300</c:if>">
                            후기
                        </a>
                    </nav>
                </div>
                
                <c:choose>
                    <c:when test="${param.tab == 'reviews'}">
                        <div id="reviews-container" class="mt-8">
                            <c:if test="${not empty reviews}">
                                <c:forEach var="review" items="${reviews}">
                                    <div class="bg-white rounded-lg shadow-md p-6 mb-4">
                                        <div class="flex items-center mb-2">
                                            <div class="w-10 h-10 rounded-full overflow-hidden mr-4">
                                                <img src="${pageContext.request.contextPath}/uploads/member/${review.profile_photo}" alt="프로필" class="w-full h-full object-cover">
                                            </div>
                                            <div>
                                                <p class="font-semibold">${review.nickname}</p>
                                                <p class="text-sm text-gray-500">${review.created_at}</p>
                                            </div>
                                        </div>
                                        <div class="text-yellow-400 mb-2">
                                            <c:forEach begin="1" end="${review.rating}">★</c:forEach>
                                            <c:forEach begin="${review.rating + 1}" end="5">☆</c:forEach>
                                        </div>
                                        <p class="text-gray-700">${review.content}</p>
                                    </div>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty reviews}">
                                <div class="col-span-full text-center py-12">
                                    <p class="text-gray-500">받은 후기가 없습니다.</p>
                                </div>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4 mt-8" id="product-list">
                            <c:forEach var="dto" items="${sellerProducts}">
                            	<c:choose>
							        <c:when test="${dto.type == 'AUCTION'}">
							            <c:set var="url" value="/auction/detail/${dto.auction_id}" />
							        </c:when>
							        <c:otherwise>
							            <c:set var="url" value="/product/detail?product_id=${dto.product_id}" />
							        </c:otherwise>
							    </c:choose>
                                <div class="bg-white rounded-lg shadow-md overflow-hidden transform hover:shadow-xl transition-all duration-300">
                                    <a href="<c:url value='${url}'/>">
                                        <div class="relative w-full aspect-square overflow-hidden">
                                            <img src="<c:url value='/uploads/product/${dto.thumbnail}'/>" alt="${dto.product_name}" class="w-full h-full object-cover">
                                            <c:if test="${dto.type eq 'AUCTION'}">
								                <div class="absolute top-2 left-2 bg-orange-500 text-white text-xs font-bold px-2 py-1 rounded-full flex items-center z-10">
								                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-hammer me-1" viewBox="0 0 16 16">
													  <path d="M9.972 2.508a.5.5 0 0 0-.16-.556l-.178-.129a5 5 0 0 0-2.076-.783C6.215.862 4.504 1.229 2.84 3.133H1.786a.5.5 0 0 0-.354.147L.146 4.567a.5.5 0 0 0 0 .706l2.571 2.579a.5.5 0 0 0 .708 0l1.286-1.29a.5.5 0 0 0 .146-.353V5.57l8.387 8.873A.5.5 0 0 0 14 14.5l1.5-1.5a.5.5 0 0 0 .017-.689l-9.129-8.63c.747-.456 1.772-.839 3.112-.839a.5.5 0 0 0 .472-.334"/>
													</svg>
								                    <span>경매</span>
								                </div>
								            </c:if>
                                            <c:if test="${dto.status eq '판매완료'}">
                                                <div class="absolute inset-0 bg-black bg-opacity-40 flex items-center justify-center">
                                                    <span class="text-white text-sm font-bold">거래완료</span>
                                                </div>
                                            </c:if>
                                        </div>
                                        
                                        <div class="p-2">
                                            <h2 class="text-sm font-semibold text-gray-800 truncate">${dto.product_name}</h2>
                                            <p class="text-md font-bold text-gray-900 mt-1">
                                                <fmt:formatNumber value="${dto.price}" pattern="#,##0"/>원
                                            </p>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>
                
                            <c:if test="${empty sellerProducts}">
                                <div class="col-span-full text-center py-12">
                                    <p class="text-gray-500">등록된 상품이 없습니다.</p>
                                </div>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </main>
        </div>
    </div>
<script src="${pageContext.request.contextPath}/dist/js/leftProduct.js"></script>
</body>
</html>