<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<nav class="vertical-nav nav-expand-lg">
	<div class="mobile-menu-closed">
		<i class="menu-closed-icon bi bi-x"></i>
	</div>
	
	<ul class="nav-menu">
		
		<li>
			<a class="menu-link" href="<c:url value='/admin/celler/main' />" title="관리자 판매">
				<i class="menu-icon bi bi-person-square"></i>
				<span class="menu-label">관리자 판매</span>
			</a>
		</li>
		
		<li>
			<a class="menu-link" href="<c:url value='/admin/memberManage/main' />" title="회원관리">
				<i class="menu-icon bi bi-person-square"></i>
				<span class="menu-label">회원관리</span>
			</a>
		</li>
		
		<li class="has-sub-menu" aria-expanded="false">
			<label class="menu-link" title="고객센터">
				<i class="menu-icon bi bi-exclamation-square"></i>
				<span class="menu-label">고객센터</span>
			</label>
			<ul>
				<li><a class="sub-menu-link" href="<c:url value='/admin/faqManage/list' />">FAQ</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/noticeManage/list' />">공지사항</a></li>
			</ul>
		</li>

		<li class="has-sub-menu" aria-expanded="false">
			<label class="menu-link" title="문의 및 리뷰">
				<i class="menu-icon bi bi-question-square"></i>
				<span class="menu-label">문의 및 신고</span>
			</label>
			<ul>
				<li><a class="sub-menu-link" href="${pageContext.request.contextPath}/admin/inquiryManage/list">1:1문의</a></li>
				<li><a class="sub-menu-link" href="${pageContext.request.contextPath}/admin/reportsManage/main">신고</a></li>
			</ul>
		</li>
		
		<li class="has-sub-menu" aria-expanded="false">
			<label class="menu-link" title="혜택관리">
				<i class="menu-icon bi bi-gift"></i>
				<span class="menu-label">혜택관리</span>
			</label>
			<ul>
				<li><a class="sub-menu-link" href="<c:url value='/admin/eventManage/all/list'/>">이벤트</a></li>
			</ul>
		</li>
		
		<li>
			<a href="<c:url value='/member/logout' />" class="menu-link" title="Logout">
				<i class="menu-icon bi bi-unlock"></i>
				<span class="menu-label">Logout</span>
			</a>
		</li>
	</ul>
	
	<div class="nav-menu-footer" aria-expanded="true">
		<div class="collapsed-menu">
			<i class="collapse-menu-icon bi bi-arrow-bar-left"></i>
			<span class="menu-label">Collapsed Menu</span>
		</div>
	</div>
</nav>
