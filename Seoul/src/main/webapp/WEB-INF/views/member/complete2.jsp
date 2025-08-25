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
      <h3>아이디 조회 결과</h3>
		
	  	<c:choose>
		<c:when test="${empty findId}">
		<p class="inquiry">조회결과가 없습니다.</p>
		</c:when>
        <c:otherwise>
            <p>아이디 : ${findId.login_id}</p>
        </c:otherwise>
	</c:choose>
	  	
		
      <div class="message">
        ${message}
      </div>

      <div class="actions">
        <a href="${pageContext.request.contextPath}/product/list" class="btn btn-primary" role="button">메인화면</a>
      </div>

    </div>
  </div>
</body>
</html>
