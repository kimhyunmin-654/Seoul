<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>채팅방</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/chat.css">
</head>
<body>

    <div class="container">
        <h2>채팅방입니다</h2>

        <div>
            <p>roomId: ${room_id}</p>
            <p>productId: ${product_id}</p>
            <p>buyerId: ${buyer_id}</p>
        </div>
        
        <p>이 페이지는 채팅방 테스트용입니다. 추후 채팅 UI와 메시지를 이곳에 출력합니다.</p>
    </div>

</body>
</html>
