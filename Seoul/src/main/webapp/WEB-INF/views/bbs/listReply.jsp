<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="reply-info">
	<span class="reply-count">댓글 ${replyCount}개</span>
	<span>[목록, ${pageNo}/${total_page} 페이지]</span>
</div>

<table class="table table-borderless">
	<c:forEach var="vo" items="${listReply}">
		<tr class="border table-light">
			<td width="50%">
				<div class="row reply-writer">
					<div class="col-lg-1">
						<img src="${pageContext.request.contextPath}/dist/images/person.png" class="avatar-icon">
					</div>
					<div class="col-auto ms-1 align-self-center">
						<div class="name">${vo.nickname}</div>
						<div class="date">${vo.reg_date}</div>
					</div>
				</div>				
			</td>
			<td width="50%" align="right" valign="middle">
				<div class="reply-dropdown">
					<span class="dropdown-button"><i class="bi bi-three-dots-vertical"></i></span>
					<div class="reply-menu d-none">
						<c:choose>
							<c:when test="${sessionScope.member.member_id == vo.member_id}">
								<div class="hideReply reply-menu-item" data-replyNum="${vo.reply_num}" data-showReply="${vo.show_reply}">${vo.show_reply==0 ? "숨김":"표시"}</div>
								<div class="deleteReply reply-menu-item" data-replyNum="${vo.reply_num}" data-pageNo="${pageNo}">삭제</div>
							</c:when>
							<c:when test="${sessionScope.member.userLevel == 9}">
								<div class="deleteReply reply-menu-item" data-replyNum="${vo.reply_num}" data-pageNo="${pageNo}">삭제</div>
								<div class="blockManagerReply reply-menu-item" data-replyNum="${vo.reply_num}" data-pageNo="${pageNo}">${vo.managerBlocked ? '차단해제' : '차단'}</div>
							</c:when>
							<c:otherwise>
								<div class="notifyReply reply-menu-item" data-targetNum="${vo.reply_num}" data-targetTitle="동네한바퀴 댓글" data-targetTable="community_reply" data-targetType="reply">신고</div>
								<div class="blockReply reply-menu-item" data-blockedId="${vo.member_id}" data-pageNo="${pageNo}">${vo.userBlocked ? '차단해제' : '차단'}</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="2" valign="top" class=" ${ vo.managerBlocked ? 'text-secondary' : (vo.userBlocked ? 'text-secondary' : ( vo.show_reply==0 ? '' : 'text-primary text-opacity-50' ))}">
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
			</td>
		</tr>

		<tr>
			<td>
				<button type="button" class="btn-default btnReplyAnswerLayout" data-replyNum="${vo.reply_num}" data-pageNo="${pageNo}">답글 <span id="answerCount${vo.reply_num}">${vo.answerCount}</span></button>
			</td>
			<td align="right" data-userLiked="${vo.userReplyLiked}">
				<button type="button" class="btn-default btnSendReplyLike" data-replyNum="${vo.reply_num}" data-replyLike="1" title="좋아요" ><i class="bi bi-hand-thumbs-up" style="${vo.userReplyLiked == 1 ? 'color:red;':''}"></i> <span>${vo.likeCount}</span></button>
				<button type="button" class="btn-default btnSendReplyLike" data-replyNum="${vo.reply_num}" data-replyLike="0" title="싫어요" ><i class="bi bi-hand-thumbs-down" style="${vo.userReplyLiked == 0 ? 'color:blue;':''}"></i> <span>${vo.disLikeCount}</span></button>	        
			</td>
		</tr>
	
		<tr class="reply-answer d-none">
			<td colspan="2">
				<div class="border rounded">
					<div id="listReplyAnswer${vo.reply_num}" class="answer-list">
						
					</div>
					<div class="p-2">
						<textarea class="form-control"></textarea>
					</div>
					<div class="text-end pe-2 pb-1">
						<button type="button" class="btn-default btn-md btnSendReplyAnswer" data-replyNum="${vo.reply_num}" data-pageNo="${pageNo}">답글 등록</button>
					</div>
				</div>
			</td>
		</tr>
	</c:forEach>
</table>

<div class="page-navigation">
	${paging}
</div>