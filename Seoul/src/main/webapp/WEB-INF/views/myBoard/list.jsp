<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seoul</title>
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
		            <h1 class="text-3xl font-bold text-gray-900">내가 쓴글</h1>
	    	        <p class="text-gray-600 mt-1">회원님이 작성한 글 목록입니다.</p>    	        	
            	</header>
            
               <div class="grid grid-cols-1 md:grid-cols-1 lg:grid-cols-1 gap-6" id="myboard-list">
				    <c:forEach var="dto" items="${list}">
				        <div class="flex bg-white rounded-lg shadow-md overflow-hidden transform hover:shadow-xl transition-all duration-300">
				            <a href="<c:url value='/bbs/article?num=${dto.num}&page=1&region=${dto.region_id}'/>" class="flex items-center w-full p-4">
				                <div class="flex-grow">
				                    <h2 class="text-lg font-semibold text-gray-800 truncate">${dto.subject}</h2>
				                    <div class="flex items-center text-sm text-gray-500 mt-3">
				                        <span class="mr-3">
				                            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 inline-block mr-1 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
				                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
				                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
				                            </svg>
				                            <span>${dto.hit_count}</span>
				                        </span>
				                        <span class="mr-3">
				                            <span class="text-sm font-medium text-gray-700">작성자: ${dto.nickname}</span>
				                        </span>
				                        <span>
				                            <span>${dto.reg_date}</span>
				                        </span>
				                    </div>
				                </div>
				            </a>
				        </div>
				    </c:forEach>
        
                    <c:if test="${empty list}">
                        <div class="col-span-full text-center py-12">
                            <p class="text-gray-500">작성한 글이 없습니다.</p>
                        </div>
                    </c:if>
                </div>
            </main>  
          </div>
        </div>
    </body>
</html>
