<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Seoul</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/tabs.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

	<div class="right-panel">
		<div class="page-title" data-aos="fade-up" data-aos-delay="200">
			<h2>회원관리</h2>
		</div>

		<div class="section p-5" data-aos="fade-up" data-aos-delay="200">
			<div class="section-body p-5">
						
				<ul class="nav nav-tabs" id="myTab" role="tablist">
					<li class="nav-item" role="presentation">
						<button class="nav-link ${role == 1 ? 'active' : ''}" id="tab-1" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-selected="${role == 1 ? 'true' : 'false'}" data-tab="1"> <i class="bi bi-person-fill"></i> 회원</button>
					</li>
					<li class="nav-item" role="presentation">
						<button class="nav-link ${role == 2 ? 'active' : ''}" id="tab-2" data-bs-toggle="tab" data-bs-target="#nav-content" type="button" role="tab" aria-selected="${role == 2 ? 'true' : 'false'}" data-tab="2"> <i class="bi bi-person-lines-fill"></i> 셀러</button>
					</li>
				</ul>
				
				<div class="tab-content pt-3" id="nav-tabContent"></div>
				
				<form name="memberSearchForm">
					<input type="hidden" name="schType" value="login_id">
					<input type="hidden" name="kwd" value="">
					<input type="hidden" name="role" value="${role}">
					<input type="hidden" name="non" value="0">
					<input type="hidden" name="enabled" value="">
				</form>				
						
			</div>
		</div>
	</div>
</main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/echarts/5.6.0/echarts.min.js"></script>

<script type="text/javascript">
$(function(){
	// 페이지 로드 시 URL 파라미터에 따라 탭 활성화
    const currentRole = "${role}";
    if (currentRole === "2") {
        $('#tab-1').removeClass('active');
        $('#tab-2').addClass('active');
    }
	
    $('button[role="tab"]').on('click', function(e){
    	const tab = $(this).attr('data-tab');
    	
		if(tab !== '4') {
			resetList($(this)); 
		} else {
			memberAnalysis();
		}
    });	
});

$(function(){
	listMember(1);
});

function listMember(page) {
	let url = '${pageContext.request.contextPath}/admin/memberManage/list';	
	let params = $('form[name=memberSearchForm]').serialize();
	params += '&page=' + page;
	
	const fn = function(data) {
		$('#nav-tabContent').html(data);		
	};
	
	ajaxRequest(url, 'get', params, 'text', fn);
}

function resetList(tabElement) {
	// 탭 클릭 시 active 클래스 변경 및 role 값 설정
	$('button[role="tab"]').removeClass('active');
	tabElement.addClass('active');

	const f = document.memberSearchForm;
	
	f.schType.value = 'login_id';
	f.kwd.value = '';
	f.role.value = tabElement.attr('data-tab'); // 클릭한 탭의 data-tab 값으로 role 설정
	f.non.value = 0;
	f.enabled.value = '';
	
	listMember(1);
}

function searchList() {
	// 검색
	const f = document.memberSearchForm;
	
	f.schType.value = $('#searchType').val();
	f.kwd.value = $('#keyword').val();
	
	listMember(1);
}

$(function(){
	// 회원 리스트 상단 검색 checkbox
	$('#nav-tabContent').on('click', '.wrap-search-check input[type=checkbox]', function(){
		let enabled = '';
		let non = 0;
		
		if($('#enabledCheck1').is(':checked') && $('#enabledCheck2').is(':checked')) {
			enabled = '';
		} else if($('#enabledCheck1').is(':checked')) {
			enabled = '1';
		} else if($('#enabledCheck2').is(':checked')) {
			enabled = '0';
		}
		
		if($('#nonMemberCheckbox').is(':checked')){
			non = 1;
		}
		
		const f = document.memberSearchForm;
		f.non.value = non;
		f.enabled.value = enabled;
		
		listMember(1);
	});
});

function profile(member_id, page) {
	// 모달이 제대로 작동죄지 않는 현상을 위해 body로 옮긴 모달이 존재하는 경우 제거
	$('#memberStatusDetailesDialogModal').remove();
	$('#memberUpdateDialogModal').remove();
	
	// 회원 상세 보기
	let url = '${pageContext.request.contextPath}/admin/memberManage/profile';
	let params = 'member_id=' + member_id + '&page=' + page;
	
	const fn = function(data){
		$('#nav-tabContent').html(data);
	};

	ajaxRequest(url, 'get', params, 'text', fn);
}

function statusDetailesMember() {
	// data-aos 에 의해 부모에 transform css로 인하여 모달이 제대로 작동되지 않는 현상 해결
	$('#memberStatusDetailesDialogModal').appendTo('body');
	$('#memberStatusDetailesDialogModal').modal('show');	
}

function selectStatusChange() {
	const f = document.memberStatusDetailesForm;

	let code = f.status_code.value;
	let memo = f.status_code.options[f.status_code.selectedIndex].text;
	
	f.memo.value = '';	
	if(! code) {
		return;
	}

	if(code!=='0' && code!=='8') {
		f.memo.value = memo;
	}
	
	f.memo.focus();
}

function updateMember() {
	// data-aos 에 의해 부모에 transform css로 인하여 모달이 제대로 작동되지 않는 현상 해결
	$('#memberUpdateDialogModal').appendTo('body');
	$('#memberUpdateDialogModal').modal('show');
}

function updateMemberOk(page) {
	// 회원 정보 변경(권한, 이름, 생년월일)
	const f = document.memberUpdateForm;

	if( ! f.name.value ) {
		alert('이름을 입력 하세요.');
		f.name.focus();
		return;
	}
	
	if(f.userLevel.value === '0' || f.userLevel.value === '50') {
		f.enabled.value = '0';	
	}
	
	if( ! confirm('회원 정보를 수정하시겠습니까 ? ')) {
		return;
	}
	
	let url = '${pageContext.request.contextPath}/admin/memberManage/updateMember';
	let params = $('#memberUpdateForm').serialize();

	const fn = function(data){
		listMember(page);
	};
	ajaxRequest(url, 'post', params, 'json', fn);
	
	$('#memberUpdateDialogModal').modal('hide');
}

function deleteMember(memberIdx) {
	// 회원 삭제
	
}

function updateStatusOk(page) {
	// 회원 상태 변경
	const f = document.memberStatusDetailesForm;

	if( ! f.status_code.value ) {
		alert('상태 코드를 선택하세요.');
		f.status_code.focus();
		return;
	}
	if( ! f.memo.value.trim() ) {
		alert('상태 메모를 입력하세요.');
		f.memo.focus();
		return;
	}
	
	if( ! confirm('상태 정보를 수정하시겠습니까 ? ')) {
		return;
	}
	
	let url = '${pageContext.request.contextPath}/admin/memberManage/updateMemberStatus';
	let params = $('#memberStatusDetailesForm').serialize();

	const fn = function(data){
		listMember(page);
	};
	ajaxRequest(url, 'post', params, 'json', fn);
	
	$('#memberStatusDetailesDialogModal').modal('hide');
}

function memberAnalysis() {
	// 연령별 어낼러시스(분석) - echarts bar
	let out;
	out = `
		<div class="row gy-4 mt-2">
			<div class="col-md-4">
				<h6 class="text-center">연령대별 회원수</h6>
				<div id="barchart-container" style="height: 370px;"></div>
			</div>
		</div>
	`;
	
	$('#nav-tabContent').empty();
	$('#nav-tabContent').html(out);

	let url = '${pageContext.request.contextPath}/admin/memberManage/memberAgeSection';
	$.getJSON(url, function(data){
		let titles = [];
		let values = [];
		
		for(let item of data.list) {
			titles.push(item.SECTION);
			values.push(item.COUNT);
		}
		
		const chartDom = document.querySelector('#barchart-container');
		let myChart = echarts.init(chartDom);
		let option;
		
		option = {
			tooltip: {
				trigger: 'item'
			},
			xAxis: {
				type: 'category',
				data: titles
			},
			yAxis: {
				type: 'value'
			},
			series: [
				{
					data: values,
					type: 'bar'
				}
			]
		};
				
		option && myChart.setOption(option);
	});
}
</script>

<footer>
	<jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>
