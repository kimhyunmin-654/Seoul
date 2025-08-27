<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>


<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/header.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/chat.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/myRooms.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/login.css" type="text/css">

<div class="container-fluid header-wrap px-3 px-md-4">
  <div class="container">
    <div class="header-line">

      <a href="<c:url value='/product/list'/>" class="brand">
        <img class="logo" src="${pageContext.request.contextPath}/dist/images/logo-seoul-hanbak.png"
             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/dist/images/favicon.png';">
        <div class="brand-text">
          <div class="brand-title">서울한바퀴</div>
          <div class="brand-sub">중고거래 커뮤니티</div>
        </div>
      </a>

      <div class="center-box">
        <div class="top-controls">
          <div class="region-label" id="regionName">
            <c:out value="${sessionScope.regionName}" default="지역이름"/>
          </div>


		<form class="searchbar" action="${pageContext.request.contextPath}/search" method="get">
		  <span class="search-label">중고거래</span>
		  <select name="condition" class="form-select search-select">
		    <option value="title">제목</option>
		    <option value="content">내용</option>
		    <option value="seller">판매자</option>
		  </select>
		  <input type="text" name="kwd" placeholder="검색" aria-label="검색" class="search-input">
		  <button type="submit" class="btn search-btn" title="검색"><i class="bi bi-search"></i></button>
		</form>
		
        </div>

        <div class="subnav">
          <a class="accent" href="${pageContext.request.contextPath}/product/list">중고거래</a>
          <a class="with-icon" href="${pageContext.request.contextPath}/auction/list">
            <i class="bi bi-gavel"></i><span>경매</span>
          </a>
          <a href="${pageContext.request.contextPath}/bbs/list?region=${param.region}">동네한바퀴</a>
          <a href="${pageContext.request.contextPath}/event/list">이벤트</a>
          <a href="${pageContext.request.contextPath}/admin/sales">관리자 판매</a> 
          
		  <div class="dropdown">
		    <a href="#" class="dropdown-toggle subnav-dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
		      고객지원
		    </a>
		    <ul class="dropdown-menu">
		      <li><a class="dropdown-item" href="${pageContext.request.contextPath}/notice/list">공지사항</a></li>
		      <li><a class="dropdown-item" href="${pageContext.request.contextPath}/faq/list">FAQ</a></li>
		      <li><a class="dropdown-item" href="${pageContext.request.contextPath}/inquiry/list">1:1문의하기</a></li>
		    </ul>
		  </div>
      
        </div>
      </div>

      <div class="right-box">
        <a href="${pageContext.request.contextPath}/alerts" class="icon-btn" title="알림"><i class="bi bi-bell"></i></a>
	        
<div class="chat-link-wrap">
  <c:choose>
    <c:when test="${empty sessionScope.member}">
      <a href="${pageContext.request.contextPath}/member/login"
         class="link-text chat-link">
        <span class="chat-icon">
          <i class="bi bi-chat-dots"></i>
          <span id="chatNotificationBadge" class="chat-badge d-none" aria-live="polite" aria-atomic="true">0</span>
        </span>
        <span class="chat-text">채팅하기</span>
      </a>
    </c:when>

    <c:otherwise>
      <a href="javascript:void(0);" onclick="openChatPanel()" class="link-text chat-link">
        <span class="chat-icon">
          <i class="bi bi-chat-dots"></i>
          <span id="chatNotificationBadge" class="chat-badge d-none" aria-live="polite" aria-atomic="true">0</span>
        </span>
        <span class="chat-text">채팅하기</span>
      </a>
    </c:otherwise>
  </c:choose>
</div>
        
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
		       
		        <c:when test="${sessionScope.member.userLevel > 4}">
		          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/memberManage/main">관리자 마이페이지</a></li>
		        </c:when>
		       
		        <c:otherwise>
		          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/transaction/salelist">마이페이지</a></li>
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
      
		<div id="chatPanel" class="chat-panel">
		  <div class="chat-header">
		    <span>채팅</span>
		    <button type="button" class="chat-close" onclick="closeChatPanel()">×</button>
		  </div>
		  <div class="chat-banner">
	
		  </div>
			<div class="chat-body">
			  <div class="empty-chat">
			    <i class="bi bi-chat-dots"></i>
			    <p>채팅 내역이 없습니다.</p>
			  </div>
			  
			  <div id="chatRoomList"></div>
			</div>
		</div>
		
		<div id="coBackdrop" class="co-backdrop"></div>
		<div id="coOverlay" class="chat-overlay" role="dialog" aria-modal="true">
		  <div class="co-header">
		    <div class="co-title"><strong id="coOpponent">채팅</strong></div>
		    <button type="button" class="co-close" onclick="closeCenterChat()">×</button>
		  </div>
		  <div id="coMessages" class="co-body"><!-- 메시지 --></div>
		  <div class="co-input">
		    <input id="coInput" type="text" class="form-control" placeholder="메시지를 입력하세요..." autocomplete="off">
		    <button id="coSend" class="btn btn-primary">전송</button>
		  </div>
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


<script>
  window.CTX = '${pageContext.request.contextPath}';
  window.WS_PROTO = (location.protocol === 'https:') ? 'wss' : 'ws';
  <c:choose>
    <c:when test="${not empty sessionScope.member}">
      window.CURRENT_MEMBER_ID = ${sessionScope.member.member_id};
    </c:when>
    <c:otherwise>
      window.CURRENT_MEMBER_ID = null;
    </c:otherwise>
  </c:choose>
</script>

<script src="${pageContext.request.contextPath}/dist/js/chat.js"></script>