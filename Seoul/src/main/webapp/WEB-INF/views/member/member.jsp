<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>서울 한바퀴</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/member.css" type="text/css">
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
</head>
<body>



<main>
  <div class="page-title">
    <div class="container">
      <h1>${mode=="account2"?"일반회원가입":"회원정보수정"}</h1>
      <div class="page-title-underline-accent"></div>
    </div>
  </div>

  <div class="container">
    <section class="card">
      <div class="card-section">
        <form name="memberForm" method="post" enctype="multipart/form-data" class="layout">
          <input type="hidden" name="loginIdValid" id="loginIdValid" value="false">
          <input type="hidden" name="nicknameValid" id="nicknameValid" value="false">
          <input type="hidden" name="profile_photo" id="profile_photo" value="${empty dto.profile_photo ? '' : dto.profile_photo}">

          <aside class="panel">
            <h2>프로필</h2>
            <div class="avatar-col">
              <i id="avatarIcon" class="fa-solid fa-circle-user" style="font-size:120px;color:#c7cbd1;"></i>
              <img id="avatarImg" class="img-avatar" alt="프로필 이미지" style="display:none">
              <label for="selectFile" class="btn" style="width:100%">
                사진 업로드
                <input type="file" id="selectFile" name="selectFile" hidden="" accept="image/png,image/jpeg,image/jpg">
              </label>
              <button type="button" class="btn btn-ghost btn-photo-init" style="width:100%">초기화</button>
              <div class="caption">JPG/PNG 권장, 최대 800KB</div>
            </div>
          </aside>

          <section>
            <h3 class="section-title">계정 정보</h3>

            <div class="grid-1">
              <div class="field">
                <label class="label" for="login_id">아이디</label>
                <div class="row-inline">
                  <input id="login_id" name="login_id" class="input" type="text" value="${dto.login_id}" ${mode=="update" ? "readonly":""} placeholder="아이디 입력" autofocus>
                  <c:if test="${mode=='account2'}">
                    <button type="button" class="btn" onclick="userIdCheck()">중복확인</button>
                  </c:if>
                </div>
                <c:if test="${mode=='account2'}"><div class="hint help-block">아이디는 5~10자, 영문 시작.</div></c:if>
              </div>
            </div>

            <div class="grid-2">
              <div class="field">
                <label class="label" for="password">비밀번호</label>
                <input id="password" name="password" class="input" type="password" autocomplete="off" placeholder="비밀번호">
                <div class="hint">5~10자, 숫자/특수문자 1개 이상 포함</div>
              </div>
              <div class="field">
                <label class="label" for="password2">비밀번호 확인</label>
                <input id="password2" name="password2" class="input" type="password" autocomplete="off" placeholder="비밀번호 확인">
                <div id="pwMatchHint" class="hint"></div>
              </div>
            </div>

            <div class="divider"></div>
            <h3 class="section-title">사용자 정보</h3>

            <div class="grid-2">
              <div class="field">
                <label class="label" for="Name">이름</label>
                <input id="Name" name="name" class="input" type="text" value="${dto.name}" ${mode=="update" ? "readonly":""} placeholder="이름(한글 2~5자)">
                <div class="hint">한글 2~5자</div>
              </div>
              <div class="field wrap-nickname">
                <label class="label" for="nickname">닉네임</label>
                <div class="row-inline">
                  <input id="nickname" name="nickname" class="input" type="text" value="${dto.nickname}" placeholder="닉네임">
                  <button type="button" class="btn" onclick="nickNameCheck()">중복확인</button>
                </div>
                <div id="nicknameHelp" class="hint help-block2">한글/영문/숫자, 2~10자</div>
              </div>
            </div>

            <div class="grid-1">
              <div class="field">
                <label class="label" for="email">이메일</label>
                <input id="email" name="email" class="input" type="text" value="${dto.email}" placeholder="name@example.com">
              </div>
            </div>

            <div class="divider"></div>
            <h3 class="section-title">약관</h3>
            <div class="field">
              <label style="display:flex;gap:10px;align-items:center">
                <input class="input-checkbox" type="checkbox" name="agree" id="agree" checked onchange="document.memberForm.sendButton.disabled=!this.checked">
                <span class="hint">이용약관에 동의합니다.</span>
              </label>
            </div>

            <div class="actions">
              <button type="button" name="sendButton" class="btn btn-acc" onclick="memberOk()">
                ${mode=="update"?"정보수정":"회원가입"}
              </button>
              <button type="button" class="btn" onclick="location.href='${pageContext.request.contextPath}/';">
                ${mode=="update"?"수정취소":"가입취소"}
              </button>
            </div>
          </section>
        </form>
      </div>
    </section>
  </div>
</main>


<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
window.addEventListener('DOMContentLoaded', () => {
	  const img = '${dto.profile_photo}';

	  const avatarImg = document.getElementById('avatarImg');
	  const avatarIcon = document.getElementById('avatarIcon');
	  const inputEL = document.getElementById('selectFile');
	  const btnEL = document.querySelector('.btn-photo-init');

	  const defaultImg = '${pageContext.request.contextPath}/dist/images/user.png';
	  const uploadPath = '${pageContext.request.contextPath}/uploads/member/';
	  const fullPath = img ? uploadPath + img : defaultImg;

	  // 초기 이미지 세팅
	  avatarImg.src = fullPath;
	  avatarImg.style.display = 'block';
	  avatarIcon.style.display = 'none';

	  if (!img) {
	    avatarImg.style.display = 'none';
	    avatarIcon.style.display = 'inline-block';
	  }

	  const maxSize = 800 * 1024;

	  // 이미지 업로드 미리보기
	  inputEL.addEventListener('change', (e) => {
	    const file = e.target.files?.[0];
	    if (!file) return;

	    if (file.size > maxSize || !file.type.startsWith('image/')) {
	      alert('이미지 파일(jpg/png) 최대 800KB까지 업로드 가능합니다.');
	      inputEL.value = '';
	      return;
	    }

	    const reader = new FileReader();
	    reader.onload = (ev) => {
	      avatarImg.src = ev.target.result;
	      avatarImg.style.display = 'block';
	      avatarIcon.style.display = 'none';
	    };
	    reader.readAsDataURL(file);
	  });

	  // 초기화 버튼 처리
	  btnEL.addEventListener('click', () => {
	    inputEL.value = '';

	    if (img) {
	      // 삭제 요청
	      if (!confirm('등록된 이미지를 삭제하시겠습니까 ?')) return;

	      $.post('${pageContext.request.contextPath}/member/deleteProfile', { profile_photo: img }, (data) => {
	        if (data.state === 'true') {
	          document.getElementById('profile_photo').value = '';
	          avatarImg.src = defaultImg;
	          avatarImg.style.display = 'none';
	          avatarIcon.style.display = 'inline-block';
	        } else {
	          avatarImg.src = uploadPath + img;
	        }
	        inputEL.value = '';
	      }, 'json');
	    } else {
	      avatarImg.src = defaultImg;
	      avatarImg.style.display = 'none';
	      avatarIcon.style.display = 'inline-block';
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
    

    f.action = '${pageContext.request.contextPath}/member/${mode}';
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
				$('#login_id').closest('.field').find('.help-block').html(str);
				$('#loginIdValid').val('true');
			} else {
				let str = '<span style="color:red; font-weight: bold;">' + login_id + '</span> 아이디는 사용할수 없습니다.';
				$('#login_id').closest('.field').find('.help-block').html(str);
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
				$('#nicknameValid').val('true');
			} else {
				let str = '<span style="color:red; font-weight: bold;">' + nickname + '</span> 닉네임은 사용할 수 없습니다.';
				$('#nickname').closest('.wrap-nickname').find('.help-block2').html(str);
				$('#nickname').val('');
				$('#nicknameValid').val('false');
				$('#nickname').focus();
			}
		}
	});
}


</script>


</body>
</html>