<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>서울 한바퀴</title>
<jsp:include page="/WEB-INF/views/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main>
	<!-- Page Title -->
	<div class="page-title">
		<div class="container align-items-center">
			<h1>${region_name} 한바퀴</h1>
			<div class="page-title-underline-accent"></div>
		</div>
	</div>
	
	<!-- Page Content -->
	<div class="section">
		<div class="container">
			<div class="row justify-content-center">
				<div class="col-md-10 board-section my-4 p-5">

					<div class="pb-2">
						<span class="small-title">상세정보</span>
					</div>
									
					<table class="table board-article">
						<thead>
							<tr>
								<td colspan="2" class="text-center">
									${dto.subject}
								</td>
							</tr>
						</thead>

						<tbody>
							<tr>
								<td width="50%">
									작성자 : ${dto.nickname}
								</td>
								<td width="50%" class="text-end">
									작성일 : ${dto.reg_date} | 조회 ${dto.hit_count}
								</td>
							</tr>
							
							<tr>
								<td colspan="2" valign="top" height="200" class="article-content" style="border-bottom: none;">
									${dto.content}
								</td>
							</tr>

							<tr>
								<td colspan="2" class="text-center p-3" style="border-bottom: none;">
									<button type="button" class="btn-default btnSendBoardLike" title="좋아요"><i class="bi ${isUserLiked ? 'bi-heart-fill text-danger' : 'bi-heart'}"></i>&nbsp;&nbsp;<span id="boardLikeCount">${dto.communityLikeCount}</span></button>
								</td>
							</tr>

							<tr>
								<td colspan="2">
									<c:if test="${not empty dto.saveFilename}">
										<p class="border text-secondary my-1 p-2">
											<i class="bi bi-folder2-open"></i>
											<a href="${pageContext.request.contextPath}/bbs/download?region=${region_code}&num=${dto.num}">${dto.originalFilename}</a>
										</p>
									</c:if>
								</td>
							</tr>

							<tr>
								<td colspan="2">
									다음글 : 
									<c:if test="${not empty nextDto}">
										<a href="${pageContext.request.contextPath}/bbs/article?${query}&num=${nextDto.num}">${nextDto.subject}</a>
									</c:if>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									이전글 : 
									<c:if test="${not empty prevDto}">
										<a href="${pageContext.request.contextPath}/bbs/article?${query}&num=${prevDto.num}">${prevDto.subject}</a>
									</c:if>
								</td>
							</tr>
						</tbody>
					</table>

					<div class="row mb-3">
						<div class="col-md-6 align-self-center">
							<c:choose>
								<c:when test="${not empty sessionScope.member and sessionScope.member.member_id == dto.member_id}">
									<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/bbs/update?region=${region_code}&num=${dto.num}&page=${page}';">수정</button>
									<button type="button" class="btn-default" onclick="deleteOk();">삭제</button>
								</c:when>
								<c:when test="${sessionScope.member.userLevel==9}">
									<button type="button" class="btn-default" onclick="deleteOk();">삭제</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="notifyCommunity btn-default" data-targetNum="${dto.num}" data-targetType=1 data-targetTable="community" data-targetContent="${dto.content}">신고</button>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="col-md-6 align-self-center text-end">
							<button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/bbs/list?${query}';">리스트</button>
						</div>
					</div>
					
					<div class="reply-session">
						<div class="reply-form">
							<div class="form-header">
								<span class="small-title">댓글</span><span> - 타인을 비방하거나 개인정보를 유출하는 글의 게시를 삼가해 주세요.</span>
							</div>
							
							<div class="mb-2">
								<textarea class="form-control" name="content"></textarea>
							</div>
							<div class="text-end">
								<button type="button" class="btn-default btn-md btnSendReply">댓글 등록</button>
							</div>
						</div>
						<div id="listReply"></div>
					</div>

				</div>
			</div>
		</div>
	</div>
	
				
	<!-- Reports Modal -->
	<div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				
				<div class="modal-header">
					<h5 class="modal-title" id="reportModalLabel">신고하기</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
				</div>
				
				<form id="reportForm">
					<div class="modal-body">
						
						<input type="hidden" name="target_num" id="target_num">
						<input type="hidden" name="target_type" id="target_type">
						<input type="hidden" name="target_table" id="target_table">
						<input type="hidden" name="target_content" id="target_content">
						 
						<div class="mb-3">
							<label for="reason_code" class="form-label">신고 사유</label>
							<select name="reason_code" id="reason_code" class="form-select" required>
								<option value="">선택하세요</option>
								<option value="1">스팸/광고</option>
								<option value="2">음란물</option>
								<option value="3">욕설/비방/차별적 표현</option>
								<option value="4">개인정보 노출</option>
								<option value="5">불법거래</option>
								<option value="6">기타</option>
							</select>
						</div>
						
						<div class="mb-3">
							<label for="reason_detail" class="form-label">상세설명 (선택)</label>
							<textarea name="reason_detail" id="reason_detail" class="form-control" rows="3" placeholder="상세 내용을 입력하세요."></textarea>
						</div>
					  
					</div>
					
					<div class="modal-footer">
						<button type="submit" class="btn btn-danger">신고</button>
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
					</div>
				</form>
	
			</div>
		</div>
	</div>

</main>

<c:if test="${sessionScope.member.member_id==dto.member_id||sessionScope.member.userLevel==9}">
	<script type="text/javascript">
		function deleteOk() {
			if(confirm('게시글을 삭제하시겠습니까 ? ')) {
				let params = 'num=${dto.num}&${query}';
				let url = '${pageContext.request.contextPath}/bbs/delete?' + params;
				location.href = url;
			}
		}
	</script>
</c:if>

<script type="text/javascript">
// 게시글 공감
$(function() {
	$('button.btnSendBoardLike').click(function() {
		const $i = $(this).find('i');
		let userLiked = $i.hasClass('bi-heart-fill');
		
		let url = '${pageContext.request.contextPath}/bbs/boardLike/${dto.num}';
		let method = userLiked ? 'delete' : 'post';
		let params = null;
		
		const fn = function(data) {
			let state = data.state;
			
			if(state === 'true') {
				if(userLiked) {
					$i.removeClass('bi-heart-fill text-danger').addClass('bi-heart');
				} else {
					$i.removeClass('bi-heart').addClass('bi-heart-fill text-danger');
				}
				
				let count = data.communityLikeCount;
				$('span#boardLikeCount').text(count);
			} else if(state === 'liked') {
				alert('게시글 공감은 한번만 가능합니다.');
			} else {
				alert('게시글 공감 처리 실패 ! ');
			}
			
		}
		
		ajaxRequest(url, method, params, 'json', fn);
	});
});

$(function() {
	listPage(1);
});

function listPage(page) {
	let url = '${pageContext.request.contextPath}/bbs/listReply';
	let params = {num:${dto.num}, pageNo: page};
	let selector = 'div#listReply';
		
	const fn = function(data) {
		$(selector).html(data);
	};
	
	ajaxRequest(url, 'get', params, 'text', fn);
}

// 댓글 등록
$(function() {
	$('button.btnSendReply').click(function(){
		let num = '${dto.num}';
		const $div = $(this).closest('div.reply-form');
		
		let content = $div.find('textarea').val().trim();
		if(! content) {
			$div.find('textarea').focus();
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/bbs/insertReply';
		let params = {num:num, content:content, parent_num:0};
		
		const fn = function(data) {
			$div.find('textarea').val('');
			
			let state = data.state;
			if(state === 'true') {
				listPage(1);
			} else if(state === 'false') {
				alert('댓글을 등록하지 못했습니다.');
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});

// 댓글&답글 메뉴 드롭다운
$(function() {
	$('div#listReply').on('click', '.dropdown-button', function() {
		const $menu = $(this).next('.reply-menu');
		
		$('.reply-menu').not($menu).addClass('d-none');
		$menu.toggleClass('d-none');
	});
	
	$('body').on('click', function(evt) {
		const parent = evt.target.parentNode;
		
		const isMatch = parent.tagName === 'SPAN' && $(parent).hasClass('dropdown-button');		
		
		if(isMatch) {
			return false;
		}
		
		$('div.reply-menu:not(.d-none)').addClass('d-none');
	});
});

// 댓글 삭제
$(function() {
	$('div#listReply').on('click', '.deleteReply', function() {
		if(! confirm('게시물을 삭제하시겠습니까 ? ')) {
			return false;
		}
		
		let replyNum = $(this).attr('data-replyNum');
		let page = $(this).attr('data-pageNo');
		
		let url = '${pageContext.request.contextPath}/bbs/deleteReply';
		let params = {reply_num:replyNum, mode:'reply'};
		
		const fn = function(data) {
			listPage(page);
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});

// 댓글 좋아요/싫어요
$(function() {
	$('div#listReply').on('click', 'button.btnSendReplyLike', function() {
		const $btn = $(this);
		const $td = $btn.parent('td');
		
		let userLiked = $td.attr('data-userLiked');
		
		let replyNum = $btn.attr('data-replyNum');
		let replyLike = $btn.attr('data-replyLike');
		
		// 좋아요 누른 상태 & 싫어요 누름
		if(userLiked === '1' && replyLike === '0') {
			alert('이미 좋아요를 누르셨습니다.');
			return false;
		}
			
		// 싫어요 누른 상태 & 좋아요 누름
		if(userLiked === '0' && replyLike === '1') {
			alert('이미 싫어요를 누르셨습니다.');
			return false;
		}
		
		// 좋아요/싫어요 취소
		if( (userLiked === '1' && replyLike === '1') || (userLiked === '0' && replyLike === '0') ) {
			let url = '${pageContext.request.contextPath}/bbs/deleteReplyLike';
			let params = {reply_num:replyNum};
			
			const fn = function(data) {
				let state = data.state;
				
				if(state === 'true') {
					let likeCount = data.likeCount;
					let disLikeCount = data.disLikeCount;
					
					$td.attr('data-userLiked', '-1');
					
					updateReplyLikeUI($td, '-1', likeCount, disLikeCount);
				} else if(state === 'deleted') {
					alert('이미 처리가 완료된 작업입니다.');
				} else {
					alert('댓글 공감 취소가 실패했습니다.');
				}
			}
			
			ajaxRequest(url, 'post', params, 'json', fn);
		}
		
		// 표시 되어있지 않음
		if(userLiked === '-1') {
			let url = '${pageContext.request.contextPath}/bbs/insertReplyLike';
			let params = {reply_num:replyNum, reply_like:replyLike};
			
			const fn = function(data) {
				let state = data.state;
				if(state === 'true') {
					let likeCount = data.likeCount;
					let disLikeCount = data.disLikeCount;
					
					$td.attr('data-userLiked', replyLike);
					
					updateReplyLikeUI($td, replyLike, likeCount, disLikeCount);
				} else if(state === 'liked') {
					alert('댓글 공감 여부가 등록되어 있습니다.');
				} else {
					alert('댓글 공감 여부 처리가 실패했습니다.');
				}
			};
			
			ajaxRequest(url, 'post', params, 'json', fn);
		}
		
		// UI 처리
		function updateReplyLikeUI($td, replyLike, likeCount, disLikeCount) {
			const $likeBtn = $td.find('button[data-replyLike="1"]');
			const $disLikeBtn = $td.find('button[data-replyLike="0"]');
			
			$likeBtn.find('i').css('color', replyLike === '1' ? 'red' : '');
			$disLikeBtn.find('i').css('color', replyLike === '0' ? 'blue' : '');
			
			$likeBtn.find('span').html(likeCount);
			$disLikeBtn.find('span').html(disLikeCount);
		}
		
	});
});


// 답글 리스트
function listReplyAnswer(parentNum, pageNo) {
	let url = '${pageContext.request.contextPath}/bbs/listReplyAnswer';
	let params = {parent_num:parentNum, pageNo:pageNo};
	let selector = 'div#listReplyAnswer' + parentNum;
	
	const fn = function(data) {
		$(selector).html(data);
	}
	
	ajaxRequest(url, 'get', params, 'text', fn);
}

// 답글 개수
function countReplyAnswer(parentNum) {
	let url = '${pageContext.request.contextPath}/bbs/countReplyAnswer';
	let params = {parent_num:parentNum};
	
	const fn = function(data) {
		let count = data.count;
		let selector = 'span#answerCount' + parentNum;
		$(selector).html(count);
	}
	
	ajaxRequest(url, 'post', params, 'json', fn);
}

// 답글 버튼
$(function() {
	$('div#listReply').on('click', 'button.btnReplyAnswerLayout', function() {
		let pageNo = $(this).attr('data-pageNo') || 1;
		
		const $trReplyAnswer = $(this).closest('tr').next();
		
		let isHidden = $trReplyAnswer.hasClass('d-none');
		let replyNum = $(this).attr('data-replyNum');
		
		if(isHidden) {
			listReplyAnswer(replyNum, pageNo);
			countReplyAnswer(replyNum);
		}
		
		$trReplyAnswer.toggleClass('d-none');
	});
});

// 답글 등록
$(function() {
	$('div#listReply').on('click', 'button.btnSendReplyAnswer', function() {
		let pageNo = $(this).attr('data-pageNo') || 1;
		
		let num = '${dto.num}';
		let replyNum = $(this).attr('data-replyNum');
		const $td = $(this).closest('td');
		
		let content = $td.find('textarea').val().trim();
		if(! content) {
			$td.find('textarea').focus();
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/bbs/insertReply';
		let params = {num:num, content:content, parent_num:replyNum};
		
		const fn = function(data) {
			$td.find('textarea').val('');
			
			let state = data.state;
			if(state === 'true') {
				listReplyAnswer(replyNum, pageNo);
				countReplyAnswer(replyNum);
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});

// 답글 삭제
$(function() {
	$('div#listReply').on('click', '.deleteReplyAnswer', function() {
		let pageNo = $(this).attr('data-pageNo') || 1;
		
		if(! confirm('답글을 삭제하시겠습니까 ? ')) {
			return false;
		}
		
		let replyNum = $(this).attr('data-replyNum');
		let parentNum = $(this).attr('data-parentNum');
		
		let url = '${pageContext.request.contextPath}/bbs/deleteReply';
		let params = {reply_num:replyNum, mode:'answer'};
		
		const fn = function(data) {
			listReplyAnswer(parentNum, pageNo);
			countReplyAnswer(parentNum);
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});

// 숨김(0:표시, 1:숨김)
$(function() {
	// 댓글 숨김
	$('div#listReply').on('click', '.hideReply', function(){
		let $menu = $(this);
		
		let replyNum = $(this).attr('data-replyNum');
		let showReply = $(this).attr('data-showReply');
		let msg = '댓글을 숨김 하시겠습니까 ? ';
		if(showReply === '1') {
			msg = '댓글 숨김을 해제 하시겠습니까 ? ';
		}
		if(! confirm(msg)) {
			return false;
		}
		
		showReply = showReply === '0' ? '1' : '0';
		
		let url = '${pageContext.request.contextPath}/bbs/replyShowHide';
		let params = {reply_num:replyNum, show_reply:showReply};
		
		const fn = function(data) {
			let state = data.state;
			if(state === 'true') {
				let $item = $($menu).closest('tr').next('tr').find('td');
				if(showReply === '0') {
					$item.removeClass('text-primary').removeClass('text-opacity-50');
					$menu.attr('data-showReply', '0');
					$menu.html('숨김');
				} else {
					$item.addClass('text-primary').addClass('text-opacity-50');
					$menu.attr('data-showReply', '1');
					$menu.html('표시');
				}
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
	
	
	// 답글 숨김
	$('div#listReply').on('click', '.hideReplyAnswer', function(){
		let $menu = $(this);
		
		let replyNum = $(this).attr('data-replyNum');
		let showReply = $(this).attr('data-showReply');
		let msg = '답글을 숨김 하시겠습니까 ? ';
		if(showReply === '1') {
			msg = '답글 숨김을 해제 하시겠습니까 ? ';
		}
		if(! confirm(msg)) {
			return false;
		}
		
		showReply = showReply === '0' ? '1' : '0';
		
		let url = '${pageContext.request.contextPath}/bbs/replyShowHide';
		let params = {reply_num:replyNum, show_reply:showReply};
		
		const fn = function(data) {
			let state = data.state;
			if(state === 'true') {
				let $item = $($menu).closest('.row').next('div');
				if(showReply === '0') {
					$item.removeClass('text-primary').removeClass('text-opacity-50');
					$menu.attr('data-showReply', '0');
					$menu.html('숨김');
				} else {
					$item.addClass('text-primary').addClass('text-opacity-50');
					$menu.attr('data-showReply', '1');
					$menu.html('표시');
				}
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});



// 차단
// 사용자 차단 : 내가 차단하면 나에게 해당 회원 글 전부 안보이게 설정
$(function(){
	// 댓글 차단
	$('div#listReply').on('click', '.blockReply', function(){
		let $menu = $(this);
		let blockedId = $menu.attr('data-blockedId');
		let isBlocked = $menu.text().trim() === '차단해제';
		
		let msg = isBlocked ? '해당 사용자의 차단을 해제하시겠습니까 ? ' : '해당 사용자를 차단하시겠습니까 ?';
		if(! confirm(msg)) {
			return false;
		}
		
		let url = isBlocked ? '${pageContext.request.contextPath}/bbs/deleteBlockMember' : '${pageContext.request.contextPath}/bbs/insertBlockMember';
		let params = {blocked_member_id:blockedId};
		
		const fn = function(data) {
			let state = data.state;
			if(state === 'true') {
				let pageNo = $menu.attr('data-pageNo') || 1;
				listPage(pageNo);
			} else {
				alert('댓글 차단 처리 중 오류가 발생했습니다.');
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
	
	
	// 답글 차단
	$('div#listReply').on('click', '.blockReplyAnswer', function(){
		let $menu = $(this);
		let blockedId = $menu.attr('data-blockedId');
		let isBlocked = $menu.text().trim() === '차단해제';
		
		let msg = isBlocked ? '해당 사용자의 차단을 해제하시겠습니까 ? ' : '해당 사용자를 차단하시겠습니까 ?';
		if(! confirm(msg)) {
			return false;
		}
		
		let url = isBlocked ? '${pageContext.request.contextPath}/bbs/deleteBlockMember' : '${pageContext.request.contextPath}/bbs/insertBlockMember';
		let params = {blocked_member_id:blockedId};
		
		const fn = function(data) {
			let state = data.state;
			if(state === 'true') {
				let pageNo = $(this).attr('data-pageNo') || 1;
				let parentNum = $(this).attr('data-parentNum');
				listPage(pageNo);
				
				listReplyAnswer(parentNum, pageNo);
			} else {
				alert('답글 차단 처리 중 오류가 발생했습니다.');
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});


// 관리자 차단 : 다른 회원에게 안보이게 설정
$(function(){
	// 댓글 차단
	$('div#listReply').on('click', '.blockManagerReply', function(){
		let $menu = $(this);
		let replyNum = $menu.attr('data-replyNum');
		let isBlocked = $menu.text().trim() === '차단해제';
		
		let msg = isBlocked ? '해당 댓글 차단을 해제하시겠습니까 ? ' : '해당 댓글을 차단하시겠습니까 ?';
		let block = isBlocked ? 0 : 1;
		if(! confirm(msg)) {
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/bbs/updateReplyBlockByManager';
		let params = {block:block, reply_num:replyNum};
		
		const fn = function(data) {
			let state = data.state;
			if(state === 'true') {
				let pageNo = $menu.attr('data-pageNo') || 1;
				listPage(pageNo);
			} else if(state === 'access-denied') {
				alert('관리자만 가능한 작업입니다.');
			} else {
				alert('댓글 차단 처리 중 오류가 발생했습니다.');
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
	
	// 답글 차단
	$('div#listReply').on('click', '.blockManagerReplyAnswer', function(){
		let $menu = $(this);
		let replyNum = $menu.attr('data-replyNum');
		let isBlocked = $menu.text().trim() === '차단해제';
		
		let msg = isBlocked ? '해당 답글 차단을 해제하시겠습니까 ? ' : '해당 답글을 차단하시겠습니까 ?';
		let block = isBlocked ? 0 : 1;
		if(! confirm(msg)) {
			return false;
		}
		
		let url = '${pageContext.request.contextPath}/bbs/updateReplyBlockByManager';
		let params = {block:block, reply_num:replyNum};
		
		const fn = function(data) {
			let state = data.state;
			if(state === 'true') {
				let pageNo = $menu.attr('data-pageNo') || 1;
				let parentNum = $(this).attr('data-parentNum');
				
				listPage(pageNo);
				
				listReplyAnswer(parentNum, pageNo);
			} else if(state === 'access-denied') {
				alert('관리자만 가능한 작업입니다.');
			} else {
				alert('답글 차단 처리 중 오류가 발생했습니다.');
			}
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
});


// 신고
$(function(){
	const reportModal = new bootstrap.Modal(document.getElementById('reportModal'));
	
	// 게시판, 댓글, 답글 -> 다른 회원 글일 때 신고 가능(관리자 제외)
	$('div.board-section').on('click', '.notifyCommunity, .notifyReply, .notifyReplyAnswer', function(){
		let $menu = $(this);
		
		// 신고 대상 댓글 정보
		let targetNum = $menu.attr('data-targetNum');
		let targetType = $menu.attr('data-targetType');
		let targetTable = $menu.attr('data-targetTable');
		let targetContent = $menu.attr('data-targetContent');
		
		$('#target_num').val(targetNum);
		$('#target_type').val(targetType);
		$('#target_table').val(targetTable);
		$('#target_content').val(targetContent);
		
		$('#reason_code').val('');
		reportModal.show();
	});
	
	$('#reportForm').submit(function(e) {
		e.preventDefault();
		
		let url = '${pageContext.request.contextPath}/bbs/insertCommunityReports';
		let params = $(this).serialize();
		
		const fn = function(data) {
			let state = data.state;
			if(state === 'true') {
				alert('신고가 접수되었습니다.');
			} else {
				alert('신고가 접수 처리 중 오류가 발생했습니다.');
			}
			
			reportModal.hide();
		};
		
		ajaxRequest(url, 'post', params, 'json', fn);
	});
	
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>