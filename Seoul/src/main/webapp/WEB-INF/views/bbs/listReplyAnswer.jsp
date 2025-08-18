<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:forEach var="vo" items="${listReplyAnswer}">
	<div class="border-bottom m-1">
		<div class="row p-1">
			<div class="col-md-6">
				<div class="row reply-writer">
					<div class="col-lg-1">
						<img src="${pageContext.request.contextPath}/dist/images/person.png" class="avatar-icon">
					</div>
					<div class="col-auto ms-1 align-self-center">
						<div class="name">${vo.nickname}</div>
						<div class="date">${vo.reg_date}</div>
					</div>
				</div>
			</div>
			<div class="col align-self-center text-end">
				<div class="reply-dropdown">
					<span class="dropdown-button"><i class="bi bi-three-dots-vertical"></i></span>
					<div class="reply-menu d-none">
						<c:choose>
							<c:when test="${sessionScope.member.member_id == vo.member_id}">
								<div class="hideReplyAnswer reply-menu-item" data-replyNum="${vo.reply_num}" data-showReply="${vo.show_reply}">${ vo.show_reply==0 ? "숨김" : "표시" }</div>
								<div class="deleteReplyAnswer reply-menu-item" data-replyNum="${vo.reply_num}" data-parentNum="${vo.parent_num}" data-pageNo="${pageNo}">삭제</div>
							</c:when>
							<c:when test="${sessionScope.member.userLevel == 9}">
								<div class="deleteReplyAnswer reply-menu-item" data-replyNum="${vo.reply_num}" data-parentNum="${vo.parent_num}" data-pageNo="${pageNo}">삭제</div>
								<div class="blockManagerReplyAnswer reply-menu-item" data-replyNum="${vo.reply_num}" data-parentNum="${vo.parent_num}" data-pageNo="${pageNo}">${vo.managerBlocked ? '차단해제' : '차단'}</div>
							</c:when>
							<c:otherwise>
								<div class="notifyReplyAnswer reply-menu-item"  data-targetNum="${vo.reply_num}" data-targetType=2 data-targetTable="community_reply(answer)" data-targetContent="${vo.content}">신고</div>
								<div class="blockReplyAnswer reply-menu-item" data-blockedId="${vo.member_id}" data-parentNum="${vo.parent_num}" data-pageNo="${pageNo}">${vo.userBlocked ? '차단해제' : '차단'}</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>
		</div>
		
		<div class="p-2 ${ vo.managerBlocked ? 'text-secondary' : (vo.userBlocked ? 'text-secondary' : ( vo.show_reply==0 ? '' : 'text-primary text-opacity-50' ))}">
			<c:choose>
				<c:when test="${vo.managerBlocked}">
					관리자에 의해 차단된 댓글입니다.
				</c:when>
				<c:when test="${vo.userBlocked}">
					내가 차단한 사용자의 댓글입니다.
				</c:when>
				<c:otherwise>
					${vo.content}
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</c:forEach>