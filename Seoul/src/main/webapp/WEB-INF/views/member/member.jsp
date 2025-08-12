<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Spring</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/member.css" type="text/css">
</head>
<body>



<main>
  <div class="page-title">
    <div class="container" data-aos="fade-up">
      <h1>${mode=="account"?"일반회원가입":"회원정보수정"}</h1>
      <div class="page-title-underline-accent"></div>
    </div>
  </div>

  <div class="section">
    <div class="container" data-aos="fade-up" data-aos-delay="100">

      <section class="card">
        <div class="card-section">
          <div class="layout">
            <!-- 좌측: 프로필 -->
            <aside class="panel">
              <h2>프로필</h2>
              <div class="avatar-col">
                <img src="${pageContext.request.contextPath}/dist/images/user2.png" class="img-avatar" alt="프로필 이미지">
                <label for="selectFile" class="btn btn-default" title="사진 업로드" style="width:100%;">
                  사진 업로드
                  <input type="file" name="selectFile" id="selectFile" hidden="" accept="image/png, image/jpeg">
                </label>
                <button type="button" class="btn btn-ghost btn-photo-init" style="width:100%;">초기화</button>
                <div class="caption">JPG/PNG 권장, 최대 800KB</div>
              </div>
            </aside>

            <!-- 우측: 폼 -->
            <section>
              <form name="memberForm" method="post" enctype="multipart/form-data">
                <h3 class="section-title">계정 정보</h3>

                <!-- 아이디 -->
                <div class="form-row-1 wrap-loginId">
                  <label for="login_id" class="form-label">아이디</label>
                  <div class="input-group">
                    <input class="form-control" type="text" id="login_id" name="login_id" value="${dto.login_id}" ${mode=="update" ? "readonly":""} autofocus>
                    <c:if test="${mode=='account'}">
                      <button type="button" class="btn btn-default" onclick="userIdCheck();">중복검사</button>
                    </c:if>
                  </div>
                  <c:if test="${mode=='account'}">
                    <div class="form-hint help-block" aria-live="polite">아이디는 5~10자, 영문 시작.</div>
                  </c:if>
                </div>

                <!-- 비밀번호 -->
                <div class="form-row">
                  <div>
                    <label for="password" class="form-label">패스워드</label>
                    <input class="form-control" type="password" id="password" name="password" autocomplete="off">
                    <div class="form-hint">5~10자, 숫자/특수문자 1개 이상 포함</div>
                  </div>
                  <div>
                    <label for="password2" class="form-label">패스워드 확인</label>
                    <input class="form-control" type="password" id="password2" name="password2" autocomplete="off">
                    <div class="form-hint" id="pwMatchHint" aria-live="polite"></div>
                  </div>
                </div>

                <div class="divider"></div>
                <h3 class="section-title">사용자 정보</h3>

                <!-- 이름/닉네임 -->
                <div class="form-row">
                  <div>
                    <label for="Name" class="form-label">이름</label>
                    <input class="form-control" type="text" id="Name" name="name" value="${dto.name}" ${mode=="update" ? "readonly":""}>
                    <div class="form-hint">한글 2~5자</div>
                  </div>
                  <div class="wrap-nickname">
                    <label for="nickname" class="form-label">닉네임</label>
                    <div class="input-group">
                      <input class="form-control" type="text" id="nickname" name="nickname" value="${dto.nickname}">
                      <button type="button" class="btn btn-default" onclick="nickNameCheck();">중복검사</button>
                    </div>
                    <div id="nicknameHelp" class="form-hint help-block2" aria-live="polite">한글/영문/숫자, 2~10자</div>
                  </div>
                </div>

                <!-- 이메일 -->
                <div class="form-row-1">
                  <div>
                    <label for="email" class="form-label">이메일</label>
                    <input class="form-control" type="text" id="email" name="email" value="${dto.email}">
                    <div class="form-hint">예: name@example.com</div>
                  </div>
                </div>

                <div class="divider"></div>
                <h3 class="section-title">약관</h3>

                <!-- 약관 동의 -->
                <div class="form-row-1">
                  <label class="form-label" for="agree">약관 동의</label>
                  <label style="display:flex;align-items:center;gap:10px;cursor:pointer;">
                    <input class="form-check-input" type="checkbox" id="agree" name="agree" checked onchange="document.memberForm.sendButton.disabled = !this.checked">
                    <span class="caption"><a href="#" class="border-link-right">이용약관</a>에 동의합니다.</span>
                  </label>
                </div>

                <!-- 액션 -->
                <div class="actions">
                  <button type="button" name="sendButton" class="btn btn-accent" onclick="memberOk();">
                    ${mode=="update"?"정보수정":"회원가입"}
                  </button>
                  <button type="button" class="btn btn-default" onclick="location.href='${pageContext.request.contextPath}/';">
                    ${mode=="update"?"수정취소":"가입취소"}
                  </button>
                </div>

                <!-- hidden -->
                <input type="hidden" name="loginIdValid" id="loginIdValid" value="false">
                <input type="hidden" name="nicknameValid" id="nicknameValid" value="false">
              </form>
            </section>
          </div>
        </div>
      </section>

    </div>
  </div>
</main>


<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
window.addEventListener('DOMContentLoaded', () => {
	  const img = '${dto.profile_photo}';

	  const avatarEL = document.querySelector('.img-avatar');
	  const inputEL  = document.getElementById('selectFile');        // ✅ 폼 범위 제거
	  const btnEL    = document.querySelector('.btn-photo-init');     // ✅ 폼 범위 제거

	  // 초기 아바타 설정
	  if (img) {
	    avatarEL.src = '${pageContext.request.contextPath}/uploads/member/' + img;
	  } else {
	    avatarEL.src = '${pageContext.request.contextPath}/dist/images/user.png';
	  }

	  const maxSize = 800 * 1024;

	  // 파일 선택 시 미리보기
	  inputEL.addEventListener('change', (ev) => {
	    const file = ev.target.files && ev.target.files[0];
	    if (!file) {
	      avatarEL.src = img
	        ? '${pageContext.request.contextPath}/uploads/member/' + img
	        : '${pageContext.request.contextPath}/dist/images/user.png';
	      return;
	    }
	    if (file.size > maxSize || !/^image\//.test(file.type)) {
	      alert('이미지 파일(jpg/png) 최대 800KB까지 업로드 가능합니다.');
	      inputEL.value = '';
	      return;
	    }
	    const reader = new FileReader();
	    reader.onload = (e) => { avatarEL.src = e.target.result; };
	    reader.readAsDataURL(file);
	  });

	  // 초기화 버튼
	  btnEL.addEventListener('click', () => {
	    inputEL.value = '';
	    avatarEL.src = img
	      ? '${pageContext.request.contextPath}/uploads/member/' + img
	      : '${pageContext.request.contextPath}/dist/images/user.png';
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
    

    f.action = '${pageContext.request.contextPath}/member/account2';
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