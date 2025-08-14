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
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=gangnam" data-region-id="gangnam">강남구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=gangdong" data-region-id="gangdong">강동구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=gangbuk" data-region-id="gangbuk">강북구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=gangseo" data-region-id="gangseo">강서구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=gwanak" data-region-id="gwanak">관악구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=gwangjin" data-region-id="gwangjin">광진구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=guro" data-region-id="guro">구로구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=geumcheon" data-region-id="geumcheon">금천구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=nowon" data-region-id="nowon">노원구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=dobong" data-region-id="dobong">도봉구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=dongdaemun" data-region-id="dongdaemun">동대문구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=dongjak" data-region-id="dongjak">동작구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=mapo" data-region-id="mapo">마포구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=seodaemun" data-region-id="seodaemun">서대문구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=seocho" data-region-id="seocho">서초구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=seongdong" data-region-id="seongdong">성동구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=seongbuk" data-region-id="seongbuk">성북구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=songpa" data-region-id="songpa">송파구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=yangcheon" data-region-id="yangcheon">양천구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=yeongdeungpo" data-region-id="yeongdeungpo">영등포구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=yongsan" data-region-id="yongsan">용산구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=eunpyeong" data-region-id="eunpyeong">은평구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=jongno" data-region-id="jongno">종로구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=jung" data-region-id="jung">중구</a></li>
				<li><a class="sub-region-link" href="${pageContext.request.contextPath}/${currentMenu}?region_id=jungnang" data-region-id="jungnang">중랑구</a></li>
			</ul>
		</li>
		
	</ul>
	

</nav>
