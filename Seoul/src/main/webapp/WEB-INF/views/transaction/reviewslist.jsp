<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>내 후기 보기</title>
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/salelist.css" type="text/css">
</head>
<body>

<header>
  <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="wrap">
  <div class="mypage-row">
    <aside class="left-column">
      <jsp:include page="/WEB-INF/views/layout/leftmypage.jsp"/>
    </aside>

    <section class="content-column">
      <div class="section">
        <div class="container" data-aos="fade-up" data-aos-delay="100">
          <div class="row justify-content-center">
            <div class="col-md-12 board-section my-4 p-4">

              <div class="row py-1 mb-3 align-items-center">
                <div class="col-md-8">
                  <div class="d-flex align-items-center flex-wrap gap-2">
                    <span class="small-title">내 후기 보기</span>
                    <span class="dataCount">후기 ${dataCount}개</span>
                  </div>
                </div>
              </div>

				<div class="mt-4 mb-1 wrap-inner">
					
					<div class="list-content" data-pageNo="0" data-totalPage="0"></div>
					
					<div class="list-footer mt-3 text-end">
						<span class="btn-default more-btn">&nbsp;더보기&nbsp;<i class="bi bi-chevron-down"></i>&nbsp;</span>
					</div>
				</div>

            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</main>

<script>
  window.ctx = '${pageContext.request.contextPath}';
</script>

<script src="${pageContext.request.contextPath}/dist/js/reviewslist.js"></script>

</body>
</html>