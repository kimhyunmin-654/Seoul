<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<nav class="vertical-nav nav-expand-lg" id="sidebar">
	<div class="mobile-menu-closed">
		<i class="menu-closed-icon bi bi-x"></i>
	</div>

	<div class="accordion accordion-flush" id="sidebarAccordion">
		<%-- 홈 --%>
		<div class="accordion-item">
			<a class="accordion-button no-bg" href="<c:url value='/admin' />" title="홈"> 
			<i class="menu-icon bi bi-h-square me-2"></i>
			<span class="menu-label"> 홈</span>
			</a>
		</div>

		<%-- 상품관리 --%>
		<div class="accordion-item">
			<h2 class="accordion-header" id="headingProduct">
				<button class="accordion-button collapsed no-bg d-flex align-items-center" type="button" data-bs-toggle="collapse" data-bs-target="#collapseProduct" aria-expanded="false" varia-controls="collapseProduct">
					<i class="menu-icon bi bi-box-seam me-2"></i>
					<span class="menu-label"> 상품관리</span> <span class="ms-auto toggle-icon">+</span>
				</button>
			</h2>
			<div id="collapseProduct" class="accordion-collapse collapse" aria-labelledby="headingProduct" data-bs-parent="#sidebarAccordion">
				<div class="accordion-body ps-4">
					<ul class="list-unstyled mb-0">
						<li><a class="sub-menu-link" href="<c:url value='/admin/products/main'/>">상품리스트</a></li>
						<li><a class="sub-menu-link" href="<c:url value='/admin/products/write/100'/>">상품등록</a></li>
						<li><a class="sub-menu-link" href="#">상품진열</a></li>
					</ul>
				</div>
			</div>
		</div>

		<%-- 주문관리 --%>
		<div class="accordion-item">
			<h2 class="accordion-header" id="headingOrder">
				<button class="accordion-button collapsed no-bg d-flex align-items-center" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOrder" aria-expanded="false" aria-controls="collapseOrder">
					<i class="menu-icon bi bi-bag-check me-2"></i>
					<span class="menu-label"> 주문관리</span> <span class="ms-auto toggle-icon">+</span>
				</button>
			</h2>
			<div id="collapseOrder" class="accordion-collapse collapse" aria-labelledby="headingOrder" data-bs-parent="#sidebarAccordion">
				<div class="accordion-body ps-4">
					<ul class="list-unstyled mb-0">
						<li><a class="sub-menu-link" href="<c:url value='/admin/order/orderManage/100'/>">주문완료</a></li>
						<li><a class="sub-menu-link" href="<c:url value='/admin/order/orderManage/110'/>">배송</a></li>
						<li><a class="sub-menu-link" href="<c:url value='/admin/order/detailManage/100'/>">배송후교환</a></li>
						<li><a class="sub-menu-link" href="<c:url value='/admin/order/detailManage/110'/>">구매확정</a></li>
						<li><a class="sub-menu-link" href="<c:url value='/admin/order/orderManage/120'/>">주문리스트</a></li>
					</ul>
				</div>
			</div>
		</div>

		<%-- 주문취소 --%>
		<div class="accordion-item">
			<h2 class="accordion-header" id="headingCancel">
				<button class="accordion-button collapsed no-bg d-flex align-items-center" type="button" data-bs-toggle="collapse" data-bs-target="#collapseCancel" aria-expanded="false" aria-controls="collapseCancel">
					<i class="menu-icon bi bi-x-circle me-2"></i>
					<span class="menu-label"> 주문취소</span> <span class="ms-auto toggle-icon">+</span>
				</button>
			</h2>
			<div id="collapseCancel" class="accordion-collapse collapse" aria-labelledby="headingCancel" data-bs-parent="#sidebarAccordion">
				<div class="accordion-body ps-4">
					<ul class="list-unstyled mb-0">
						<li><a class="sub-menu-link" href="<c:url value='/admin/order/detailManage/200'/>">배송전환불</a></li>
						<li><a class="sub-menu-link" href="<c:url value='/admin/order/detailManage/210'/>">배송후반품</a></li>
						<li><a class="sub-menu-link" href="<c:url value='/admin/order/detailManage/220'/>">판매취소</a></li>
						<li><a class="sub-menu-link" href="<c:url value='/admin/order/detailManage/230'/>">취소리스트</a></li>
					</ul>
				</div>
			</div>
		</div>

		<%-- 통계분석 --%>
		<div class="accordion-item">
			<h2 class="accordion-header" id="headingStats">
				<button class="accordion-button collapsed no-bg d-flex align-items-center" type="button" data-bs-toggle="collapse" data-bs-target="#collapseStats" aria-expanded="false" aria-controls="collapseStats">
					<i class="menu-icon bi bi-graph-up me-2"></i>
					<span class="menu-label"> 통계분석</span> <span class="ms-auto toggle-icon">+</span>
				</button>
			</h2>
			<div id="collapseStats" class="accordion-collapse collapse" aria-labelledby="headingStats" data-bs-parent="#sidebarAccordion">
				<div class="accordion-body ps-4">
					<ul class="list-unstyled mb-0">
						<li><a class="sub-menu-link" href="<c:url value='/admin/analysis/salesStatus'/>">판매현황</a></li>
						<li><a class="sub-menu-link" href="#">주문통계</a></li>
						<li><a class="sub-menu-link" href="#">접속자통계</a></li>
					</ul>
				</div>
			</div>
		</div>

		<%-- 로그아웃 --%>
		<div class="accordion-item">
			<a href="<c:url value='/member/logout' />"class="accordion-button no-bg" title="Logout"> 
			<i class="menu-icon bi bi-unlock me-2"></i>
			<span class="menu-label">Logout</span>
			</a>
		</div>
	</div>

	<div class="nav-menu-footer" aria-expanded="true">
		<div class="collapsed-menu">
			<i class="collapse-menu-icon bi bi-arrow-bar-left"></i> <span
				class="menu-label">Collapsed Menu</span>
		</div>
	</div>
</nav>

<script>
	document.addEventListener('DOMContentLoaded', function() {
		var collapseElements = document.querySelectorAll('#sidebarAccordion .accordion-collapse');
		var toggleIcons = document.querySelectorAll('#sidebarAccordion .toggle-icon');

		collapseElements.forEach(function(collapseEl) {
			collapseEl.addEventListener('show.bs.collapse', function() {
				var button = document.querySelector('[data-bs-target="#' + collapseEl.id + '"]');
				if (button) {
					var icon = button.querySelector('.toggle-icon');
					if (icon) icon.textContent = '-';
				}
			});
			collapseEl.addEventListener('hide.bs.collapse', function() {
				var button = document.querySelector('[data-bs-target="#' + collapseEl.id + '"]');
				if (button) {
					var icon = button.querySelector('.toggle-icon');
					if (icon) icon.textContent = '+';
				}
			});
		});

		var sidebar = document.getElementById('sidebar');
		var collapsedMenu = sidebar.querySelector('.nav-menu-footer .collapsed-menu');
		var menuLabels = sidebar.querySelectorAll('.menu-label');

		collapsedMenu.addEventListener('click', function() {
			var isCollapsed = sidebar.classList.toggle('collapsed');

			menuLabels.forEach(function(label) {
				label.style.display = isCollapsed ? 'none' : '';
			});

			if (isCollapsed) {
				collapseElements.forEach(function(collapseEl) {
					if (collapseEl.classList.contains('show')) {
						var bsCollapse = bootstrap.Collapse.getInstance(collapseEl);
						if (bsCollapse) {
							bsCollapse.hide();
						} else {
							collapseEl.classList.remove('show');
						}
					}
				});
				toggleIcons.forEach(function(icon) {
					icon.textContent = '';
				});
			} else {
				toggleIcons.forEach(function(icon) {
					icon.textContent = '+';
				});
			}
		});
	});
</script>