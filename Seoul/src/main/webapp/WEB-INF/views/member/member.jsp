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
	<!-- Page Title -->
	<div class="page-title">
		<div class="container align-items-center" data-aos="fade-up">
			<h1>회원가입</h1>
			<div class="page-title-underline-accent"></div>
		</div>
	</div>
    
	<!-- Page Content -->    
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
								<label for="fullName" class="form-label font-roboto">이름</label>
								<input class="form-control" type="text" id="fullName" name="name" value="${dto.name}"
									${mode=="update" ? "readonly ":""}>
							</div>
							<div class="col-md-6">
								<label for="birth" class="form-label font-roboto">생년월일</label>
								<input class="form-control" type="date" id="birth" name="birth" value="${dto.birth}"
									${mode=="update" ? "readonly ":""}>
							</div>
	
							<div class="col-md-6">
								<label for="email" class="form-label font-roboto">이메일</label>
								<input class="form-control" type="text" id="email" name="email" value="${dto.email}">
							</div>
							<div class="col-md-6">
								<label for="receive_email" class="form-label font-roboto">메일 수신</label>
								<div class="form-check pt-1">
									<input class="form-check-input" type="checkbox" name="receive_email" id="receive_email"
										value="1" ${empty dto || dto.receive_email == 1 ? "checked":""}>
									<label class="form-check-label" for="receive_email"> 동의</label>
								</div>
							</div>

							<div class="col-md-6">
								<label for="tel" class="form-label font-roboto">전화번호</label>
								<input class="form-control" type="text" id="tel" name="tel" value="${dto.tel}">
							</div>
							<div class="col-md-6">
								<label for="btn-zip" class="form-label font-roboto">우편번호</label>
								<div class="row g-3">
									<div class="col-8">
										<input class="form-control" type="text" name="zip" id="zip" value="${dto.zip}" readonly tabindex="-1">
									</div>
									<div class="col-4">
										<button type="button" class="btn-default" id="btn-zip" onclick="daumPostcode();">우편번호검사</button>
									</div>
								</div>
							</div>
							
							<div class="col-md-6">
								<label class="form-label font-roboto">기본주소</label>
								<input class="form-control" type="text" name="addr1" id="addr1" value="${dto.addr1}" readonly tabindex="-1">
							</div>
							<div class="col-md-6">
								<label for="addr2" class="form-label font-roboto">상세주소</label>
								<input class="form-control" type="text" name="addr2" id="addr2" value="${dto.addr2}">
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
							</div>
						</div>
						
					</form>
				</div>
			</div>
			
		</div>
	</div>
</main>

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

/*	
	let mode = '${mode}';
	if( mode === 'account' && f.loginIdValid.value === 'false' ) {
		str = '아이디 중복 검사가 실행되지 않았습니다.';
		$('.wrap-loginId').find('.help-block').html(str);
		f.login_id.focus();
		return;
	}
*/

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

    str = f.birth.value;
    if( ! isValidDateString(str) ) {
        alert('생년월일를 입력하세요. ');
        f.birth.focus();
        return;
    }
    
    p = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;    
    str = f.email.value;
    if( ! p.test(str) ) {
        alert('이메일을 입력하세요. ');
        f.email.focus();
        return;
    }
    
    p = /^(010)-?\d{4}-?\d{4}$/;    
    str = f.tel.value;
    if( ! p.test(str) ) {
        alert('전화번호를 입력하세요. ');
        f.tel.focus();
        return;
    }

    f.action = '${pageContext.request.contextPath}/';
    f.submit();
}

function userIdCheck() {
	// 아이디 중복 검사

}

/*
window.addEventListener('DOMContentLoaded', () => {
	const dateELS = document.querySelectorAll('form input[type=date]');
	dateELS.forEach( inputEL => inputEL.addEventListener('keydown', e => e.preventDefault()) );
});
*/
</script>

<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
    function daumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = ''; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    fullAddr = data.roadAddress;

                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    fullAddr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                if(data.userSelectedType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('zip').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('addr1').value = fullAddr;

                // 커서를 상세주소 필드로 이동한다.
                document.getElementById('addr2').focus();
            }
        }).open();
    }
</script>


</body>
</html>