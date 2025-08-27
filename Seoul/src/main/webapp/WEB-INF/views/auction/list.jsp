<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>경매 - 서울한바퀴</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&family=Bai+Jamjuree:wght@600;700&display=swap" rel="stylesheet">
    <style>
    	body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f3f4f6;
        }
    	
        #auction-wrapper {
            background: linear-gradient(180deg, #1f2937, #111827);
            color: #d1d5db;
            border-radius: 1.5rem; 
            box-shadow: 0 25px 50px -12px rgb(0 0 0 / 0.25);
        }
        
        #auction-wrapper .font-display {
            font-family: 'Bai Jamjuree', sans-serif;
        }
        
        #auction-wrapper .hero-section h1 {
            font-size: 2.5rem; 
            line-height: 1.2;
        }
        #auction-wrapper .hero-section .price-time-group {
            margin-top: 1.5rem; 
        }
        #auction-wrapper .hero-section .price-time-group > div p:first-child {
            margin-bottom: 0.25rem; 
        }
        
        #auction-wrapper .filter-pane {
            padding: 0.75rem; 
            margin-bottom: 1.5rem; 
        }
        
        #auction-wrapper .product-card .card-body {
            padding: 1rem; 
        }
        #auction-wrapper .product-card .card-body p {
            margin-bottom: 0.25rem;
        }
        #auction-wrapper .product-card .card-body .price-text {
            margin-bottom: 0.75rem; 
        }
        
        #auction-wrapper .glass-pane {
            background: rgba(31, 41, 55, 0.5); 
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(55, 65, 81, 0.3);
        }
        #auction-wrapper .hero-glow {
            background: radial-gradient(circle at 50% 50%, rgba(251, 146, 60, 0.15), transparent 70%);
        }
        
        #auction-wrapper .card-glow {
             box-shadow: 0 0 15px rgba(55, 65, 81, 0.5);
        }
        #auction-wrapper .vertical-nav {
            background-color: transparent; 
        }
        #auction-wrapper .vertical-nav .region-label,
        #auction-wrapper .vertical-nav .sub-region-link {
            color: #d1d5db; 
        }
        #auction-wrapper .vertical-nav .sub-region-link:hover {
            color: #fb923c; 
            background-color: rgba(251, 146, 60, 0.1);
        }
        #auction-wrapper .grid-container {
        	min-height: 750px; 
    	}
    	@layer base {
        	a:link,
        	a:visited,
        	a:hover,
        	a:active {
        		text-decoration:none !important;
        	}
        }
    </style>
</head>
<body class="text-gray-200">
	
	<header>
		<jsp:include page="/WEB-INF/views/layout/header.jsp"/>		
		<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>		
				
	</header>
	
  <div id="auction-wrapper" class="container mx-auto max-w-7xl my-8">
  
    <div class="p-4 sm:p-6 lg:p-8">
		<div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
		
			<aside class="col-span-4 lg:col-span-1">
				<div class="sticky top-8">
					<jsp:include page="/WEB-INF/views/layout/left.jsp"/>
				</div>			
			</aside>
			
			<main class="col-span-4 lg:col-span-3">
		        <c:if test="${not empty featuredAuction}">
		            <div class="hero-section relative hero-glow rounded-3xl overflow-hidden mb-12" style="background-image: url(<c:url value='/uploads/product/${featuredAuction.thumbnail}'/>); background-size: cover; background-position: center;">
		                <div class="absolute inset-0 w-full h-full bg-black/70"></div>
		                <div class="relative p-8 md:p-16 flex flex-col justify-center items-start h-full">
		                    <h1 class="text-4xl md:text-6xl font-black text-white leading-tight max-w-2xl">${featuredAuction.product_name}</h1>
		                    <div class="price-time-group mt-6 flex items-center space-x-6">
		                        <div>
		                            <p class="text-sm font-medium text-gray-400">현재 최고가</p>
		                            <p class="text-4xl font-bold text-orange-400">
		                                <fmt:formatNumber value="${featuredAuction.current_price}" pattern="#,##0"/>원
		                            </p>
		                        </div>
		                        <div>
		                            <p class="text-sm font-medium text-gray-400">남은 시간</p>
		                            <p class="countdown-timer text-4xl font-bold ${featuredAuction.urgent ? 'text-red-400' : 'text-white'}" data-endtime="${featuredAuction.end_time}" data-timer-type="featured">${featuredAuction.remainingTime}</p>
		                        </div>
		                    </div>
		                    <a href="<c:url value='/auction/detail/${featuredAuction.auction_id}'/>" class="mt-8 bg-orange-500 hover:bg-orange-400 text-white font-bold text-lg py-3 px-8 rounded-lg transition-colors shadow-lg">
		                        지금 입찰하기
		                    </a>
		                </div>
		            </div>
		        </c:if>
		
		        <div class="filter-pane glass-pane p-2 rounded-xl mb-4 flex flex-col sm:flex-row justify-between items-center gap-4">
		            <div class="flex space-x-2">
		                <button class="category-link category-all bg-gray-700/50 hover:bg-gray-700 text-white font-semibold py-0 px-3 h-8 rounded-md transition-colors text-sm" data-category-id="">전체</button>
		                <c:forEach var="category" items="${categoryList}">
		                    <button class="category-link hover:bg-gray-700/50 text-gray-400 font-semibold py-0 px-3 h-8 rounded-md transition-colors text-sm" data-category-id="${category.category_id}">${category.category_name}</button>
		                </c:forEach>
		            </div>
		            <div>
		                <select class="sort-box bg-gray-700/50 border border-gray-600 text-white text-sm rounded-md focus:ring-orange-500 focus:border-orange-500 block w-full p-2.5">
		                    <option value="ending_asc" selected>마감 임박순</option>
						    <option value="bid_desc">인기순(입찰 많은 순)</option>
						    <option value="latest_desc">최신 등록순</option>
						    <option value="price_desc">높은 가격순</option>
						    <option value="price_asc">낮은 가격순</option>
		                </select>
		            </div>
		        </div>
		
				<div id="auction-grid" class="grid grid-cols-2 md:grid-cols-3 gap-6 grid-container">
					<c:choose>
						<c:when test="${not empty list}">
					            <c:forEach var="vo" items="${list}">
					            	<a href="<c:url value='/auction/detail/${vo.auction_id}'/>">
						                <div class="product-card glass-pane rounded-2xl overflow-hidden card-glow transform hover:-translate-y-2 transition-transform duration-300">
						                    <div class="relative">
						                        <img src="<c:url value='/uploads/product/${vo.thumbnail}'/>" class="w-full h-56 object-cover" alt="경매 상품">
						                        <c:if test="${vo.hot && vo.status == 'IN_PROGRESS'}">
						                             <div class="absolute top-3 right-3 bg-red-600 text-white text-xs font-bold px-2 py-1 rounded-full animate-pulse">HOT</div>
						                        </c:if>
						                        <c:if test="${vo.status != 'IN_PROGRESS'}">
							                        <div class="absolute inset-0 bg-black/50 flex items-center justify-center">
							                        	<c:choose>
													        <c:when test="${vo.status == 'ENDED_SUCCESS'}">
			 													    <div class="w-20 h-20 border-3 border-orange-500 rounded-full flex items-center justify-center bg-black/30 backdrop-blur-sm transform rotate-12">
																      <span class="text-orange-400 font-black text-base tracking-wide">낙찰</span>
																    </div>
															</c:when>
															<c:otherwise>
															  <div class="w-20 h-20 border-2 border-gray-500 rounded-full flex items-center justify-center bg-gray-800/60 backdrop-blur-sm transform -rotate-6">
															    <span class="text-gray-400 font-bold text-base">유찰</span>
															  </div>
															</c:otherwise>
													    </c:choose>
							                        </div>
							                    </c:if>
						                    </div>
						                    <div class="p-4 card-body">
						                        <h3 class="font-bold text-lg text-white truncate">${vo.product_name}</h3>
						                        <p class="text-sm text-gray-400 mb-0">현재 최고가</p>
						                        <p class="price-text text-2xl font-bold text-orange-400">
						                            <fmt:formatNumber value="${vo.current_price}" pattern="#,##0"/>원
						                        </p>
						                        <div class="mt-3 flex justify-between items-center text-sm">
						                            <span class="text-gray-400">입찰 ${vo.bidCount}회</span>
						                            <c:choose>
											            <c:when test="${vo.status == 'IN_PROGRESS'}">
											                <span class="countdown-timer font-semibold ${vo.urgent ? 'text-red-400' : 'text-gray-300'}"
														          data-endtime="${vo.end_time}">
														        ${vo.remainingTime} 남음
														    </span>
											            </c:when>
											            <c:otherwise>
															<span class="font-semibold text-gray-500">경매 마감</span>
														</c:otherwise>
											        </c:choose>
						                        </div>
						                    </div>
						                </div>
					              	</a>
					            </c:forEach>
						</c:when>
						<c:otherwise>
						 <div class="col-span-full h-full flex items-center justify-center">
					         <div class="text-center text-gray-500">
					            <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-16 w-16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
					            </svg>
					            <h3 class="mt-4 text-xl font-bold text-white">검색 결과가 없습니다.</h3>
					        </div>
					     </div>
					    </c:otherwise>
					</c:choose>
				</div>
		
		        <div class="text-center mt-12">
			        <c:if test="${page < totalPage}">
			            <button id="load-more-btn" class="glass-pane hover:bg-gray-700/80 text-white font-bold py-3 px-8 rounded-lg transition-colors">
			                더 많은 경매 보기
			            </button>
			        </c:if>
		        </div>
			</main>
		</div>
    </div>
  </div>
  <jsp:include page="/WEB-INF/views/layout/leftResources.jsp"></jsp:include>
  <script type="text/javascript">
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
  <script type="text/javascript">
  
  function startTimer() {
	  const countdownElements = document.querySelectorAll('.countdown-timer:not([data-timer-initialized])');

      countdownElements.forEach(el => {
    	  
    	  el.setAttribute('data-timer-initialized', 'true');
          
          const endTimeString = el.dataset.endtime;
          if (!endTimeString) return;

          const endTimeMs = new Date(endTimeString.replace(' ', 'T')).getTime();

          const timerInterval = setInterval(() => {
              const nowMs = new Date().getTime();
              const timeLeft = Math.max(0, Math.round((endTimeMs - nowMs) / 1000));
              
              if (timeLeft <= 0) {
                  el.textContent = '경매 마감';
                  el.classList.remove('text-red-400');
                  el.classList.add('text-gray-500');
                  clearInterval(timerInterval); 
                  return;
              }

              const d = Math.floor(timeLeft / 86400);
              const h = Math.floor((timeLeft % 86400) / 3600);
              const m = Math.floor((timeLeft % 3600) / 60);
              const s = timeLeft % 60;
              
              const type = el.dataset.timerType;
              const suffix = (type === 'featured') ? '' : ' 남음';

              if(d > 0) {
            	  el.textContent = d + '일 ' + 
                  String(h).padStart(2, '0') + ':' + 
                  String(m).padStart(2, '0') + ':' + 
                  String(s).padStart(2, '0') + suffix;
              } else {
            	  el.textContent = String(h).padStart(2, '0') + ':' + 
                  String(m).padStart(2, '0') + ':' + 
                  String(s).padStart(2, '0') + suffix;
              }
              
          }, 1000);
          
          el.dataset.intervalId = timerInterval;
      });
	}
  
  function generateCardHtml(vo) {
      let statusBadge = '';
      let statusOverlay = '';
      let timerHtml = '';
      
      
      if (vo.hot && vo.status === 'IN_PROGRESS') {
          statusBadge = '<div class="absolute top-3 right-3 bg-red-600 text-white text-xs font-bold px-2 py-1 rounded-full animate-pulse">HOT</div>';
      }
      
      
      if (vo.status !== 'IN_PROGRESS') {
    	  if (vo.status === 'ENDED_SUCCESS') {
              statusOverlay = '<div class="absolute inset-0 bg-black/50 flex items-center justify-center">' +
                              '<div class="w-20 h-20 border-3 border-orange-500 rounded-full flex items-center justify-center bg-black/30 backdrop-blur-sm transform rotate-12">' +
                              '<span class="text-orange-400 font-black text-base tracking-wide">낙찰</span>' +
                              '</div></div>';
          } else {
              statusOverlay = '<div class="absolute inset-0 bg-black/50 flex items-center justify-center">' +
                              '<div class="w-20 h-20 border-2 border-gray-500 rounded-full flex items-center justify-center bg-gray-800/60 backdrop-blur-sm transform -rotate-6">' +
                              '<span class="text-gray-400 font-bold text-base">유찰</span>' +
                              '</div></div>';
          }
      }
      
      
      if (vo.status === 'IN_PROGRESS') {
          const urgentClass = vo.urgent ? 'text-red-400' : 'text-gray-300';
          timerHtml = '<span class="countdown-timer font-semibold ' + urgentClass + '" data-endtime="' + vo.end_time + '">' + vo.remainingTime + ' 남음</span>';
      } else {
          timerHtml = '<span class="font-semibold text-gray-500">경매 마감</span>';
      }
      
      const formattedPrice = new Intl.NumberFormat('ko-KR').format(vo.current_price);

      return '<a href="/auction/detail/' + vo.auction_id + '">' +
		      '<div class="product-card glass-pane rounded-2xl overflow-hidden card-glow transform hover:-translate-y-2 transition-transform duration-300">' +
		      '<div class="relative">' +
		      '<img src="/uploads/product/' + vo.thumbnail + '" class="w-full h-56 object-cover" alt="경매 상품">' +
		      statusBadge + statusOverlay +
		      '</div>' +
		      '<div class="p-4 card-body">' +
		      '<h3 class="font-bold text-lg text-white truncate">' + vo.product_name + '</h3>' +
		      '<p class="text-sm text-gray-400 mb-0">현재 최고가</p>' +
		      '<p class="price-text text-2xl font-bold text-orange-400">' + formattedPrice + '원</p>' +
		      '<div class="mt-3 flex justify-between items-center text-sm">' +
		      '<span class="text-gray-400">입찰 ' + vo.bidCount + '회</span>' +
		      timerHtml +
		      '</div></div></div></a>';
  }
  
    $(function() {
		
        let currentPage = parseInt("${page}");
        let currentKwd = "${cond.kwd}";
        let currentCategoryId = "${cond.category_id}";
       	let currentRegionId = "${cond.region}";
       	let currentSort = "${cond.sort}";
        
        let url = '/auction/list/ajax';
        let searchEl = $('.searchbar input[name=kwd]');
    	
        const auctionGrid = $('#auction-grid');
        const loadMoreBtn = $('#load-more-btn');
        
        startTimer();
        
        // 더보기 요청
        function loadMore() {
        	
        	if (loadMoreBtn.hasClass('loading')) {
                 return;
            }
        	 
        	loadMoreBtn.addClass('loading').text('로딩 중...');
        	currentPage++;
        	
        	const params = {
                page: currentPage,
                kwd: currentKwd,
                category_id: currentCategoryId,
                region: currentRegionId,
                sort: currentSort,
                type: 'AUCTION'
            };
            
            const callback = function(data) {
            	
                loadMoreBtn.removeClass('loading').text('더 많은 경매 보기');
            	
            	if (data.list && data.list.length > 0) {
                    let cardHtml = '';
                    
                    $.each(data.list, function(index, vo) {
                    	cardHtml += generateCardHtml(vo); 
                    });
                    
                    auctionGrid.append(cardHtml);
                    startTimer();
            	}
            	
	           	if (currentPage >= data.totalPage) {
	                   loadMoreBtn.hide();
	            }
        };
        
	        ajaxRequest(url, 'GET', params, 'json', callback);    	
    };
        
        // 데이터 필터링 요청
        function applyFilter() {
        	currentPage = 1;
        	
        	const params = {
       			page: currentPage,
                kwd: currentKwd,
                category_id: currentCategoryId,
                region: currentRegionId,
                sort: currentSort,
                type: 'AUCTION'
        	};
        	
        	const callback = function(data) {
        		
                loadMoreBtn.removeClass('loading').text('더 많은 경매 보기');
        		auctionGrid.empty();
        		
        		if(data.list && data.list.length > 0) {
					let cardHtml = '';
                    
					$.each(data.list, function(index, vo) {
						cardHtml += generateCardHtml(vo); 
                    });
                    
					auctionGrid.append(cardHtml);
        		} else {
        			const noResultHtml = `
        				<div class="col-span-full h-full flex items-center justify-center">
				         <div class="text-center text-gray-500">
				            <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-16 w-16" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
				            </svg>
				            <h3 class="mt-4 text-xl font-bold text-white">검색 결과가 없습니다.</h3>
				        </div>
				     </div>
        	        `;
        	        auctionGrid.html(noResultHtml);
        		}
        		
        		startTimer();
        		
        		if (currentPage >= data.totalPage) {
        			loadMoreBtn.hide();
        		} else {
        			loadMoreBtn.show();
        		}
        	};
        	
        	ajaxRequest(url, 'GET', params, 'json', callback);
        };
        
        function updateCategoryButtons(selectedCategoryId) {
            $('.category-link').removeClass('bg-gray-700/50 text-white').addClass('text-gray-400');
            if (selectedCategoryId === '' || selectedCategoryId === null || selectedCategoryId === undefined) {
                $('.category-all').removeClass('text-gray-400').addClass('bg-gray-700/50 text-white');
            } else {
                $('.category-link[data-category-id="' + selectedCategoryId + '"]')
                    .removeClass('text-gray-400').addClass('bg-gray-700/50 text-white');
            }
        }
		
        loadMoreBtn.on('click', loadMore);
        
        $(document).on('click', '.sub-region-link', function(e) {  
        	e.preventDefault();
        	
        	currentKwd = '';
        	currentCategoryId = '';
        	searchEl.val('');
        	
        	updateCategoryButtons('');
        	
        	currentRegionId = $(this).data('region-id');
        	applyFilter();        	
        });
        
        $(document).on('click', '.category-link', function(e) {  
        	e.preventDefault();
        	
        	const selectedCategoryId = $(this).data('category-id');
            updateCategoryButtons(selectedCategoryId);
        	
        	currentKwd = '';
        	searchEl.val('');
        	
        	currentCategoryId = selectedCategoryId;
        	applyFilter();        	
        });
        
        $('.searchbar').on('submit', function(e) {
        	e.preventDefault();
        	
        	currentKwd = searchEl.val();
        	applyFilter();
        	
        });
        
        $('.sort-box').on('change', function() {
            currentSort = $(this).val();
            applyFilter();
        });
        
        function setChip(targetElement, text, filterType) {
            const labelSpan = $(targetElement);
            if (!labelSpan.data('default-label')) {
                labelSpan.data('default-label', labelSpan.text());
            }
            const chipHtml = `
                <span class="filter-chip" data-filter-type="\${filterType}">
                    \${text} <button class="clear-chip-btn">&times;</button>
                </span>`;
            labelSpan.html(chipHtml);
        }
        
        
        loadMoreBtn.on('click', loadMore);
        
        $('.nav-menu').on('click', '.sub-region-link', function(e) {  
        	e.preventDefault();
        	
        	currentKwd = '';
        	searchEl.val('');
        	
        	currentRegionId = $(this).data('region-id');
        	
        	const regionLabel = $('.region-select').find('.region-label');
            setChip(regionLabel, $(this).text().trim(), 'region');
            
            applyFilter();
        	      	
        });
        
        $('.nav-menu').on('click', '.category-link[data-category-id]', function(e) {  
        	e.preventDefault();
        	
        	const selectedCategoryId = $(this).data('category-id');

        	currentKwd = '';
        	currentCategoryId = '';
        	searchEl.val('');
        	
        	updateCategoryButtons(selectedCategoryId);
        	
        	currentCategoryId = selectedCategoryId;
        	const categoryLabel = $('.category-link').not('[data-category-id]').find('.category-label');
            setChip(categoryLabel, $(this).text().trim(), 'category');
        	
        	applyFilter();        	
        });
        
        $('.nav-menu').on('click', '.clear-chip-btn', function(e) {
        	e.stopPropagation();
        	
            const chip = $(this).closest('.filter-chip');
            const filterType = chip.data('filter-type');
            const labelSpan = chip.parent();
            
            const defaultLabel = labelSpan.data('default-label');
            labelSpan.html(defaultLabel); 

           
            if (filterType === 'region') {
                currentRegionId = ''; 
            } else if (filterType === 'category') {
                currentCategoryId = '';
                updateCategoryButtons('');
            }
            
            applyFilter(); 
        });
        
        
    });

</script>
  
</body>
</html>