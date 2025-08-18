$(function() {
	$(document).on('click', '.btn-open-chat', function(e) {
		e.preventDefault();
		const $btn = $(this);
		
		// 로그인 체크
		if(typeof CURRENT_MEMBER_ID === "undefined" || CURRENT_MEMBER_ID === null) {
			window.location.href = CTX + "/member/login";
			return;
		}
		
		const productId = Number($btn.data('product-id'));
		const sellerId  = Number($btn.data('seller-id'));
		const sellerNick = $btn.data('seller-nick') || '상대';
		
		// 자기 자신 차단
		if(sellerId === CURRENT_MEMBER_ID) {
			alert('자기 자신과는 채팅할 수 없습니다.');
			return;
		}
		
		// 중복 클릭 방지
		if($btn.data('loading')) return;
		$btn.data('loading', true).prop('disabled', true);
		
		$.ajax({
			url: ctx + '/chat/createRoomAjax',
			method: 'POST',
			data: { product_id: productId, seller_id: sellerId},
			dataType: 'json'
		})
		.done(function(data){
			if(!data) {
				alert("서버 응답이 없습니다.");
				return;
			}
			
			if(data.success) {
				coRoomId = Number(data.room_id);
				coProductId = Number(data.product_id);
				coOpponentId = Number(data.seller_id);$
				coOpponentNick = data.sellerNick || sellerNick;
				
				openCenterChat();
			} else {
				if(data.error === 'not_logged_in') {
					window.location.href = ctx + 'member/login';
					return;
				}
				alert('채팅방을 열 수 없습니다. (' + (data.error || '서버 오류') + ')');
			}
		})
		.fail(function(jqXHR, textStatus, errorThrown) {
			if(jqXHR.status === 401) {
				window.location.href = CTX + '/member/login';
				return;
			}
			console.error('createRoomAjax failed:', textStatus, errorThrown);
			alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도하세요.');
		})
		.always(function() {
			$btn.data('loading', false).prop('disabled', false);
		});
	});
});