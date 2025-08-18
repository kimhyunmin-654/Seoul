<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>


<div class="chat-box">
  <div class="chat-header">
    <h5>고객과의 채팅</h5>
  </div>

  <!-- 메시지 목록 영역 -->
  <div class="chat-messages" id="chatMessages" style="height: 300px; overflow-y: auto;">
    <!-- 기존 메시지 및 WebSocket 수신 메시지 추가 -->
  </div>

  <!-- 메시지 입력 영역 -->
  <div class="chat-input-box mt-2 d-flex">
    <input type="text" id="chatInput" class="form-control" placeholder="메시지를 입력하세요...">
    <button class="btn btn-primary ms-2" onclick="sendMessage()">전송</button>
  </div>
</div>

<script type="text/javascript">
  const roomId = "${room_id}";
  const senderId = "${sessionScope.member.member_id}";
  const ws = new WebSocket("ws://localhost:9090/ws/chat?roomId=" + roomId);

  ws.onopen = () => {
    console.log("WebSocket 연결됨");

    // 입장 메시지 전송 (옵션)
    ws.send(JSON.stringify({
      type: 'join',
      roomId: roomId,
      senderId: senderId
    }));
  };

  ws.onmessage = (event) => {
    const msg = JSON.parse(event.data);
    appendMessage(msg.senderName || "상대", msg.content);
  };

  function sendMessage() {
    const input = document.getElementById("chatInput");
    const content = input.value.trim();
    if (!content) return;

    const message = {
      type: 'chat',
      room_id: roomId,
      sender_id: senderId,
      content: content
    };

    ws.send(JSON.stringify(message));
    appendMessage("나", content);
    input.value = '';
  }

  function appendMessage(sender, content) {
    const msgDiv = document.createElement("div");
    msgDiv.innerHTML = `<strong>${sender}:</strong> ${content}`;
    const chatBox = document.getElementById("chatMessages");
    chatBox.appendChild(msgDiv);
    chatBox.scrollTop = chatBox.scrollHeight;
  }
</script>



