<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${dto.product_name} - 경매</title>
    <link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&family=Bai+Jamjuree:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body { background-color: #f3f4f6; }
        #auction-detail-wrapper {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #111827;
            color: #d1d5db;
        }
        #auction-detail-wrapper .font-display { font-family: 'Bai Jamjuree', sans-serif; }
        #auction-detail-wrapper .glass-pane { background: rgba(31, 41, 55, 0.5); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border: 1px solid rgba(55, 65, 81, 0.3); }
        #auction-detail-wrapper .glow-button { box-shadow: 0 0 15px rgba(251, 146, 60, 0.4), 0 0 30px rgba(251, 146, 60, 0.2); }
        #auction-detail-wrapper .timer-segment { background: linear-gradient(to bottom, #1f2937, #111827); }
        #auction-detail-wrapper .bid-history-item {
	        position: relative;
	        padding-left: 2rem; 
	        padding-bottom: 1rem;
	    }
        #auction-detail-wrapper .bid-history-item::before { content: ''; position: absolute; left: 10px; top: 12px; width: 2px; height: 100%; background-color: #374151; }
        #auction-detail-wrapper .bid-history-item:last-child::before { display: none; }
        #auction-detail-wrapper .bid-history-item .dot {
	        position: absolute;
	        left: 4px;
	        top: 12px;
	        width: 14px;
	        height: 14px;
	        border: 2px solid #4b5563;
	        background-color: #4b5563;
	        border-radius: 9999px;
	    }
        #auction-detail-wrapper .bid-history-item.my-bid .dot {
	        border-color: #fb923c;      
	        background-color: #fb923c;  
	        box-shadow: 0 0 10px rgba(251, 146, 60, 0.7); 
	    }
	    #auction-detail-wrapper .bid-history-item.my-bid .bidder-name {
	        color: #fb923c;             
	        font-weight: 700;          
	    }
        #auction-detail-wrapper .custom-scrollbar::-webkit-scrollbar { width: 6px; }
        #auction-detail-wrapper .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        #auction-detail-wrapper .custom-scrollbar::-webkit-scrollbar-thumb { background: #4b5563; border-radius: 10px; }
        #auction-detail-wrapper .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: #6b7280; }
        #auction-detail-wrapper .odometer-container { display: flex; align-items: center; line-height: 1; }
        #auction-detail-wrapper .digit-container { height: 1em; overflow: hidden; }
        #auction-detail-wrapper .digit-reel { transition: transform 0.8s cubic-bezier(0.2, 1, 0.3, 1); }
        #auction-detail-wrapper .comma { padding: 0 0.1em; }
        #auction-detail-wrapper .carousel-container {
            position: relative;
            background-color: #111827;
            border-radius: 1rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            max-height: 485px;
            aspect-ratio: 1 / 1;
        }
        #auction-detail-wrapper .carousel-container:hover .carousel-nav-btn {
            opacity: 1;
        }
        #auction-detail-wrapper .carousel-nav-btn {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background-color: rgba(0, 0, 0, 0.5);
            color: white;
            border: none;
            border-radius: 50%;
            width: 48px;
            height: 48px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            opacity: 0;
            z-index: 50;
            backdrop-filter: blur(4px);
        }
         #auction-detail-wrapper .carousel-nav-btn:hover {
            background-color: rgba(0, 0, 0, 0.7);
            transform: translateY(-50%) scale(1.1);
        }
        
        #auction-detail-wrapper .carousel-nav-btn.prev {
            left: 16px;
        }
        
        #auction-detail-wrapper .carousel-nav-btn.next {
            right: 16px;
        }
        
        #auction-detail-wrapper .tab-btn {
        	position: relative;
	        padding: 0.5rem 1rem;
	        border: none;
	        background: none;
	        color: #9ca3af; 
	        border-bottom: 2px solid transparent;
	    }
	    #auction-detail-wrapper .tab-btn.active {
	        color: #fb923c; 
	        border-bottom-color: #fb923c;
	    }
	    
	    #auction-detail-wrapper .new-bid-badge {
	        position: absolute;
	        top: 6px;
	        right: 6px;
	        width: 8px;
	        height: 8px;
	        background-color: #ef4444;
	        border-radius: 50%;
	        box-shadow: 0 0 6px rgba(239, 68, 68, 0.8);
	    }
	    
	    @keyframes pulse {
	        0%, 100% { transform: scale(1); }
	        50% { transform: scale(1.1); }
	    }
	    
	     #auction-detail-wrapper #more-menu-dropdown {
	        border-color: #374151 !important;
	    }
        
    	.crown-sparkle {
		  position: relative;
		}
		
		.crown-sparkle::after {
		  content: '✦';
		  position: absolute;
		  top: -3px;
		  right: 5px;
		  color: white;
		  font-size: 8px;
		  opacity: 0;
		  animation: sparkle 2s infinite ease-in-out;
		  text-shadow: 0 0 4px rgba(255,255,255,0.8);
		  will-change: opacity, transform; 
		}
		
		@keyframes sparkle {
		  0%, 100% { opacity: 0; filter: blur(1px) brightness(0); }
		  50% { opacity: 1; filter: blur(0px) brightness(1.5); }
		}
		
		animation: sparkle 1s infinite;
		animation-fill-mode: both;

    </style>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
		<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
	</header>
	<div id="auction-detail-wrapper">
	    <div class="container mx-auto max-w-7xl p-4 sm:p-6 lg:p-8">
	    	<div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
                <aside class="col-span-4 lg:col-span-1">
                    <div class="sticky top-8 text-gray-800">
                        <jsp:include page="/WEB-INF/views/layout/leftProduct.jsp"/>
                        
                    </div>
                </aside>
                <main class="col-span-4 lg:col-span-3">
				    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
			            
			            <div class="lg:col-span-2 flex flex-col gap-8">
			                <div class="relative bg-gray-900 rounded-2xl shadow-2xl overflow-hidden carousel-container group">
			                    <div id="image-carousel" class="flex transition-transform duration-500 ease-in-out h-full">
			                         <img src="<c:url value='/uploads/product/${dto.thumbnail}'/>"
										alt="${dto.product_name}"
										class="w-full h-full object-cover flex-shrink-0">
									<c:forEach var="image" items="${imageList}">
										<img src="<c:url value='/uploads/product/${image.filename}'/>"
											alt="${dto.product_name} 추가 이미지"
											class="w-full h-full object-cover flex-shrink-0">
									</c:forEach>
			                    </div>
			                    <button id="prev-btn" class="carousel-nav-btn prev">
			                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" /></svg>
			                    </button>
			                    <button id="next-btn" class="carousel-nav-btn next">
			                        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" /></svg>
			                    </button>
			                </div>
			                <div class="glass-pane p-6 rounded-2xl flex-grow flex flex-col">
			                	 <div class="flex border-b border-gray-700">
							            <button class="tab-btn active" data-tab="description">상세 정보</button>
							            <button class="tab-btn" data-tab="bids">
							            입찰 기록 <span class="bid-count">(${dto.bidCount})</span> 
							            </button>
							     </div>
							     
							     <div class="mt-4 flex-grow relative">
								     	<div id="description" class="tab-panel absolute inset-0">
							                <div class="overflow-y-auto custom-scrollbar h-full">
							                    <p class="text-gray-300">${dto.content}</p>
							                </div>
							            </div>
							            <div id="bids" class="tab-panel absolute inset-0 hidden">
							                 <div id="bid-history" class="overflow-y-auto custom-scrollbar h-full">
							                    
							                 </div>
							            </div>
							     </div>
			                </div>
			            </div>
			
			            <div class="flex flex-col space-y-6">
			                <div class="glass-pane p-6 rounded-2xl relative">
			                	<c:if test="${not empty sessionScope.member and ((dto.seller_id == sessionScope.member.member_id and dto.status != 'ENDED_SUCCESS') or (dto.seller_id != sessionScope.member.member_id))}">
				                	<div class="absolute top-4 right-4">
				                		<button id="more-menu-btn" class="p-2 rounded-full hover:bg-gray-700/50 transition-colors">
				                			<svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01"></path></svg>
				                		</button>
				                		
				                		<div id="more-menu-dropdown" class="hidden absolute right-0 mt-2 w-48 bg-gray-800 border border-gray-700 rounded-md shadow-lg z-20">
							                <div class="py-1">
							                	<c:if test="${dto.seller_id == sessionScope.member.member_id and dto.status == 'IN_PROGRESS'}">
							                        <a href="<c:url value='/auction/update?product_id=${dto.product_id}&auction_id=${dto.auction_id}'/>" id="update-link" class="block px-4 py-2 text-sm text-gray-300 hover:bg-gray-700">수정하기</a>
							                	</c:if>
							                    <c:if test="${dto.seller_id == sessionScope.member.member_id and dto.status != 'ENDED_SUCCESS'}">
							                        <form action="<c:url value='/auction/delete'/>" method="post" id="delete-form">
							                            <input type="hidden" name="product_id" value="${dto.product_id}">
							                            <input type="hidden" name="auction_id" value="${dto.auction_id}">
							                            <button type="submit" class="w-full text-left block px-4 py-2 text-sm text-red-500 hover:bg-gray-700">삭제하기</button>
							                        </form>
							                    </c:if>
							                    <c:if test="${dto.seller_id != sessionScope.member.member_id }">
							                    	<a href="#" class="block px-4 py-2 text-sm text-gray-300 hover:bg-gray-700">신고하기</a>
							                    </c:if>
							                </div>
							            </div>
				                	</div>
			                	</c:if>
			                	
			                    <h1 class="text-4xl font-black text-white leading-tight pr-12">${dto.product_name}</h1>
			                    <div class="flex items-center mt-4 space-x-3">
			                        <img src="<c:url value='${dto.sellerAvatar}'/>" alt="판매자 아바타" class="w-8 h-8 rounded-full border-2 border-gray-600">
			                        <span class="text-sm font-medium text-gray-400">판매자: <span class="text-white font-semibold">${dto.seller_nickname}</span></span>
			                    </div>
			                </div>
			
			                <div class="glass-pane p-6 rounded-2xl">
			                    <p id="countdown-label" class="text-sm font-medium text-gray-400 text-center mb-3">경매 마감까지</p>
			                    <div id="countdown-timer" class="flex justify-center space-x-2 sm:space-x-4 text-center">
			                        
			                    </div>
			                </div>
			
			                <div class="glass-pane p-6 rounded-2xl flex flex-col">
			                    <p class="text-sm font-medium text-gray-400">현재 최고가</p>
			                    <div id="current-price" class="odometer-container text-5xl font-bold text-orange-400 mb-4">
			                       
			                    </div>
			                    <div class="text-sm flex items-baseline p-1 bg-gray-800 rounded-lg shadow-md">
								    <span class="text-gray-400 me-2">최고 입찰자:</span>
								    
								    <span id="top-bidder" class="font-semibold">
								        <c:choose>
								            <c:when test="${not empty sessionScope.member and dto.current_winner == sessionScope.member.nickname}">
								                <span class="font-bold text-yellow-400 text-lg drop-shadow-sm">
								                <span class="relative crown-sparkle">
								                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="mr-0.5 inline align-middle">
								                        <path d="M5 16L3 7l5.5 4L12 4l3.5 7L21 7l-2 9H5z"
								                              fill="#fbbf24"
								                              stroke="#f59e0b"
								                              stroke-width="1.5"
								                              stroke-linejoin="round"/>
								                        <circle cx="12" cy="8" r="1.5" fill="#ef4444"/>
								                        <circle cx="8.5" cy="10" r="1" fill="#3b82f6"/>
								                        <circle cx="15.5" cy="10" r="1" fill="#10b981"/>
								                        <rect x="4" y="16" width="16" height="2" fill="#f59e0b" rx="1"/>
								                        <path d="M6 8l2 3 4-7 2 4"
								                              stroke="rgba(255,255,255,0.3)"
								                              stroke-width="1"
								                              fill="none"
								                              stroke-linecap="round"/>
								                    </svg>
								                    </span>
								                    <span>You</span>
								                </span>
								            </c:when>
								            <c:otherwise>
								                <span class="text-gray-200">
								                    ${empty dto.current_winner ? '-' : dto.current_winner}
								                </span>
								            </c:otherwise>
								        </c:choose>
								    </span>
								</div>
			                    
			                    <div class="mt-6">
			                        <div class="flex space-x-2 mb-3">
			                             <button class="bid-increment-btn flex-1 bg-gray-700/50 hover:bg-gray-700 text-gray-300 font-semibold py-2 rounded-md transition-colors text-sm" data-increment="1000">+1천원</button>
			                             <button class="bid-increment-btn flex-1 bg-gray-700/50 hover:bg-gray-700 text-gray-300 font-semibold py-2 rounded-md transition-colors text-sm" data-increment="5000">+5천원</button>
			                             <button class="bid-increment-btn flex-1 bg-gray-700/50 hover:bg-gray-700 text-gray-300 font-semibold py-2 rounded-md transition-colors text-sm" data-increment="10000">+1만원</button>
			                        </div>
			                        <div class="relative">
			                        	<c:if test="${dto.status == 'IN_PROGRESS'}">
				                            <span class="absolute left-4 top-1/2 -translate-y-1/2 text-xl font-bold text-gray-400">₩</span>
			                        	</c:if>
			                            <input type="text" id="bid-amount" placeholder="입찰 금액" class="w-full bg-gray-900 border-2 border-gray-700 rounded-lg py-4 pl-10 pr-4 text-white text-lg focus:outline-none focus:border-orange-400 transition-colors" pattern="^[0-9]+$">
			                        </div>
			                        <button id="bid-button" class="w-full mt-3 bg-orange-500 hover:bg-orange-400 text-white font-bold text-xl py-4 rounded-lg transition-all duration-300 transform hover:scale-105 glow-button">
			                            입찰하기
			                        </button>
			                         <p class="text-xs text-gray-400 mt-4 text-center">
								        경매 낙찰 시, 구매를 취소할 수 없습니다.<br>자세한 사항은 서비스 이용 약관을 확인하세요.
									 </p>
			                    </div>
			                </div>
			                
			                
			            </div>
			        </div>
		        </main>
		    </div>
	    </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script src="${pageContext.request.contextPath }/dist/js/util-jquery.js"></script>
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
    
        // --- 서버에서 JavaScript로 데이터 주입 ---
        const initialData = {
            currentPrice: ${dto.current_price},
            endTime: '${dto.end_time}', 
            bidHistory: JSON.parse('${bidHistoryJson}') 
        };

        document.addEventListener('DOMContentLoaded', () => {
            const currentNickname = "${sessionScope.member.nickname}";
            const countdownLabel = document.getElementById('countdown-label');
        	const countdownEl = document.getElementById('countdown-timer');
            const currentPriceEl = document.getElementById('current-price');
            const bidHistoryEl = document.getElementById('bid-history');
            const bidButton = document.getElementById('bid-button');
            const bidAmountInput = document.getElementById('bid-amount');
            const topBidderEl = document.getElementById('top-bidder');
            const bidIncrementBtns = document.querySelectorAll('.bid-increment-btn');
            const tabButtonEl = document.querySelectorAll('.tab-btn');
            const tabPanelEl = document.querySelectorAll('.tab-panel');
            const carousel = document.getElementById('image-carousel');
            const prevBtn = document.getElementById('prev-btn');
            const nextBtn = document.getElementById('next-btn');
            const images = carousel.querySelectorAll('img');
            const imageCount = images.length;
            const moreMenuBtn = document.getElementById('more-menu-btn');
            const moreMenuDropdown = document.getElementById('more-menu-dropdown');		            
            const updateLink = document.getElementById('update-link');
            const deleteForm = document.getElementById('delete-form');
            
            let currentIndex = 0;
            let currentBidCount = ${dto.bidCount};
            
            if(carousel) {
            	if(imageCount <= 1) {
            		prevBtn.style.display = 'none';
            		nextBtn.style.display = 'none';
            	} 
            }
            
            if(moreMenuBtn) {
            	moreMenuBtn.addEventListener('click', function(e) {
            		e.stopPropagation();
            		moreMenuDropdown.classList.toggle('hidden');
            	});
            }
            
            document.addEventListener('click', function() {
            	if(moreMenuDropdown && !moreMenuDropdown.classList.contains('hidden')) {
            		moreMenuDropdown.classList.add('hidden');
            	}
            });
            
            
            
            if(updateLink) {
                updateLink.addEventListener('click', function(e) {
                    if(currentBidCount > 0) {
                        alert('입찰이 진행된 경매는 수정할 수 없습니다.');
                        e.preventDefault();
                        return false;
                    }
                    
                    const nowMs = new Date().getTime();
                    const timeLeft = Math.round((endTimeMs - nowMs) / 1000);

                    if (timeLeft <= 0) {
                        alert('마감된 경매는 수정할 수 없습니다.');
                        e.preventDefault(); 
                        return false;
                    }
                    
                    return true;
                    
                });
            }
            
            
            
            if(deleteForm) {
                deleteForm.addEventListener('submit', function(e) {
                    if(currentBidCount > 0) {
                        alert('입찰이 진행된 경매는 삭제할 수 없습니다.');
                        e.preventDefault();
                        return false;
                    }
                    
                    if(!confirm('정말로 이 경매를 삭제하시겠습니까?')) {
                        e.preventDefault();
                        return false;
                    }
                });
            }
            
			
            // 탭 전환
			tabButtonEl.forEach(button => {
				button.addEventListener('click', function() {
					const targetTab = this.dataset.tab;
					
					tabButtonEl.forEach(btn => btn.classList.remove('active'));
					
					this.classList.add('active');
					
					tabPanelEl.forEach(panel => panel.classList.add('hidden'));
					
					document.getElementById(targetTab).classList.remove('hidden');
					
					const badge = this.querySelector('.new-bid-badge');
			        if (badge) {
			            badge.remove();
			        }
				});
			});
				
				
			          
            
            // 상대 시간 계산
            function formatTimeInterval(dateString) {
            	if(!dateString) return '';
            	const now = new Date();
            	const past = new Date(dateString.replace(' ', 'T'));
            	const secondsPast = Math.floor((now.getTime() - past.getTime()) / 1000);
            	
            	if(secondsPast < 60) return '방금 전';
            	if(secondsPast < 3600) return `\${Math.floor(secondsPast / 60)}분 전`;
            	if(secondsPast < 86400) return `\${Math.floor(secondsPast / 3600)}시간 전`;
            	
            	const daysPast = Math.floor(secondsPast / 86400);
            	return `\${daysPast}일 전`;
            }
            
            
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

            let currentPrice = initialData.currentPrice;
            let minIncrement;
            let bidHistory = initialData.bidHistory; 
            let digitReels = [];
            
            function calculateMinIncrement(currentPrice) {

    		    if (currentPrice < 100000) { 
    		        minIncrement = 1000;
    		    } else if (currentPrice < 500000) {
    		        minIncrement = 5000;
    		    } else if (currentPrice < 1000000) { 
    		        minIncrement = 10000;
    		    } else { 
    		        minIncrement = 50000;
    		    }
    		    
    		    return minIncrement;
            }
            
            function updatePlaceholder() {
                minIncrement = calculateMinIncrement(currentPrice);
                const nextValidBid = currentPrice + minIncrement;
                bidAmountInput.placeholder = `\${nextValidBid.toLocaleString('ko-KR')}원 이상`;
            }
            
            
            
            function setupPriceOdometer(price) {
            	const priceString = price.toLocaleString('ko-KR');
            	currentPriceEl.innerHTML = '';
            	digitReels = [];
            	
            	priceString.split('').forEach(ch => {
            		if(!isNaN(parseInt(ch))) {
            			const digitContainer = document.createElement('div');
            			digitContainer.className = 'digit-container';
            			const digitReel = document.createElement('div');
            			digitReel.className = 'digit-reel';
            			for(let i = 0; i <= 9; i++) {
            				const digit = document.createElement('div');
            				digit.textContent = i;
            				digitReel.appendChild(digit);
            			}
            			digitContainer.appendChild(digitReel);
            			currentPriceEl.appendChild(digitContainer);
            			digitReels.push(digitReel);
            			digitReel.style.transform = `translateY(-\${parseInt(ch)}em)`;
            		} else {
            			const commaSpan = document.createElement('span');
            			commaSpan.className = 'comma';
            			commaSpan.textContent = ch;
            			currentPriceEl.appendChild(commaSpan);
            			digitReels.push(null);
            		}
            	});
            	bidAmountInput.placeholder = `\${price.toLocaleString('ko-KR')}원보다 높은 금액`;
            }
            
            function updatePriceOdometer(newPrice, oldPrice) {
            	const newPriceString = newPrice.toLocaleString('ko-KR');
            	const oldPriceString = oldPrice.toLocaleString('ko-KR');
            	
            	if(newPriceString.length !== oldPriceString.length) {
            		setupPriceOdometer(newPrice);
            		return;
            	}
            	
            	newPriceString.split('').forEach((ch, index) => {
            		const reel = digitReels[index];
            		if(reel && ch !== oldPriceString[index]) {
            			reel.style.transform = `translateY(-\${parseInt(ch)}em)`;
            		}
            	});
            	bidAmountInput.placeholder = `\${newPrice.toLocaleString('ko-KR')}원보다 높은 금액`;
            }
            
            function createBidHistory(bid) {
           		const item = document.createElement('div');
           		const myClass = bid.bidder_nickname === currentNickname ? 'my-bid' : '';
           		item.className = 'relative pl-8 pb-1 bid-history-item ' + myClass;
           	
           		const relativeTime = formatTimeInterval(bid.created_at);
           		
           		item.innerHTML = `
           			<div class="dot"></div>
           			<div class="flex justify-between items-center">
           				<p class="font-bold text-white">\${bid.bid_amount.toLocaleString('ko-KR')}원</p>
           				<p class="text-xs text-gray-500">\${relativeTime}</p>
           			</div>
           			<p class="text-sm text-gray-400">입찰자: <span class="bidder-name">\${bid.bidder_nickname === currentNickname ? 'You' : bid.bidder_nickname}</span></p>
           			`;
           		return item;
            }
             
            function renderBidHistory() {
            	bidHistoryEl.innerHTML = '';
            	
            	if(bidHistory.length === 0) {

            		bidHistoryEl.innerHTML = `
            	        <div class="text-center flex flex-col items-center space-y-4">
            	            <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            	                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8.25 7.5l.415-.207a.75.75 0 011.085.67V10.5m0 0h6m-6 0a.75.75 0 001.085.67l.415-.207m-7.5 0V7.5c0-1.28.64-2.48 1.67-3.235S10.72 3 12 3c1.28 0 2.48.64 3.235 1.67S16.92 6.22 16.92 7.5v3.081m-7.5 0h7.5M4.5 12.081V18c0 1.105.895 2 2 2h11c1.105 0 2-.895 2-2V12.081" />
            	            </svg>
            	            <div>
            	                <p class="font-semibold text-gray-300">아직 입찰 기록이 없습니다.</p>
            	                <p class="text-sm">가장 먼저 입찰하여 경매를 시작해보세요!</p>
            	            </div>
            	        </div>
            	    `;
            	} else {
	            	
           	        bidHistory.forEach(bid => {
	           			bidHistoryEl.appendChild(createBidHistory(bid));            	
	            	});
            	}
            	
            }
            
            setupPriceOdometer(currentPrice);
            renderBidHistory();
            updatePlaceholder();
                        
            
            let timerInterval;
            let endTimeMs = new Date(initialData.endTime).getTime();
            
            function updateCountdown() {
                const nowMs = new Date().getTime();
                let timeLeft = Math.round((endTimeMs - nowMs) / 1000);
                
                if (timeLeft < 3600) {
                    countdownEl.classList.add('text-red-400');
                } else {
                    countdownEl.classList.remove('text-red-400');
                }

                if (timeLeft <= 0) {
                    clearInterval(timerInterval);
                    
                    const url = '/auction/status/${dto.auction_id}';
                    const callback = function(response) {
                    	
                    	if (response.status === 'success') {
                            let statusHtml = '';
                            if (response.auctionStatus === 'ENDED_SUCCESS') {
                                statusHtml = `<div class="text-2xl font-bold text-orange-400">낙찰 완료</div>`;
                                
                            } else {
                                statusHtml = `<div class="text-2xl font-bold text-gray-500">유찰</div>`;
                            }
                            countdownEl.innerHTML = statusHtml;
                        } else {
                            countdownEl.innerHTML = `<div class="text-2xl font-bold text-gray-500">경매 종료</div>`;
                        }
                    }
                    
                    ajaxRequest(url, 'GET', null, 'json', callback);
                    
                    if (countdownLabel) {
                        countdownLabel.style.display = 'none';
                    }
                    
                    bidButton.disabled = true;
                    bidAmountInput.disabled = true;
                    bidAmountInput.placeholder = '마감된 경매입니다';
                    bidIncrementBtns.forEach(btn => btn.disabled = true);
                    return;
                }
                timeLeft--;
                const d = Math.floor(timeLeft / (24 * 60 * 60));
                const h = Math.floor((timeLeft % (24 * 60 * 60)) / (60 * 60));
                const m = Math.floor((timeLeft % (60 * 60)) / 60);
                const s = timeLeft % 60;
                
                countdownEl.innerHTML = `
                	<div class="timer-segment p-3 rounded-lg w-16"><div class="text-3xl font-display">\${String(d).padStart(2, '0')}</div><div class="text-xs text-gray-500">일</div></div>
                	<div class="timer-segment p-3 rounded-lg w-16"><div class="text-3xl font-display">\${String(h).padStart(2, '0')}</div><div class="text-xs text-gray-500">시간</div></div>
                	<div class="timer-segment p-3 rounded-lg w-16"><div class="text-3xl font-display">\${String(m).padStart(2, '0')}</div><div class="text-xs text-gray-500">분</div></div>
                	<div class="timer-segment p-3 rounded-lg w-16"><div class="text-3xl font-display">\${String(s).padStart(2, '0')}</div><div class="text-xs text-gray-500">초</div></div>
				`;
            }
            
            // --- 시간 연장 애니메이션 ---
            function animateCountdown(newEndTimeString) {
			    const newEndTimeMs = new Date(newEndTimeString.replace(' ', 'T')).getTime();
			    const oldEndTimeMs = endTimeMs;
			    endTimeMs = newEndTimeMs; 
			
			    const animationDuration = 1000; 
			    const startTime = Date.now();
			
			    function frame() {
			        const now = Date.now();
			        const progress = Math.min(1, (now - startTime) / animationDuration);
			        
			        const animatedTimeMs = oldEndTimeMs + (newEndTimeMs - oldEndTimeMs) * progress;
			        
			        const timeLeft = Math.round((animatedTimeMs - new Date().getTime()) / 1000);
			        const d = Math.floor(timeLeft / (24 * 60 * 60));
	                const h = Math.floor((timeLeft % (24 * 60 * 60)) / (60 * 60));
	                const m = Math.floor((timeLeft % (60 * 60)) / 60);
	                const s = timeLeft % 60;
	                
	                countdownEl.innerHTML = `
	                	<div class="timer-segment p-3 rounded-lg w-16"><div class="text-3xl font-display">\${String(d).padStart(2, '0')}</div><div class="text-xs text-gray-500">일</div></div>
	                	<div class="timer-segment p-3 rounded-lg w-16"><div class="text-3xl font-display">\${String(h).padStart(2, '0')}</div><div class="text-xs text-gray-500">시간</div></div>
	                	<div class="timer-segment p-3 rounded-lg w-16"><div class="text-3xl font-display">\${String(m).padStart(2, '0')}</div><div class="text-xs text-gray-500">분</div></div>
	                	<div class="timer-segment p-3 rounded-lg w-16"><div class="text-3xl font-display">\${String(s).padStart(2, '0')}</div><div class="text-xs text-gray-500">초</div></div>
					`;
			
			        if (progress < 1) {
			            requestAnimationFrame(frame); 
			        }
			    }
			    requestAnimationFrame(frame); 
			}
            
            timerInterval = setInterval(updateCountdown, 1000);
            updateCountdown();
            
        	// --- Bid(입찰 ajax) ---
            function handleNewBid(newBidAmount) {
            	
            	const url = '/auction/bid/${dto.auction_id}';
            	
    			const params = {bidAmount : newBidAmount};
    			
    			const callback = function(response) {
        			if(response.status === 'success') {
        				const newBid = response.newBid;
        				const updatedAuction = response.updatedAuction;
        				const isExtended = response.timeExtended;
        				
        				if (updatedAuction.end_time && isExtended) {
        	                
        	                clearInterval(timerInterval);
        	                animateCountdown(updatedAuction.end_time);
        	                
        	                setTimeout(() => {
        	                    timerInterval = setInterval(updateCountdown, 1000);
        	                }, 1000);
        	            }
        				
    		        	const oldPrice = currentPrice;
    		        	currentPrice = newBid.bid_amount;
    		  
    		        	updatePriceOdometer(currentPrice, oldPrice);
    		        	updatePlaceholder();
    		        	
    		        	if(bidHistory.length === 0) {
    		        		bidHistoryEl.innerHTML = '';
    		        	}
    		        	
    		        	const newBidItem = createBidHistory(newBid);
    		        	bidHistoryEl.prepend(newBidItem);
    		        	
    		        	bidHistory.unshift(newBid);

    		        	if(newBid.bidder_nickname === currentNickname) {
    		                topBidderEl.innerHTML = `
    		                	<span class="font-bold text-yellow-400 text-lg drop-shadow-sm">
				                <span class="relative crown-sparkle">
				                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" class="mr-0.5 inline align-middle">
				                        <path d="M5 16L3 7l5.5 4L12 4l3.5 7L21 7l-2 9H5z"
				                              fill="#fbbf24"
				                              stroke="#f59e0b"
				                              stroke-width="1.5"
				                              stroke-linejoin="round"/>
				                        <circle cx="12" cy="8" r="1.5" fill="#ef4444"/>
				                        <circle cx="8.5" cy="10" r="1" fill="#3b82f6"/>
				                        <circle cx="15.5" cy="10" r="1" fill="#10b981"/>
				                        <rect x="4" y="16" width="16" height="2" fill="#f59e0b" rx="1"/>
				                        <path d="M6 8l2 3 4-7 2 4"
				                              stroke="rgba(255,255,255,0.3)"
				                              stroke-width="1"
				                              fill="none"
				                              stroke-linecap="round"/>
				                    </svg>
				                    </span>
				                    <span>You</span>
				                </span>
    		                `;
    		            } else {
    		                topBidderEl.innerHTML = `<span class="text-gray-300">\${newBid.bidder_nickname}</span>`;
    		            }
            			
    		        	bidAmountInput.value = '';
    		        	
    		        	currentBidCount++;
    		        	
    		        	const bidTabButton = document.querySelector('.tab-btn[data-tab="bids"]');
    		        	if(bidTabButton) {
    		        		bidTabButton.querySelector('.bid-count').textContent = `(\${currentBidCount})`;
    		        		bidTabButton.click();
    		        	}
    		        	
    		        	if(websocket && websocket.readyState === WebSocket.OPEN) {
    		        		const message = {
    		        			type: 'NEW_BID',
    		        			auction_id: ${dto.auction_id},
    		        			newBid: newBid,
    		        			updatedAuction: updatedAuction,
    		        			isExtended: isExtended
    		        		};
    		        		
    		        		websocket.send(JSON.stringify(message));
    		        	}

        			} else {
        				alert(response.message);
        			}
        		};
            	
        		ajaxRequest(url, 'POST', params, 'json', callback);
            }

            // -- 입찰하기 버튼 이벤트 ---
            bidButton.addEventListener('click', () => {
            	const isLogin = ${not empty sessionScope.member};
            	const isAlreadyTopBidder = (document.querySelector('#top-bidder .crown-sparkle') !== null); 
				let confirmMsg = '';
				
            	if(!isLogin) {
            		alert('로그인 후 이용 가능합니다.');
            		location.href = '<c:url value="/member/login"/>';
            		return;
            	}
            	
            	const amount = parseInt(bidAmountInput.value);
            	if(isNaN(amount) || amount <=0) {
            		alert('올바른 금액을 입력해주세요.');
            		bidAmountInput.value = '';
            		return;
            	}
            	
            	if(currentNickname === '${dto.seller_nickname}') {
            		alert('자신이 등록한 경매에는 입찰할 수 없습니다.');
            		bidAmountInput.value = '';
            		return;
            	}
            	
            	minIncrement = calculateMinIncrement(currentPrice);
            	const nextValidBid = currentPrice + minIncrement;
            	if (amount < nextValidBid) {
            		alert(`\${nextValidBid.toLocaleString('ko-KR')}원 이상 입찰 가능합니다.`);
            		bidAmountInput.value = '';
                    return;
                }
            	
            	if(isAlreadyTopBidder) {
            		confirmMsg = `현재 최고 입찰자입니다. 입찰액을 \${amount.toLocaleString('ko-KR')}원으로 올리시겠습니까?`;
            	} else {
            		confirmMsg = `\${amount.toLocaleString('ko-KR')}원으로 입찰하시겠습니까?\n\n입찰 후에는 취소가 불가능합니다.`
            	}
             	
            	if(!confirm(confirmMsg)) {
            		return;
            	}
            	
            	handleNewBid(amount); 
            });
            
            bidIncrementBtns.forEach(button => {
            	button.addEventListener('click', () => {
            		const increment = parseInt(button.dataset.increment);
            		const currentBid = parseInt(bidAmountInput.value) || currentPrice;
            		bidAmountInput.value = currentBid + increment;
            	});
            });
            
         	// --- WebSocket 연결 ---
         	let websocket = null;
         	
         	function connectWebSocket() {
         		const serverName = "${serverName}";
         		const serverPort = "${serverPort}";	
         		const wsUrl = `ws://\${serverName}:\${serverPort}/ws/auction`;
         		websocket = new WebSocket(wsUrl);
         		
         		websocket.onopen = function(e) {
         			console.log('WEBSOCKET 연결 성공!');
         			const joinMessage = {
         				type: 'JOIN',
         				auction_id: ${dto.auction_id}
         			}
         			
         			websocket.send(JSON.stringify(joinMessage));
         		};
         		
         		websocket.onmessage = function(e) {
         			
         			const message = JSON.parse(e.data);
         			
         			if(message.type === 'NEW_BID') {
         				const currentAuctionId = ${dto.auction_id};
         				if(message.auction_id === currentAuctionId) {
         					const newBid = message.newBid;
         					const updatedAuction = message.updatedAuction;
         					const isExtended = message.isExtended;
         					
         					const oldPrice = currentPrice;
         					currentPrice = updatedAuction.current_price;
         					
            				if (updatedAuction.end_time && isExtended) {
            	                
            	                clearInterval(timerInterval);
            	                animateCountdown(updatedAuction.end_time);
            	                
            	                setTimeout(() => {
            	                    timerInterval = setInterval(updateCountdown, 1000);
            	                }, 1000);
            	            }
            				
        		        	updatePriceOdometer(currentPrice, oldPrice);
        		        	updatePlaceholder();
        		        	
        		        	if(bidHistory.length === 0) {
        		        		bidHistoryEl.innerHTML = '';
        		        	}
        		        	
        		        	const newBidItem = createBidHistory(newBid);
        		        	bidHistoryEl.prepend(newBidItem);
        		        	
        		        	bidHistory.unshift(newBid);

							topBidderEl.innerHTML = `<span class="text-gray-300">\${newBid.bidder_nickname}</span>`;
                			
        		        	currentBidCount++;
        		        	
        		        	const bidTabButton = document.querySelector('.tab-btn[data-tab="bids"]');
        		        	if(bidTabButton) {
        		        		bidTabButton.querySelector('.bid-count').textContent = `(\${currentBidCount})`;
        		        		
        		        		if (!bidTabButton.classList.contains('active')) {
        		                    if (!bidTabButton.querySelector('.new-bid-badge')) {
        		                        const badge = document.createElement('span');
        		                        badge.className = 'new-bid-badge';
        		                        bidTabButton.appendChild(badge);
        		                    }
        		                }
        		        	}
        		        	
         				}
         			}
         		};
         		
         		websocket.onclose = function(e) {
         			
         		};
         		
         		websocket.onerror = function(e) {
         			
         		};
         	}
            
         	connectWebSocket();
            
            
            
        });
    </script>
<script src="${pageContext.request.contextPath}/dist/js/leftProduct.js"></script>
</body>
</html>