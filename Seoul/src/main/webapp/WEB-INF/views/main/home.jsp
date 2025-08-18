<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>서울 한바퀴</title>
</head>
<body>

<header>
  <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>
  <div class="container layout-container">
    <div class="row gx-4">
    
      <aside class="col-12 col-lg-3 sidebar">
        <div class="sidebar-sticky">
          <jsp:include page="/WEB-INF/views/layout/left.jsp"/>
        </div>
      </aside>
      
	<jsp:include page="/WEB-INF/views/layout/leftResources.jsp"/>
      

      <section class="col-12 col-lg-9">
      </section>
    </div>
  </div>
</main>

</body>
</html>
