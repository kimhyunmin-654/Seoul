<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div id="chatMessages">
  <c:forEach var="m" items="${messages}" varStatus="st">

    <c:set var="isMe" value="${not empty sessionScope.member and sessionScope.member.member_id == m.sender_id}" />

    <div class="co-line ${isMe ? 'me' : 'other'}" data-sender-id="${m.sender_id}">

      <img class="avatar"
           src="${pageContext.request.contextPath}/uploads/member/${empty m.profile_photo ? 'avatar.png' : m.profile_photo}"
           onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/dist/images/avatar.png'"
           alt="avatar">

      <div class="bubble">
        <div class="nick"><c:out value="${empty m.nickname ? '상대' : m.nickname}"/></div>
        <div class="text"><c:out value="${m.message}"/></div>
      </div>

      <div class="time"><fmt:formatDate value="${m.sent_time}" pattern="HH:mm"/></div>
    </div>

  </c:forEach>
</div>