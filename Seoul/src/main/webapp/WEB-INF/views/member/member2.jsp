<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Spring</title>
</head>
<body>



<main>
	<div class="page-title">
		<div class="container align-items-center" data-aos="fade-up">
			<h1>셀러회원가입</h1>
			<div class="page-title-underline-accent"></div>
		</div>
	</div>
    
	<div class="section">
		<div class="container" data-aos="fade-up" data-aos-delay="100">
			<div class="row justify-content-center">
				<div class="col-md-10 bg-white box-shadow my-4 p-5">
					<form name="memberForm" method="post" enctype="multipart/form-data">
						<div class="d-flex align-items-start align-items-sm-center gap-3 pb-4 border-bottom">
							<img src="${pageContext.request.contextPath}/dist/images/user.png" class="img-avatar d-block w-px-100 h-px-100 rounded">
							<div class="ms-3">
								<label for="selectFile" class="btn-accent me-2 mb-4" tabindex="0" title="사진 업로드">
									<span class="d-none d-sm-block">사진 업로드</span>
									<i class="bi bi-upload d-block d-sm-none"></i>
									<input type="file" name="selectFile" id="selectFile" hidden="" accept="image/png, image/jpeg">
								</label>
								<button type="button" class="btn-photo-init btn-default mb-4" title="초기화">
									<span class="d-none d-sm-block">초기화</span>
									<i class="bi bi-arrow-counterclockwise d-block d-sm-none"></i>
								</button>
								<div>Allowed JPG, GIF or PNG. Max size of 800K</div>
							</div>
						</div>
						
						<div class="row g-3 pt-4">
							<div class="col-md-12 wrap-loginId">
								<label for="login_id" class="form-label font-roboto">아이디</label>
								<div class="row g-3">
									<div class="col-md-6">
										<input class="form-control" type="text" id="login_id" name="login_id" value="${dto.login_id}"
											${mode=="update" ? "readonly ":""} autofocus>									
									</div>
									<div class="col-md-6">
										<c:if test="${mode=='account'}">
											<button type="button" class="btn-default" onclick="userIdCheck();">아이디중복검사</button>
										</c:if>
									</div>
								</div>
								<c:if test="${mode=='account'}">
									<small class="form-control-plaintext help-block">아이디는 5~10자 이내이며, 첫글자는 영문자로 시작해야 합니다.</small>
								</c:if>
							</div>
	
							<div class="col-md-12">
								<div class="row g-3">
									<div class="col-md-6">
										<label for="password" class="form-label font-roboto">패스워드</label>
										<input class="form-control" type="password" id="password" name="password" autocomplete="off" >
										<small class="form-control-plaintext">패스워드는 5~10자이며 하나 이상의 숫자나 특수문자를 포함 합니다.</small>
									</div>
									<div class="col-md-6">
										<label for="password2" class="form-label font-roboto">패스워드확인</label>
										<input class="form-control" type="password" id="password2" name="password2" autocomplete="off">
										<small class="form-control-plaintext">패스워드를 한번 더 입력해주세요.</small>
									</div>
								</div>
							</div>	
		
							<div class="col-md-6">
								<label for="Name" class="form-label font-roboto">이름</label>
								<input class="form-control" type="text" id="Name" name="name" value="${dto.name}"
									${mode=="update" ? "readonly ":""}>
							</div>

							<div class="col-md-6 wrap-nickname">
								<label for="nickname" class="form-label font-roboto">닉네임</label>
								<div class="row g-3">
									<div class="col-md-6">
										<input class="form-control" type="text" id="nickname" name="nickname" value="${dto.nickname}">									
									</div>
									<div class="col-md-6">
										<c:if test="${mode=='account'}">
											<button type="button" class="btn-default" onclick="nickNameCheck();">닉네임중복검사</button>
										</c:if>
									</div>
								</div>
								<c:if test="${mode=='account'}">
								    <small id="nicknameHelp" class="form-control-plaintext help-block2">
							        닉네임은 한글/영어/숫자만 허용, 2~10자만 가능합니다.
							   		</small>
								</c:if>
							</div>
							
	
							<div class="col-md-6">
								<label for="email" class="form-label font-roboto">이메일</label>
								<input class="form-control" type="text" id="email" name="email" value="${dto.email}">
							</div>
							
							<div class="col-md-12">
								<label for="agree" class="form-label font-roboto">약관 동의</label>
								<div class="form-check">
									<input class="form-check-input" type="checkbox" name="agree" id="agree"
											checked
											onchange="form.sendButton.disabled = !checked">
									<label for="agree" class="form-check-label">
										<a href="#" class="text-primary border-link-right">이용약관</a>에 동의합니다.
									</label>
								</div>
							</div>
							
							<div class="col-md-12 text-center">
								<button type="button" name="sendButton" class="btn-accent btn-lg" onclick="memberOk();"> ${mode=="update"?"정보수정":"회원가입"} <i class="bi bi-check2"></i></button>
								<button type="button" class="btn-default btn-lg" onclick="location.href='${pageContext.request.contextPath}/';"> ${mode=="update"?"수정취소":"가입취소"} <i class="bi bi-x"></i></button>
								<input type="hidden" name="loginIdValid" id="loginIdValid" value="false">
								<input type="hidden" name="nicknameValid" id="nicknameValid" value="false">
							</div>
						</div>
						
					</form>
				</div>
			</div>
			
		</div>
	</div>
</main>


<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
window.addEventListener('DOMContentLoaded', ev => {
	let img = '${dto.profile_photo}';

	const avatarEL = document.querySelector('.img-avatar');
	const inputEL = document.querySelector('form[name=memberForm] input[name=selectFile]');
	const btnEL = document.querySelector('form[name=memberForm] .btn-photo-init');
	
	let avatar;
	if( img ) {
		avatar = '${pageContext.request.contextPath}/uploads/member/' + img;
		avatarEL.src = avatar;
	}
	
	const maxSize = 800 * 1024;
	inputEL.addEventListener('change', ev => {
		let file = ev.target.files[0];
		if(! file) {
			if( img ) {
				avatar = '${pageContext.request.contextPath}/uploads/member/' + img;
			} else {
				avatar = '${pageContext.request.contextPath}/dist/images/user.png';
			}
			avatarEL.src = avatar;
			
			return;
		}
		
		if(file.size > maxSize || ! file.type.match('image.*')) {
			inputEL.focus();
			return;
		}
		
		var reader = new FileReader();
		reader.onload = function(e) {
			avatarEL.src = e.target.result;
		}
		reader.readAsDataURL(file);			
	});
	
	btnEL.addEventListener('click', ev => {
		if( img ) {
			avatar = '${pageContext.request.contextPath}/uploads/member/' + img;

			avatarEL.src = avatar;
		} else {
			avatar = '${pageContext.request.contextPath}/dist/images/user.png';
			inputEL.value = '';
			avatarEL.src = avatar;
		}
	});
});

function isValidDateString(dateString) {
	try {
		const date = new Date(dateString);
		const [year, month, day] = dateString.split("-").map(Number);
		
		return date instanceof Date && !isNaN(date) && date.getDate() === day;
	} catch(e) {
		return false;
	}
}

function memberOk() {
	const f = document.memberForm;
	let str, p;

	p = /^[a-z][a-z0-9_]{4,9}$/i;
	str = f.login_id.value;
	if( ! p.test(str) ) { 
		alert('아이디를 다시 입력 하세요. ');
		f.login_id.focus();
		return;
	}

	
	let mode = '${mode}';
	if( mode === 'account' && f.loginIdValid.value === 'false' ) {
		str = '아이디 중복 검사가 실행되지 않았습니다.';
		$('.wrap-loginId').find('.help-block').html(str);
		f.login_id.focus();
		return;
	}


	p =/^(?=.*[a-z])(?=.*[!@#$%^*+=-]|.*[0-9]).{5,10}$/i;
	str = f.password.value;
	if( ! p.test(str) ) { 
		alert('패스워드를 다시 입력 하세요. ');
		f.password.focus();
		return;
	}

	if( str !== f.password2.value ) {
        alert('패스워드가 일치하지 않습니다. ');
        f.password.focus();
        return;
	}
	
	p = /^[가-힣]{2,5}$/;
    str = f.name.value;
    if( ! p.test(str) ) {
        alert('이름을 다시 입력하세요. ');
        f.name.focus();
        return;
    }
    
	p = /^[가-힣a-zA-Z0-9]{2,10}$/;
    str = f.nickname.value;
    if( ! p.test(str) ) {
        alert('닉네임을 다시 입력하세요. ');
        f.nickname.focus();
        return;
    }

    
    p = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;    
    str = f.email.value;
    if( ! p.test(str) ) {
        alert('이메일을 입력하세요. ');
        f.email.focus();
        return;
    }
    

    f.action = '${pageContext.request.contextPath}/member/account3';
    f.submit();
}

function userIdCheck() {
	// 아이디 중복 검사
	let login_id = $('#login_id').val();
	
	if(!/^[a-z][a-z0-9_]{4,9}$/i.test(login_id)) {
		let str = '아이디는 5~10자 이내이며, 첫글자는 영문자로 시작해야 합니다.';
		$('#login_id').focus();
		$('#login_id').closest('.wrap-loginId').find('.help-block').html(str);
		return;
	}
	
	let url = '${pageContext.request.contextPath}/member/userIdCheck';
	let params = 'login_id=' + login_id;
	$.ajax({
		type: 'POST',
		url: url,
		data: params,
		dataType: 'json',
		success: function(data) {
			let passed = data.passed;
			
			if(passed === 'true') {
				let str = '<span style="color:blue; font-weight: bold;">' + login_id + '</span> 아이디는 사용가능 합니다.';
				$('#login_id').closest('.wrap-loginId').find('.help-block').html(str);
				$('#loginIdValid').val('true');
			} else {
				let str = '<span style="color:red; font-weight: bold;">' + login_id + '</span> 아이디는 사용할수 없습니다.';
				$('#login_id').closest('.wrap-loginId').find('.help-block').html(str);
				$('#login_id').val('');
				$('#loginIdValid').val('false');
				$('#login_id').focus();
			}
		}
	});

}


function nickNameCheck() {
	// 닉네임 중복 검사
	let nickname = $('#nickname').val().trim();

	if (!/^[가-힣a-zA-Z0-9]{2,10}$/.test(nickname)) {
		let str = '닉네임은 한글/영어/숫자만 허용, 2~10자만 가능합니다.';
		$('#nicknameHelp').html(str).css('color', 'red');
		$('#nickname').focus();
		return;
	}

	let url = '${pageContext.request.contextPath}/member/userNickNameCheck';
	let params = { nickname };

	$.ajax({
		type: 'POST',
		url: url,
		data: params,
		dataType: 'json',
		success: function(data) {
			
			let passed = data.passed;
			
			if(passed === 'true') {
				let str = '<span style="color:blue; font-weight: bold;">' + nickname + '</span> 닉네임은 사용가능 합니다.';
				$('#nickname').closest('.wrap-nickname').find('.help-block2').html(str);
				$('#loginIdValid').val('true');
			} else {
				let str = '<span style="color:red; font-weight: bold;">' + nickname + '</span> 닉네임은 사용할 수 없습니다.';
				$('#nickname').closest('.wrap-nickname').find('.help-block2').html(str);
				$('#nickname').val('');
				$('#loginIdValid').val('false');
				$('#nickname').focus();
			}
		}
	});
}


</script>


</body>
</html>