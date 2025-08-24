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
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=gangnam" data-region-id="gangnam">강남구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=gangdong" data-region-id="gangdong">강동구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=gangbuk" data-region-id="gangbuk">강북구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=gangseo" data-region-id="gangseo">강서구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=gwanak" data-region-id="gwanak">관악구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=gwangjin" data-region-id="gwangjin">광진구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=guro" data-region-id="guro">구로구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=geumcheon" data-region-id="geumcheon">금천구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=nowon" data-region-id="nowon">노원구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=dobong" data-region-id="dobong">도봉구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=dongdaemun" data-region-id="dongdaemun">동대문구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=dongjak" data-region-id="dongjak">동작구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=mapo" data-region-id="mapo">마포구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=seodaemun" data-region-id="seodaemun">서대문구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=seocho" data-region-id="seocho">서초구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=seongdong" data-region-id="seongdong">성동구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=seongbuk" data-region-id="seongbuk">성북구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=songpa" data-region-id="songpa">송파구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=yangcheon" data-region-id="yangcheon">양천구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=yeongdeungpo" data-region-id="yeongdeungpo">영등포구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=yongsan" data-region-id="yongsan">용산구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=eunpyeong" data-region-id="eunpyeong">은평구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=jongno" data-region-id="jongno">종로구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=jung" data-region-id="jung">중구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region=jungnang" data-region-id="jungnang">중랑구</a></li>
			</ul>
		</li>
		
	</ul>
	

</nav>
