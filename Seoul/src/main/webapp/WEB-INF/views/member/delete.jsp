<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 350px;
        }
        h2 {
            color: #333;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
            text-align: left;
        }
        input[type="password"] {
            width: calc(100% - 20px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 16px;
        }
        button {
            width: 100%;
            padding: 12px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 18px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #c82333;
        }
        #message {
            margin-top: 15px;
            font-weight: bold;
        }
        .success {
            color: #28a745;
        }
        .error {
            color: #dc3545;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>회원 탈퇴</h2>
    <div class="form-group">
        <label for="password">비밀번호 확인</label>
        <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요">
    </div>
    <button id="deleteBtn">탈퇴하기</button>
    <p id="message"></p>
</div>

<script>
    $(document).ready(function() {
        $('#deleteBtn').on('click', function(e) {
            e.preventDefault();
            
            var password = $('#password').val();
            
            if (password.trim() === '') {
                $('#message').text('비밀번호를 입력하세요.').removeClass('success').addClass('error');
                return;
            }
            
            $.ajax({
                url: '${pageContext.request.contextPath}/member/delete',
                type: 'POST',
                data: { password: password },
                dataType: 'json',
                success: function(response) {
                    if (response.state === 'true') {
                        $('#message').text(response.message).removeClass('error').addClass('success');
                        alert(response.message);
                        window.location.href = '${pageContext.request.contextPath}/'; 
                    } else {
                        $('#message').text(response.message).removeClass('success').addClass('error');
                    }
                },
                error: function() {
                    $('#message').text('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.').removeClass('success').addClass('error');
                }
            });
        });
    });
</script>

</body>
</html>
