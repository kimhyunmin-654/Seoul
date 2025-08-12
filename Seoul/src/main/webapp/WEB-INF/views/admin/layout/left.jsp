<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<nav class="vertical-nav nav-expand-lg">
	<div class="mobile-menu-closed">
		<i class="menu-closed-icon bi bi-x"></i>
	</div>
	
	<ul class="nav-menu">
		<li>
			<a class="menu-link" href="<c:url value='/admin' />" title="홈">
				<i class="menu-icon bi bi-h-square"></i>
				<span class="menu-label">홈</span>
			</a>
		</li>
		
		<li class="has-sub-menu" aria-expanded="false">
			<label class="menu-link" title="상품관리">
				<i class="menu-icon bi bi-grid-fill"></i>
				<span class="menu-label">상품관리</span>
			</label>
			<ul>
				<li><a class="sub-menu-link" href="<c:url value='/admin/products/main'/>">상품리스트</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/products/write/100'/>">상품등록</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/specials/main'/>">특가및기획전</a></li>
				<li><a class="sub-menu-link" href="#">상품카테고리</a></li>
			</ul>
		</li>
		
		<li class="has-sub-menu" aria-expanded="false">
			<label class="menu-link" title="상품진열">
				<i class="menu-icon bi bi-boxes"></i>
				<span class="menu-label">상품진열</span>
			</label>
			<ul>
				<li><a class="sub-menu-link" href="<c:url value='/admin/display/main/1'/>">메인상품</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/display/main/10'/>">베스트상품</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/display/specials/200'/>">오늘의 특가</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/display/specials/300'/>">기획전</a></li>
				<li><a class="sub-menu-link" href="#">분류별진열</a></li>
			</ul>
		</li>
		
		<li class="has-sub-menu" aria-expanded="false">
			<label class="menu-link" title="주문관리">
				<i class="menu-icon bi bi-bag-plus-fill"></i>
				<span class="menu-label">주문관리</span>
			</label>
			<ul>
				<li><a class="sub-menu-link" href="<c:url value='/admin/order/orderManage/100'/>">주문완료</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/order/orderManage/110'/>">배송</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/order/detailManage/100'/>">배송후교환</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/order/detailManage/110'/>">구매확정</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/order/orderManage/120'/>">주문리스트</a></li>
			</ul>
		</li>

		<li class="has-sub-menu" aria-expanded="false">
			<label class="menu-link" title="주문취소">
				<i class="menu-icon bi bi-bag-x"></i>
				<span class="menu-label">주문취소</span>
			</label>
			<ul>
				<li><a class="sub-menu-link" href="<c:url value='/admin/order/detailManage/200'/>">배송전환불</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/order/detailManage/210'/>">배송후반품</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/order/detailManage/220'/>">판매취소</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin/order/detailManage/230'/>">취소리스트</a></li>
			</ul>
		</li>
		
		<li class="has-sub-menu" aria-expanded="false">
			<label class="menu-link" title="통계분석">
				<i class="menu-icon bi bi-graph-up"></i>
				<span class="menu-label">통계분석</span>
			</label>
			<ul>
				<li><a class="sub-menu-link" href="<c:url value='/admin/analysis/salesStatus'/>">판매현황</a></li>
				<li><a class="sub-menu-link" href="#">주문통계</a></li>
				<li><a class="sub-menu-link" href="#">접속자통계</a></li>
			</ul>
		</li>
		
		<li>
			<a class="menu-link" href="<c:url value='/admin/memberManage/main' />" title="회원관리">
				<i class="menu-icon bi bi-person-square"></i>
				<span class="menu-label">회원관리</span>
			</a>
		</li>
		
		<li class="has-sub-menu" aria-expanded="false">
			<label class="menu-link" title="고객센터">
				<i class="menu-icon bi bi-question-square"></i>
				<span class="menu-label">고객센터</span>
			</label>
			<ul>
				<li><a class="sub-menu-link" href="<c:url value='/admin' />">FAQ</a></li>
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
				<li><a class="sub-menu-link" href="#">신고</a></li>
			</ul>
		</li>
		
		<li class="has-sub-menu" aria-expanded="false">
			<label class="menu-link" title="혜택관리">
				<i class="menu-icon bi bi-gift"></i>
				<span class="menu-label">혜택관리</span>
			</label>
			<ul>
				<li><a class="sub-menu-link" href="<c:url value='/admin' />">이벤트</a></li>
				<li><a class="sub-menu-link" href="<c:url value='/admin' />">쿠폰</a></li>
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
