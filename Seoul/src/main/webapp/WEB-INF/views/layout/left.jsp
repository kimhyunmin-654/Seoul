<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/left.css" type="text/css" />

<nav class="vertical-nav nav-expand-lg">
    <ul class="nav-menu">

        <!-- 지역 선택 메뉴 -->
        <li class="has-sub-menu" aria-expanded="false">
            <label class="region-link" title="지역 선택">
                <span class="region-label">지역 선택</span>
            </label>

            <!-- 지역 리스트 -->
            <ul class="region-list">
                <c:forEach var="rlist" items="${regionList}">
                    <li>
                        <a href="${pageContext.request.contextPath}/${currentMenu}?region=${rlist.region_id}" 
                           class="sub-region-link ${region_code == rlist.region_id ? 'active' : ''}">
                            ${rlist.region_name}
                        </a>
                    </li>
                </c:forEach>
            </ul>

        </li>

    </ul>
</nav>

