<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
/* ===== Header ===== */
.header-wrap { border-bottom:1px solid #eee; background:#fff; }
.header-line { display:flex; align-items:center; gap:22px; padding:12px 0; }

/* 좌측 로고 */
.brand { display:flex; align-items:center; gap:12px; text-decoration:none; }
.brand .logo { width:64px; height:64px; border-radius:6px; object-fit:cover; border:1px solid #ddd; background:#fafafa; }
.brand .brand-text { line-height:1.1; }
.brand .brand-title { font-weight:800; font-size:22px; color:#111; letter-spacing:-0.5px; }
.brand .brand-sub { font-size:12px; color:#666; }

/* 가운데 */
.center-box { flex:1 1 auto; min-width:560px; }
.top-controls { display:flex; align-items:center; gap:14px; }
.region-label {
  min-width:120px; padding:6px 12px; border-radius:8px; background:#efefef;
  font-weight:800; color:#333; border:1px solid #ddd; text-align:center;
}

/* 세그먼트 메뉴 */
.segment { display:flex; border-radius:10px; overflow:hidden; border:1px solid #dcdcdc; background:#f3f3f3; }
.segment a { padding:8px 18px; text-decoration:none; color:#333; border-right:1px solid #dcdcdc; font-weight:800; }
.segment a:last-child { border-right:none; }
.segment a.active { background:#d9d9d9; color:#111; }

/* 검색 바 */
.searchbar{
  display:flex; align-items:center; gap:12px;
  border:1px solid #d0d0d0; background:#e5e5e5;
  border-radius:8px; padding:8px 10px;
  height: 44px;
}
.search-label{
  white-space:nowrap;
  word-break: keep-all;
  font-weight:800; color:#222;
  padding-right:12px; margin-right:8px;
  border-right:1px solid #bfbfbf;
  display: inline-flex; align-items: center; height: 44px;
}
.search-select{
  border:none; background:transparent; outline:none;
  padding:4px 6px; min-width:110px;
  height: 36px;
}
.search-input{
  flex:1; border:none; background:transparent; outline:none;
  font-weight:700;
}
.search-btn{
  background:#f5f5f5; border:1px solid #d0d0d0;
  border-radius:8px; padding:6px 10px; font-size:18px;
  height: 36px; display: inline-flex; align-items: center;
}
.searchbar i { font-size:20px; }

/* 하단 2차 메뉴 */
.subnav { 
  display:flex; 
  align-items:center; 
  gap:28px; 
  padding-top:10px; 
  padding-left:2px; 
  flex-wrap: nowrap;
}
.subnav a { 
  text-decoration:none; 
  color:#111; 
  font-size:20px; 
  font-weight:800; 
  letter-spacing:-0.2px; 
  white-space: nowrap; 
  word-break: keep-all !important;
}
.subnav a.accent { color:#111; }
.subnav .with-icon { display:flex; align-items:center; gap:10px; }
.subnav .with-icon i { font-size:22px; }
.subnav .dropdown .subnav-dropdown-toggle::after { margin-left: 6px; }
.subnav .dropdown-menu { min-width: 160px; }

/* 우측 */
.right-box { display:flex; align-items:center; gap:20px; }
.icon-btn { color:#111; font-size:22px; text-decoration:none; }
.link-text { text-decoration:none; color:#111; font-weight:700; }
.btn-sell { 
  color:#333; font-weight:800; text-decoration:none; 
  border:1px solid #cfcfcf; padding:6px 12px; border-radius:8px; background:#fff;
}
.avatar-sm { width:34px; height:34px; border-radius:50%; border:1px solid #ddd; object-fit:cover; cursor:pointer; }

@media (max-width:992px){
  .header-line { flex-wrap:wrap; }
  .center-box { min-width:100%; order:3; }
  .right-box { order:2; margin-left:auto; }
}
</style>

<div class="container-fluid header-wrap px-3 px-md-4">
  <div class="container">
    <div class="header-line">

      <a href="<c:url value='/'/>" class="brand">
        <img class="logo" src="${pageContext.request.contextPath}/dist/images/logo-seoul-hanbak.png"
             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/dist/images/logo-placeholder.png';">
        <div class="brand-text">
          <div class="brand-title">서울한바퀴</div>
          <div class="brand-sub">중고거래 커뮤니티</div>
        </div>
      </a>

      <div class="center-box">
        <div class="top-controls">
          <div class="region-label" id="regionName">
            <c:out value="${empty sessionScope.regionName ? '지역이름' : sessionScope.regionName}"/>
          </div>


		<form class="searchbar" action="${pageContext.request.contextPath}/search" method="get">
		  <span class="search-label">중고거래</span>
		  <select name="condition" class="form-select search-select">
		    <option value="title">제목</option>
		    <option value="content">내용</option>
		    <option value="seller">판매자</option>
		  </select>
		  <input type="text" name="q" placeholder="검색" aria-label="검색" class="search-input">
		  <button type="submit" class="btn search-btn" title="검색"><i class="bi bi-search"></i></button>
		</form>
		
        </div>

        <div class="subnav">
          <a class="accent" href="${pageContext.request.contextPath}/product/list">중고거래</a>
          <a class="with-icon" href="${pageContext.request.contextPath}/auction/list">
            <i class="bi bi-gavel"></i><span>경매</span>
          </a>
          <a href="${pageContext.request.contextPath}/local">동네한바퀴</a>
          <a href="${pageContext.request.contextPath}/wish/list">찜한 상품</a>
          <a href="${pageContext.request.contextPath}/event/list">이벤트</a>
          <a href="${pageContext.request.contextPath}/admin/sales">관리자 판매</a>
          
		  <div class="dropdown">
		    <a href="#" class="dropdown-toggle subnav-dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
		      고객지원
		    </a>
		    <ul class="dropdown-menu">
		      <li><a class="dropdown-item" href="${pageContext.request.contextPath}/notice/list">공지사항</a></li>
		      <li><a class="dropdown-item" href="${pageContext.request.contextPath}/faq/main">FAQ</a></li>
		    </ul>
		  </div>
      
        </div>
      </div>

      <div class="right-box">
        <a href="${pageContext.request.contextPath}/alerts" class="icon-btn" title="알림"><i class="bi bi-bell"></i></a>
        <a href="${pageContext.request.contextPath}/chat/main" class="link-text">채팅하기</a>
        <a href="${pageContext.request.contextPath}/product/write" class="btn-sell">판매하기</a>

        <c:choose>
          <c:when test="${empty sessionScope.member}">
            <a href="${pageContext.request.contextPath}/member/login" class="icon-btn" title="로그인">
              <i class="bi bi-person"></i>
            </a>
          </c:when>

		<c:otherwise>
		  <div class="dropdown">
		    <c:choose>
		      <c:when test="${not empty sessionScope.member.avatar}">
		        <img src="${pageContext.request.contextPath}/uploads/member/${sessionScope.member.avatar}"
		             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/dist/images/avatar.png';"
		             class="avatar-sm dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
		      </c:when>
		      <c:otherwise>
		        <img src="${pageContext.request.contextPath}/dist/images/avatar.png"
		             class="avatar-sm dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
		      </c:otherwise>
		    </c:choose>
		    <ul class="dropdown-menu dropdown-menu-end">
		      <c:choose>
		       
		        <c:when test="${sessionScope.member.userLevel == 9}">
		          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/mypage">관리자 마이페이지</a></li>
		        </c:when>
		       
		        <c:otherwise>
		          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/mypage">마이페이지</a></li>
		        </c:otherwise>
		      </c:choose>
		
		      <li><a class="dropdown-item" href="${pageContext.request.contextPath}/cart">장바구니</a></li>
		      <li><hr class="dropdown-divider"></li>
		      <li><a class="dropdown-item" href="${pageContext.request.contextPath}/member/logout">로그아웃</a></li>
		    </ul>
		  </div>
		</c:otherwise>
        </c:choose>
      </div>

    </div>
  </div>
</div>

<script>

function updateHeaderRegion(name){
  const el = document.getElementById('regionName');
  if(el){ el.textContent = name || '지역이름'; }
  try { localStorage.setItem('selectedRegionName', name || ''); } catch(e){}
}
// 새로고침 시 저장된 지역명 복원(없으면 세션값/기본값 유지)
(function(){
  try{
    const saved = localStorage.getItem('selectedRegionName');
    if(saved){
      const el = document.getElementById('regionName');
      if(el) el.textContent = saved;
    }
  }catch(e){}
})();
</script>
