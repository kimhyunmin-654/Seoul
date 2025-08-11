<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>


<nav class="vertical-nav nav-expand-lg">
	
	<ul class="nav-menu">
		
		<li class="has-sub-menu" aria-expanded="false">
			<label class="region-link" title="지역선택">
				<span class="region-label">지역선택</span>
			</label>
			
			<ul>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=gangnam">강남구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=gangdong">강동구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=gangbuk">강북구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=gangseo">강서구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=gwanak">관악구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=gwangjin">광진구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=guro">구로구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=geumcheon">금천구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=nowon">노원구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=dobong">도봉구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=dongdaemun">동대문구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=dongjak">동작구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=mapo">마포구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=seodaemun">서대문구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=seocho">서초구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=seongdong">성동구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=seongbuk">성북구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=songpa">송파구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=yangcheon">양천구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=yeongdeungpo">영등포구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=yongsan">용산구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=eunpyeong">은평구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=jongno">종로구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=jung">중구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=jungnang">중랑구</a></li>
			</ul>
		</li>
		
	</ul>
	

</nav>
