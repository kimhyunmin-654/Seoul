<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${auctionDetail.productName} - 프리미엄 경매</title>
    <%-- 필요한 CSS/JS 라이브러리 --%>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&family=Bai+Jamjuree:wght@600;700&display=swap" rel="stylesheet">
    <%-- 페이지 전용 스타일 --%>
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #111827; }
        .font-display { font-family: 'Bai Jamjuree', sans-serif; }
        .glass-pane { background: rgba(31, 41, 55, 0.5); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border: 1px solid rgba(55, 65, 81, 0.3); }
        .glow-button { box-shadow: 0 0 15px rgba(251, 146, 60, 0.4), 0 0 30px rgba(251, 146, 60, 0.2); }
        .timer-segment { background: linear-gradient(to bottom, #1f2937, #111827); }
        .bid-history-item::before { content: ''; position: absolute; left: 10px; top: 12px; width: 1px; height: 100%; background-color: #374151; }
        .bid-history-item:last-child::before { display: none; }
        .bid-history-item .dot { position: absolute; left: 4px; top: 12px; width: 14px; height: 14px; border-radius: 9999px; background-color: #1f2937; border: 2px solid #fb923c; }
        .custom-scrollbar::-webkit-scrollbar { width: 6px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: #4b5563; border-radius: 10px; }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: #6b7280; }
        .odometer-container { display: flex; align-items: center; line-height: 1; }
        .digit-container { height: 1em; overflow: hidden; }
        .digit-reel { transition: transform 0.8s cubic-bezier(0.2, 1, 0.3, 1); }
        .comma { padding: 0 0.1em; }
    </style>
</head>
<body class="text-gray-200">

    <div class="container mx-auto max-w-7xl p-4 sm:p-6 lg:p-8">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            
            <div class="lg:col-span-2 flex flex-col gap-8">
                <div class="relative aspect-w-1 aspect-h-1 bg-gray-900 rounded-2xl shadow-2xl overflow-hidden group">
                    <div id="image-carousel" class="flex transition-transform duration-500 ease-in-out">
                        <c:forEach var="image" items="${auctionDetail.images}">
                             <img src="<c:url value='${image.filename}'/>" alt="경매 상품 이미지" class="w-full h-full object-cover flex-shrink-0">
                        </c:forEach>
                    </div>
                    <button id="prev-btn" class="absolute top-1/2 left-4 -translate-y-1/2 bg-black/30 hover:bg-black/50 p-3 rounded-full text-white transition-opacity duration-300 opacity-0 group-hover:opacity-100">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" /></svg>
                    </button>
                    <button id="next-btn" class="absolute top-1/2 right-4 -translate-y-1/2 bg-black/30 hover:bg-black/50 p-3 rounded-full text-white transition-opacity duration-300 opacity-0 group-hover:opacity-100">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" /></svg>
                    </button>
                </div>
                <div class="glass-pane p-6 rounded-2xl">
                    <h2 class="text-2xl font-bold text-white mb-4">상품 상세 정보</h2>
                    <div class="space-y-3 text-gray-300 text-sm">
                        ${auctionDetail.content}
                    </div>
                </div>
            </div>

            <div class="flex flex-col space-y-6">
                <div class="glass-pane p-6 rounded-2xl">
                    <h1 class="text-4xl font-black text-white leading-tight">${auctionDetail.productName}</h1>
                    <div class="flex items-center mt-4 space-x-3">
                        <img src="<c:url value='${auctionDetail.sellerAvatar}'/>" alt="판매자 아바타" class="w-8 h-8 rounded-full border-2 border-gray-600">
                        <span class="text-sm font-medium text-gray-400">판매자: <span class="text-white font-semibold">${auctionDetail.sellerNickname}</span></span>
                    </div>
                </div>

                <div class="glass-pane p-6 rounded-2xl">
                    <p class="text-sm font-medium text-gray-400 text-center mb-3">경매 마감까지</p>
                    <div id="countdown-timer" class="flex justify-center space-x-2 sm:space-x-4 text-center">
                        <%-- JavaScript가 이 부분을 채웁니다. --%>
                    </div>
                </div>

                <div class="glass-pane p-6 rounded-2xl flex flex-col">
                    <p class="text-sm font-medium text-gray-400">현재 최고가</p>
                    <div id="current-price" class="odometer-container text-5xl font-bold text-orange-400 my-2">
                        <%-- JavaScript가 이 부분을 채웁니다. --%>
                    </div>
                    <p class="text-sm text-gray-500">최고 입찰자: <span id="top-bidder" class="font-semibold text-gray-300">${auctionDetail.topBidderNickname}</span></p>
                    
                    <div class="mt-6">
                        <div class="flex space-x-2 mb-3">
                             <button class="bid-increment-btn flex-1 bg-gray-700/50 hover:bg-gray-700 text-gray-300 font-semibold py-2 rounded-md transition-colors text-sm" data-increment="10000">+1만원</button>
                             <button class="bid-increment-btn flex-1 bg-gray-700/50 hover:bg-gray-700 text-gray-300 font-semibold py-2 rounded-md transition-colors text-sm" data-increment="50000">+5만원</button>
                             <button class="bid-increment-btn flex-1 bg-gray-700/50 hover:bg-gray-700 text-gray-300 font-semibold py-2 rounded-md transition-colors text-sm" data-increment="100000">+10만원</button>
                        </div>
                        <div class="relative">
                            <span class="absolute left-4 top-1/2 -translate-y-1/2 text-xl font-bold text-gray-400">₩</span>
                            <input type="number" id="bid-amount" placeholder="입찰 금액" class="w-full bg-gray-900 border-2 border-gray-700 rounded-lg py-4 pl-10 pr-4 text-white text-lg focus:outline-none focus:border-orange-400 transition-colors">
                        </div>
                        <button id="bid-button" class="w-full mt-3 bg-orange-500 hover:bg-orange-400 text-white font-bold text-xl py-4 rounded-lg transition-all duration-300 transform hover:scale-105 glow-button">
                            입찰하기
                        </button>
                    </div>
                </div>
                
                <div class="glass-pane p-6 rounded-2xl flex-grow">
                    <h2 class="text-xl font-bold text-white mb-4">입찰 기록</h2>
                    <div id="bid-history" class="space-y-4 max-h-60 overflow-y-auto pr-4 custom-scrollbar">
                        <%-- JavaScript가 이 부분을 채웁니다. --%>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // --- 1. 서버(JSP)에서 JavaScript로 데이터 주입 ---
        const initialData = {
            currentPrice: ${auctionDetail.currentPrice},
            endTime: '${auctionDetail.endTime}', // 'YYYY-MM-DD HH:mm:ss' 형식의 문자열
            bidHistory: JSON.parse('${bidHistoryJson}') // 컨트롤러에서 List<Bid>를 JSON 문자열로 변환하여 전달
        };

        document.addEventListener('DOMContentLoaded', () => {
            // ... (이하 JavaScript 로직은 이전과 거의 동일)
            // 변수 선언 시, 위 initialData를 사용하도록 수정
            
            const countdownEl = document.getElementById('countdown-timer');
            const currentPriceEl = document.getElementById('current-price');
            // ... (나머지 요소들)
            
            let currentPrice = initialData.currentPrice;
            let bidHistory = initialData.bidHistory;
            
            // --- Countdown Timer ---
            // initialData.endTime을 사용하여 남은 시간을 계산
            const endTimeMs = new Date(initialData.endTime).getTime();
            
            function updateCountdown() {
                const nowMs = new Date().getTime();
                let timeLeft = Math.round((endTimeMs - nowMs) / 1000);

                if (timeLeft <= 0) {
                    // ... (경매 종료 로직)
                    return;
                }
                // ... (시간 표시 로직)
            }
            // ... (나머지 모든 JavaScript 로직은 여기에...)
        });
    </script>
</body>
</html>