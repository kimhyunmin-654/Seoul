<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<style>
.container {
    max-width: 500px;
    margin-top: 50px;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}
</style>
</head>
<body>
    <div class="container bg-light">
        <h2 class="text-center mb-4">회원 탈퇴</h2>
        <p class="text-center">회원 탈퇴를 위해 비밀번호를 다시 한 번 입력해주세요.</p>
        
        <form name="deleteForm" method="post" action="${pageContext.request.contextPath}/member/delete" class="text-center">
            <div class="mb-3">
                <input type="password" name="password" id="user_pwd" class="form-control" placeholder="비밀번호" required>
            </div>
            <button type="submit" class="btn btn-danger w-100">회원 탈퇴</button>
            <a href="javascript:history.back()" class="btn btn-secondary mt-3 w-100">취소</a>
        </form>
    </div>
</body>
</html>
