<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>서울 한바퀴</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/init.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body>

	<section class="seoul" role="banner"
		style="--hero-bg: url('<c:url value="/dist/images/Group 1.png"/>')">
		<div class="seoul-inner">
			<h1 class="seoul-title">서울 한바퀴</h1>

			<div class="location-select" role="group" aria-label="지역 선택">
				<select id="region" class="location-select-field" aria-label="지역 선택">
					<option value="" selected>지역 선택</option>
					<option value="gangnam">강남구</option>
					<option value="gangdong">강동구</option>
					<option value="gangbuk">강북구</option>
					<option value="gangseo">강서구</option>
					<option value="gwanak">관악구</option>
					<option value="gwangjin">광진구</option>
					<option value="guro">구로구</option>
					<option value="geumcheon">금천구</option>
					<option value="nowon">노원구</option>
					<option value="dobong">도봉구</option>
					<option value="dongdaemun">동대문구</option>
					<option value="dongjak">동작구</option>
					<option value="mapo">마포구</option>
					<option value="seodaemun">서대문구</option>
					<option value="seocho">서초구</option>
					<option value="seongdong">성동구</option>
					<option value="seongbuk">성북구</option>
					<option value="songpa">송파구</option>
					<option value="yangcheon">양천구</option>
					<option value="yeongdeungpo">영등포구</option>
					<option value="yongsan">용산구</option>
					<option value="eunpyeong">은평구</option>
					<option value="jongno">종로구</option>
					<option value="jung">중구</option>
					<option value="jungnang">중랑구</option>
				</select>
				<img src="<c:url value="/dist/images/mapPin.png"/>" alt="" aria-hidden="true" class="location-select-icon" />
			</div>
		</div>
	</section>

	<footer class="site-footer">
		<div class="footer-grid">
			<div>
				<h3 class="footer-brand">서울 한바퀴</h3>
				<address class="footer-address">
					21, World Cup buk-ro<br /> Mapo-gu, Seoul, Republic of Korea<br />
					Phone: +82 1234 5678<br /> Email: info@example.com
				</address>
				<div class="footer-sns">
					<a href="#" aria-label="Email"><i class="bi bi-envelope"></i></a> 
					<a href="#" aria-label="Instagram"><i class="bi bi-instagram"></i></a> 
					<a href="#" aria-label="LinkedIn"><i class="bi bi-linkedin"></i></a>
				</div>
			</div>

			<div>
				<h4 class="footer-title">Useful Links</h4>
				<ul class="footer-list">
					<li><a href="<c:url value='/'/>">Home</a></li>
					<li><a href="<c:url value='/about'/>">About</a></li>
					<li><a href="<c:url value='/map'/>">Map</a></li>
					<li><a href="<c:url value='/product/list'/>">Shopping</a></li>
					<li><a href="<c:url value='/weather'/>">Weather</a></li>
				</ul>
			</div>

			<div>
				<h4 class="footer-title">Help &amp; Information</h4>
				<ul class="footer-list">
					<li><a href="<c:url value='/help'/>">Help</a></li>
					<li><a href="<c:url value='/support'/>">Customer Service</a></li>
					<li><a href="<c:url value='/terms'/>">이용약관</a></li>
					<li><a href="<c:url value='/policy/ecommerce'/>">전자상거래약관</a></li>
					<li><a href="<c:url value='/privacy'/>">개인정보처리방침</a></li>
				</ul>
			</div>

			<div>
				<h4 class="footer-title">Our Newsletter</h4>
				<p class="footer-desc">서울 한바퀴의 최신 혜택 및 서비스 소식을 받아 보실 수 있습니다.</p>
				<form class="footer-form"
					action="<c:url value='/newsletter/subscribe'/>" method="post">
					<input type="email" name="email" placeholder="이메일 주소" required
						class="footer-input" />
					<button class="footer-btn" type="submit">구독</button>
				</form>
			</div>
		</div>
	</footer>

	<script>
		document.getElementById('region').addEventListener('change', function() {
			if (!this.value) return;

			window.location.href = '<c:url value="/product/list?region="/>' + this.value;

		});
	</script>
</body>
</html>