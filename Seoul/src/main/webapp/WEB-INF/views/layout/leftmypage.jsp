<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<style>
  :root { --container-max: 1200px; --sidebar-w: 260px; }
  body { margin:0; font-family: system-ui, -apple-system, Segoe UI, Roboto, "Noto Sans KR", Arial, sans-serif; }
  .wrap { max-width: var(--container-max); margin: 0 auto; padding: 0 16px 48px; }
  .page { display: grid; grid-template-columns: var(--sidebar-w) 1fr; gap: 32px; }
  .page-title { font-size: 28px; font-weight: 800; margin: 20px 0 24px; }
  .sidebar { padding-top: 8px; }
  .menu-title { font-weight: 800; font-size: 22px; margin: 16px 0 18px; }
  .menu { list-style: none; padding: 0; margin: 0; }
  .menu > li { margin: 8px 0; }
  .menu a { display: inline-block; padding: 6px 2px; text-decoration: none; color: #111; }
  .menu a:hover { text-decoration: underline; }
  .menu .sub { list-style: disc; padding-left: 18px; margin: 6px 0 10px; color:#222; }
  .content { min-height: 540px; }
  .card { background: #fff; border: 1px solid #e5e7eb; border-radius: 10px; padding: 18px; }
  .muted { color:#6b7280; font-size:14px; }
  @media (max-width: 992px) {
    .page { grid-template-columns: 1fr; }
    .sidebar { order: 2; }
    .content { order: 1; }
  }
</style>
</head>
<body>

<main class="wrap">
  <div class="page">
    <!-- 왼쪽 사이드 -->
    <aside class="sidebar">
      <div class="menu-title">마이페이지</div>
      <ul class="menu">
        <li>
          <strong>거래내역+</strong>
          <ul class="sub">
            <li><a href="${pageContext.request.contextPath}/mypage/orders/sales">판매내역</a></li>
            <li><a href="${pageContext.request.contextPath}/mypage/orders/purchases">구매내역</a></li>
          </ul>
        </li>

        <li>
          <div><a href="${pageContext.request.contextPath}/mypage/shipping">배송 현황</a></div>
        </li>

        <li><a href="${pageContext.request.contextPath}/mypage/posts">내가 쓴 글</a></li>
        <li><a href="${pageContext.request.contextPath}/mypage/recent">최근 본 상품</a></li>
        <li><a href="${pageContext.request.contextPath}/mypage/likes">찜한 상품</a></li>
        <li><a href="${pageContext.request.contextPath}/mypage/cart">장바구니</a></li>
        <li><a href="${pageContext.request.contextPath}/mypage/calendar">캘린더</a></li>
        <li><a href="${pageContext.request.contextPath}/mypage/events">이벤트 참여 내역</a></li>
        <li><a href="${pageContext.request.contextPath}/member/pwd">내 정보 수정</a></li>
        <li style="margin-top: 18px;"><a href="${pageContext.request.contextPath}/mypage/stats">거래 통계</a></li>
        <li style="margin-top: 18px;"><a href="${pageContext.request.contextPath}/mypage/withdrawal">회원탈퇴</a></li>
      </ul>
    </aside>

    <!-- 우측 콘텐츠 -->
    <section class="content">
      <div class="page-title">마이페이지</div>
      <div class="card">
        <p class="muted">좌측 메뉴에서 항목을 선택해 주세요. (예: <b>판매내역</b>, <b>구매내역</b>, <b>찜한 상품</b> 등)</p>
        <hr style="border:none;border-top:1px solid #eee; margin:16px 0;">
        <ul style="margin:0; padding-left:16px;">
          <li>최근 거래 요약</li>
          <li>최근 본 상품 5개</li>
          <li>알림/메시지 요약</li>
        </ul>
      </div>
    </section>
  </div>
</main>

</body>
</html>
