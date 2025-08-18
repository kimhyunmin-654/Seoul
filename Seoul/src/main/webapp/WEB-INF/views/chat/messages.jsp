<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div id="chatMessages">
  <c:forEach var="m" items="${messages}" varStatus="st">

    <!-- isMe 여부: 세션에 저장된 member.member_id 가 snake_case면 member_id 사용 -->
    <c:set var="isMe" value="${not empty sessionScope.member and sessionScope.member.member_id == m.sender_id}" />

    <!-- 한 줄 -->
    <div class="co-line ${isMe ? 'me' : 'other'}" data-sender-id="${m.sender_id}">

      <!-- 아바타: 항상 보여줌 (이미지 없으면 기본이미지) -->
      <img class="avatar"
           src="${pageContext.request.contextPath}/uploads/member/${empty m.profile_photo ? 'avatar.png' : m.profile_photo}"
           onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/dist/images/avatar.png'"
           alt="avatar">

      <!-- 말풍선: 닉네임 항상 보여줌 (작성자가 비어있으면 '상대' 대체) -->
      <div class="bubble">
        <div class="nick"><c:out value="${empty m.nickname ? '상대' : m.nickname}"/></div>
        <div class="text"><c:out value="${m.message}"/></div>
      </div>

      <!-- 시간은 끝에 표시 -->
      <div class="time"><fmt:formatDate value="${m.sent_time}" pattern="HH:mm"/></div>
    </div>

  </c:forEach>
</div>