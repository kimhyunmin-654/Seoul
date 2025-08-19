<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div id="chatRoomList">
  <c:forEach var="room" items="${chatRooms}">
	<div class="chat-room-item">
	  <a class="chat-room-link"
	     href="#"
	     data-room-id="${room.room_id}"
	     data-product-id="${room.product_id}"
	     data-seller-id="${room.seller_id}"
	     data-product-name="${room.product_name}"
	     data-opponent-id="${sessionScope.member.member_id == room.buyer_id ? room.seller_id : room.buyer_id}"
	     data-opponent-nick="${room.nickname}">
	     
	     <div class="header-row">
	       <div class="title-wrap">
	         <span class="nickname">${room.nickname}</span>
	         <span class="productname">${room.product_name}</span>
	       </div>
	       <div class="time">
	         <c:if test="${not empty room.lastTime}">
	           <fmt:formatDate value="${room.lastTime}" pattern="MM/dd HH:mm"/>
	         </c:if>
	       </div>
	     </div>
	
	     <div class="message-preview">
	       <c:out value="${room.lastMessage != null ? room.lastMessage : '메시지가 없습니다.'}"/>
	     </div>
	  </a>
	
	  <button type="button" class="btn-chat-delete" data-room-id="${room.room_id}" title="채팅방 삭제">
	    <i class="bi bi-trash"></i>
	  </button>
	</div>
  </c:forEach>
</div>