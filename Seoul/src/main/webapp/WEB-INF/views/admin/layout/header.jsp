<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div class="header-top container-fluid d-flex align-items-center fixed-top mt-0" style="background-color: #110D42 !important;">
	<div class="container-fluid position-relative d-flex align-items-center">
		<a href="<c:url value='/admin' />" class="header-left d-flex align-items-center me-auto">
			<span class="header-title" style="color: white">관리자 페이지</span>
		</a>
		
		<div class="header-center d-flex align-items-center">
			<div class="header-center-item">
				<i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
			</div>
		</div>
		
		<div class="header-right d-flex align-items-center">
			<div class="header-account-links">
				<a href="#" title="알림" style="color: white;"><i class="bi bi-bell"></i></a>
				<a href="<c:url value='/product/list' />" title="나가기" style="color: white;"><i class="bi bi-box-arrow-right"></i></a>
			</div>
		
			<div class="header-avatar">
				<c:choose>
					<c:when test="${not empty sessionScope.member.avatar}">
						<img src="${pageContext.request.contextPath}/uploads/member/${sessionScope.member.avatar}" 
							onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/dist/images/avatar.png';"
							class="avatar-sm dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
					</c:when>
					<c:otherwise>
						<img src="${pageContext.request.contextPath}/dist/images/avatar.png" class="avatar-sm dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
					</c:otherwise>
				</c:choose>
				<ul class="dropdown-menu">
					<li><a href="${pageContext.request.contextPath}/member/pwd" class="dropdown-item">정보수정</a></li>
				</ul>
			</div>
		</div>
	</div>
</div>