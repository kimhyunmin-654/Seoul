<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/leftProduct.css" type="text/css">
<nav class="sidebar-nav-container">

    <!-- 지역 선택 -->
    <div class="sidebar-section">
        <div class="sidebar-title">
		    <span class="region-label label-text" data-default-label="지역 선택">지역 선택</span>
	        <span class="arrow-icon">▼</span>
    	</div>
        <ul class="sidebar-list" style="display: none;">
            <li><a href="${pageContext.request.contextPath}/${currentMenu}" class="sub-region-link ${empty param.region ? 'active' : ''}" data-region-id="">전체</a></li>
            <c:forEach var="region" items="${regionList}">
                <li>
                    <a href="${pageContext.request.contextPath}/${currentMenu}?region=${region.region_id}" 
                       class="sub-region-link ${param.region == region.region_id ? 'active' : ''}" 
                       data-region-id="${region.region_id}">${region.region_name}</a>
                </li>
            </c:forEach>
        </ul>
    </div>

    <!-- 카테고리 선택 -->
    <div class="sidebar-section">
        <div class="sidebar-title">
	        <span class="category-label label-text">카테고리</span>
	        <span class="arrow-icon">▼</span>
    	</div>
        <ul class="sidebar-list" style="display: none;">
            <li><a href="${pageContext.request.contextPath}/${currentMenu}" class="category-link ${empty param.category_id ? 'active' : ''}" data-category-id="">전체</a></li>
            <c:forEach var="category" items="${categoryList}">
                <li>
                    <a href="${pageContext.request.contextPath}/${currentMenu}?category_id=${category.category_id}" 
                       class="category-link ${param.category_id == category.category_id ? 'active' : ''}" 
                       data-category-id="${category.category_id}">${category.category_name}</a>
                </li>
            </c:forEach>
        </ul>
    </div>
</nav>


