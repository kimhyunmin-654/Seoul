<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
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

<header>
  <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="wrap">
  <jsp:include page="/WEB-INF/views/layout/leftmypage.jsp"/>
</main>

</body>
</html>
