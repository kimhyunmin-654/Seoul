<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/leftmypage.css" type="text/css">

<nav id="mh-leftmenu" class="mh-leftmenu" aria-label="마이페이지 메뉴">
  <div class="mh-leftmenu-inner">
    <div class="mh-menu-title">마이페이지</div>

    <ul class="mh-menu">
      <li class="mh-folder">
        <strong>거래내역+</strong>
        <ul class="mh-sub">
          <li><a href="${pageContext.request.contextPath}/transaction/salelist">판매내역</a></li>
          <li><a href="${pageContext.request.contextPath}/transaction/purchaseslist">구매내역</a></li>
        </ul>
      </li>

      <li><a href="${pageContext.request.contextPath}/mypage/posts">내가 쓴 글</a></li>
      <li><a href="${pageContext.request.contextPath}/mypage/recent">최근 본 상품</a></li>
      <li><a href="${pageContext.request.contextPath}/productLike/list">찜한 상품</a></li>
      <li><a href="${pageContext.request.contextPath}/mypage/likes">찜한 상품</a></li>
      <li><a href="${pageContext.request.contextPath}/mypage/cart">장바구니</a></li>
      <li><a href="${pageContext.request.contextPath}/mypage/events">이벤트 참여 내역</a></li>
      <li><a href="${pageContext.request.contextPath}/member/pwd">내 정보 수정</a></li>

      <li style="margin-top:12px;"><a href="${pageContext.request.contextPath}/member/delete">회원탈퇴</a></li>
    </ul>
  </div>
</nav>


