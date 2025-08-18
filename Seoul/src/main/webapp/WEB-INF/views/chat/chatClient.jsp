<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="chat-wrapper">

  <!-- 상단: 판매자 정보 or 상품 정보 -->
  <div class="chat-header">
    <h5>판매자: ${sellerName}</h5>
    <p>상품: ${productName}</p>
  </div>

  <!-- 메시지 출력 영역 -->
  <div class="chat-messages" id="chatMessages">
    <c:forEach var="msg" items="${messages}">
      <div class="${msg.senderId == sessionScope.member.member_id ? 'msg-right' : 'msg-left'}">
        <span>${msg.content}</span>
        <small><fmt:formatDate value="${msg.sendDate}" pattern="HH:mm" /></small>
      </div>
    </c:forEach>
  </div>

  <!-- 메시지 입력 영역 -->
  <div class="chat-input">
    <textarea id="messageInput" placeholder="메시지를 입력하세요..."></textarea>
    <button id="sendBtn" onclick="sendMessage()">보내기</button>
  </div>

</div>

<script>
const ws = new WebSocket("ws://localhost:9090/Seoul/chat.msg");

ws.onopen = () => {
  console.log("웹소켓 연결됨");
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  const chatBox = document.getElementById("chatMessages");

  const msgEl = document.createElement("div");
  msgEl.classList.add(data.senderId === ${sessionScope.member.member_id} ? "msg-right" : "msg-left");
  msgEl.innerHTML = `<span>${data.content}</span><small>${data.sendDate}</small>`;
  
  chatBox.appendChild(msgEl);
  chatBox.scrollTop = chatBox.scrollHeight;
};

function sendMessage() {
  const input = document.getElementById("messageInput");
  const message = input.value.trim();
  if(message) {
    ws.send(JSON.stringify({
      roomId: ${roomId},
      senderId: ${sessionScope.member.member_id},
      content: message
    }));
    input.value = "";
  }
}
</script>
