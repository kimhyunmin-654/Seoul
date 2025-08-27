<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<style>

/* X 버튼 */
.filter-chip {
  display: inline-flex;
  align-items: center;
  background: #e5e7eb;
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 0.875rem;
}
.filter-chip button {
  margin-left: 6px;
  color: #6b7280;
  cursor: pointer;
}
</style>

<nav class="vertical-nav nav-expand-lg">
	
	<ul class="nav-menu">
		
		<li class="has-sub-menu" aria-expanded="false">
			<label class="region-select region-link" title="지역선택">
				<span class="region-label">지역선택</span>
			</label>
		  	<ul class="region-list">
				<c:forEach var="region" items="${regionList}">
					<li>
						<a class="sub-region-link" 
						   href="${pageContext.request.contextPath}/${currentMenu}?region=${region.region_id}" 
						   data-region-id="${region.region_id}">
							${region.region_name}
						</a>
					</li>
				</c:forEach>
			</ul>
		</li>
	</ul>
	
	
    <ul class="nav-menu mt-4"> 
		<li class="has-sub-menu" aria-expanded="false">
			<label class="category-link region-link" title="카테고리">
				<span class="category-label region-label">카테고리</span>
			</label>
			<ul class="category-list region-list">
				<c:forEach var="category" items="${categoryList}">
                    <li>
                        <a class="category-link sub-region-link2" 
                           href="${pageContext.request.contextPath}/${currentMenu}?category=${category.category_id}" 
                           data-category-id="${category.category_id}">
                            ${category.category_name}
                        </a>
                    </li>
                </c:forEach>
			</ul>
		</li>
	</ul>
</nav>


