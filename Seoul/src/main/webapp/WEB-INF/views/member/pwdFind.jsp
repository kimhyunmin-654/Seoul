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
	<div class="section bg-light">
		<div class="container">

			<div class="row justify-content-center" data-aos="fade-up" data-aos-delay="200">
				<div class="col-md-5">
					<div class="bg-white box-shadow my-5 p-5">
	                    <h3 class="text-center pt-3">패스워드 찾기</h3>
	                    
	                    <form name="pwdForm" action="" method="post" class="row g-3 mb-2">
							<div class="col-12">
								<p class="form-control-plaintext text-center">
									회원 아이디를 입력 하세요.
								</p>
	                        </div>
	                        	                    
							<div class="col-12">
								<input type="text" name="login_id" class="form-control form-control-lg" placeholder="아이디">
							</div>
							<div class="col-12 text-center">
								<button type="button" class="btn-accent btn-lg w-100" onclick="sendOk();">확인 <i class="bi bi-check2"></i></button>
							</div>
	                    </form>
	                    
						<div>
							<p class="form-control-plaintext text-center text-danger">${message}</p>
						</div>

	                </div>
	
				</div>
			</div>

		</div>
	</div>
</main>

<script type="text/javascript">
function sendOk() {
	const f = document.pwdForm;

	if(! f.login_id.value.trim()) {
		alert('아이디를 입력하세요. ');
		f.login_id.focus();
		return;
	}

	f.action = '${pageContext.request.contextPath}/member/pwdFind';
	f.submit();
}
</script>


</body>
</html>