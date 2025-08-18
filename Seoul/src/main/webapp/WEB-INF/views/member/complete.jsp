<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${title}</title>

  <style>
    body { font-family: "Segoe UI", Roboto, "Noto Sans KR", Arial, sans-serif; background:#fafafa; margin:0; }
    .wrap { min-height:100vh; display:flex; align-items:center; justify-content:center; padding:24px; }
    .card {
      width:100%; max-width:640px;
      background:#fff; border:1px solid #e6e6e6; border-radius:8px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.03);
      padding:28px;
    }
    h3 { margin:0 0 12px 0; font-size:1.25rem; color:#111; }
    .message { margin:18px 0; color:#333; line-height:1.6; }
    .actions { display:flex; gap:8px; margin-top:18px; }
    .btn {
      display:inline-block; padding:10px 14px; border-radius:6px; border:1px solid #cfcfcf;
      background:#f5f5f5; color:#111; text-decoration:none; text-align:center; cursor:pointer;
    }
    .btn-primary {
      background:#2d6cdf; color:#fff; border-color:#2d6cdf;
    }
    .small { font-size:0.9rem; color:#666; margin-top:12px; }
    @media (max-width:480px){ .card { padding:20px; } }
  </style>
</head>
<body>
  <div class="wrap">
    <div class="card">
      <h3>${title}</h3>

      <div class="message">
        ${message}
      </div>

      <div class="actions">
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary" role="button">메인화면</a>
      </div>

      <div class="small">
        변경사항이 반영되었습니다.
      </div>
    </div>
  </div>
</body>
</html>
