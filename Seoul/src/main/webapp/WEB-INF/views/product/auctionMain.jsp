<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프리미엄 경매</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&family=Bai+Jamjuree:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #111827; /* gray-900 */
        }
        .font-display {
            font-family: 'Bai Jamjuree', sans-serif;
        }
        .glass-pane {
            background: rgba(31, 41, 55, 0.5); /* gray-800 with 50% opacity */
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(55, 65, 81, 0.3); /* gray-700 with 30% opacity */
        }
        .hero-glow {
            background: radial-gradient(circle at 50% 50%, rgba(251, 146, 60, 0.15), transparent 70%);
        }
        .card-glow-hot {
            box-shadow: 0 0 20px rgba(239, 68, 68, 0.3);
        }
        .card-glow {
             box-shadow: 0 0 15px rgba(55, 65, 81, 0.5);
        }
    </style>
</head>
<body class="text-gray-200">

    <div class="container mx-auto max-w-7xl p-4 sm:p-6 lg:p-8">

        <c:if test="${not empty featuredAuction}">
            <div class="relative hero-glow rounded-3xl overflow-hidden mb-12">
                <img src="<c:url value='${featuredAuction.thumbnail}'/>" class="absolute inset-0 w-full h-full object-cover opacity-30" alt="추천 경매 상품">
                <div class="relative p-8 md:p-16 flex flex-col justify-center items-start h-full">
                    <h1 class="text-4xl md:text-6xl font-black text-white leading-tight max-w-2xl">${featuredAuction.productName}</h1>
                    <p class="mt-4 text-lg text-gray-300 max-w-lg">${featuredAuction.shortDescription}</p>
                    <div class="mt-8 flex items-center space-x-6">
                        <div>
                            <p class="text-sm font-medium text-gray-400">현재 최고가</p>
                            <p class="text-4xl font-bold text-orange-400">
                                <fmt:formatNumber value="${featuredAuction.currentPrice}" pattern="#,##0"/>원
                            </p>
                        </div>
                        <div>
                            <p class="text-sm font-medium text-gray-400">남은 시간</p>
                            <p class="text-4xl font-bold text-white">${featuredAuction.remainingTime}</p>
                        </div>
                    </div>
                    <a href="<c:url value='/auction/${featuredAuction.auctionId}'/>" class="mt-8 bg-orange-500 hover:bg-orange-400 text-white font-bold text-lg py-3 px-8 rounded-lg transition-colors shadow-lg">
                        지금 입찰하기
                    </a>
                </div>
            </div>
        </c:if>

        <div class="glass-pane p-4 rounded-xl mb-8 flex flex-col sm:flex-row justify-between items-center gap-4">
            <div class="flex space-x-2">
                <button class="bg-gray-700/50 hover:bg-gray-700 text-white font-semibold py-2 px-4 rounded-md transition-colors text-sm">전체</button>
                <c:forEach var="category" items="${categoryList}">
                    <button class="hover:bg-gray-700/50 text-gray-400 font-semibold py-2 px-4 rounded-md transition-colors text-sm">${category.categoryName}</button>
                </c:forEach>
            </div>
            <div>
                <select class="bg-gray-700/50 border border-gray-600 text-white text-sm rounded-md focus:ring-orange-500 focus:border-orange-500 block w-full p-2.5">
                    <option selected>마감 임박순</option>
                    <option>인기순 (입찰 많은 순)</option>
                    <option>최신 등록순</option>
                    <option>높은 가격순</option>
                    <option>낮은 가격순</option>
                </select>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">

            <c:forEach var="auction" items="${auctionList}">
                <div class="glass-pane rounded-2xl overflow-hidden ${auction.isHot ? 'card-glow-hot' : 'card-glow'} transform hover:-translate-y-2 transition-transform duration-300">
                    <div class="relative">
                        <img src="<c:url value='${auction.thumbnail}'/>" class="w-full h-56 object-cover" alt="경매 상품">
                        <c:if test="${auction.isHot}">
                             <div class="absolute top-3 right-3 bg-red-600 text-white text-xs font-bold px-2 py-1 rounded-full animate-pulse">HOT</div>
                        </c:if>
                    </div>
                    <div class="p-5">
                        <h3 class="font-bold text-lg text-white truncate">${auction.productName}</h3>
                        <p class="text-sm text-gray-400 mt-1">현재 최고가</p>
                        <p class="text-2xl font-bold text-orange-400">
                            <fmt:formatNumber value="${auction.currentPrice}" pattern="#,##0"/>원
                        </p>
                        <div class="mt-3 flex justify-between items-center text-sm">
                            <span class="text-gray-400">입찰 ${auction.bidCount}회</span>
                            <span class="font-semibold ${auction.isUrgent ? 'text-red-400' : 'text-gray-300'}">${auction.remainingTime} 남음</span>
                        </div>
                    </div>
                </div>
            </c:forEach>

        </div>

        <div class="text-center mt-12">
            <button class="glass-pane hover:bg-gray-700/80 text-white font-bold py-3 px-8 rounded-lg transition-colors">
                더 많은 경매 보기
            </button>
        </div>
    </div>
</body>
</html>