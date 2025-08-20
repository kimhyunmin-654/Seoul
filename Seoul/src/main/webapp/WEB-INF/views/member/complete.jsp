<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${title}</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/complete.css" type="text/css">

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
