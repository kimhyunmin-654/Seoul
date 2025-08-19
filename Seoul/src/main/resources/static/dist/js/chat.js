(function(window, $) {
  'use strict';

  // 전역 설정 (header.jsp 에서 초기화됨)
  const CTX = (window.CTX !== undefined) ? window.CTX : '';
  const WS_PROTO = (window.WS_PROTO !== undefined) ? window.WS_PROTO : ((location.protocol === 'https:') ? 'wss' : 'ws');
  const CURRENT_MEMBER_ID = (window.CURRENT_MEMBER_ID !== undefined) ? window.CURRENT_MEMBER_ID : null;

  // 상태
  let coWS = null;
  let coRoomId = null;
  let coProductId = null;
  let coOpponentId = null;
  let coOpponentNick = '';
  let coProductName = '';
  const pendingLocalSignatures = new Set();

  // 외부에서 호출 가능한 함수 노출 (header.jsp의 onclick에서 사용)
  window.openChatPanel = openChatPanel;
  window.closeChatPanel = closeChatPanel;
  window.openCenterChat = openCenterChat;
  window.closeCenterChat = closeCenterChat;

  /* -------------------- 사이드 패널(오른쪽 목록) -------------------- */
  function openChatPanel() {
    $('#chatPanel').addClass('open');
    ajaxChatList();
    clearChatBadge();

    // 읽음 처리 요청 (컨트롤러: POST /chat/markAllAsRead)
    $.post(CTX + '/chat/markAllAsRead').always(function(){
      const badge = document.getElementById('chatNotificationBadge');
      if (badge) badge.classList.add('d-none');
    });
  }

  function closeChatPanel() {
    $('#chatPanel').removeClass('open');
  }

  function ajaxChatList() {
    $.ajax({
      url: CTX + '/chat/list',
      type: 'GET',
      dataType: 'html'
    }).done(function(data){
      const $tmp = $('<div>').html(data);
      const content = $tmp.find('#chatRoomList').html();
      $('#chatRoomList').html(content || '');
      if (!content || content.trim() === '') $('.empty-chat').show(); else $('.empty-chat').hide();
    }).fail(function(){
      console.error('채팅 목록 로드 실패');
    });
  }

  /* -------------------- 방 목록에서 방 클릭 시 중앙창 열기 -------------------- */
  $(document).on('click', '#chatRoomList .chat-room-link', function(e){
    e.preventDefault();
    const el = this;
    coRoomId = Number(el.dataset.roomId || 0);
    coProductId = Number(el.dataset.productId || 0);
    coOpponentId = Number(el.dataset.opponentId || 0);
    coOpponentNick = el.dataset.opponentNick || '상대';
    coProductName = (el.dataset.productName || '').trim();

    const headerText = coOpponentNick + (coProductName ? ' - ' + coProductName : '');
    document.getElementById('coOpponent').textContent = headerText;

    openCenterChat();
  });

  /* -------------------- 중앙 채팅 오버레이 -------------------- */
  function openCenterChat(){
    $('#coOpponent').text(coOpponentNick + (coProductName ? ' - ' + coProductName : ''));
    $('#coBackdrop').addClass('show');
    $('#coOverlay').addClass('open compact');
    $('#coMessages').empty();
    $('#coInput').val('').focus();

    // 1) 기존 메시지 불러오기
    $.ajax({
      url: CTX + '/chat/messages',
      data: { room_id: coRoomId },
      dataType: 'html'
    }).done(function(html){
      try {
        const normalized = normalizeServerMessagesHtml(html);
        const $container = $('#coMessages').empty();
        normalized.forEach(node => $container.append(node));
        afterAppendPostProcess();
        scrollBottom();
      } catch(e) {
        console.error('normalize/append 실패', e);
      }
    }).fail(function(){ console.error('채팅 내역 로드 실패'); });

    // 2) WebSocket 연결
    if(coWS){ try { coWS.close(); } catch(e) {} coWS = null; }
    const wsUrl = WS_PROTO + '://' + location.host + CTX + '/ws/chat?roomId=' + coRoomId + '&member_id=' + encodeURIComponent(CURRENT_MEMBER_ID);
    console.log('[coWS] connecting to', wsUrl, 'coRoomId=', coRoomId, 'member=', CURRENT_MEMBER_ID);
    try {
      coWS = new WebSocket(wsUrl);
    } catch (e) {
      console.error('[coWS] new WebSocket failed', e);
      coWS = null;
      return;
    }

    coWS.onopen = function() {
      console.log('[coWS] open');
      if (CURRENT_MEMBER_ID) {
        try { coWS.send(JSON.stringify({ type: 'join', room_id: coRoomId, sender_id: CURRENT_MEMBER_ID })); }
        catch(e){ console.error('[coWS] join send fail', e); }
      }
    };

    coWS.onerror = function(err) { console.error('[coWS] error', err); };
    coWS.onclose = function(ev) { console.warn('[coWS] closed', ev); coWS = null; };

    coWS.onmessage = function(evt) {
      try {
        const msg = JSON.parse(evt.data);
        // 패널이 열려있지 않으면 배지 증가(옵션)
        const panelOpen = $('#chatPanel').hasClass('open');
        if(!panelOpen && msg.receiver_id == CURRENT_MEMBER_ID) incChatBadge(1);

        const signature = makeSignature(msg.sender_id, msg.message, msg.send_time || msg.timestamp);
        if (pendingLocalSignatures.has(signature)) {
          // 로컬에서 이미 에코한 메시지
          pendingLocalSignatures.delete(signature);
          return;
        }

        const who = msg.nickname || (msg.sender_id == CURRENT_MEMBER_ID ? '나' : '상대');
        const avatar = msg.profile_photo || null;
        appendMessage(who, msg.message, msg.sender_id == CURRENT_MEMBER_ID, msg.send_time || msg.timestamp, avatar);
      } catch(e) {
        console.warn('[coWS] onmessage parse error', e);
      }
    };
  }

  function closeCenterChat(){
    $('#coOverlay').removeClass('open compact ultra');
    $('#coBackdrop').removeClass('show');
    if(coWS){ try{ coWS.close(); }catch(e){} coWS = null; }
  }

  /* -------------------- 메시지 전송 처리 -------------------- */
  $(document).on('click', '#coSend', sendCenterMessage);
  $(document).on('keydown', '#coInput', function(e){
    if(e.key === 'Enter' && !e.shiftKey){ e.preventDefault(); sendCenterMessage(); }
  });

  function sendCenterMessage() {
    if (!coWS) {
      console.warn('sendCenterMessage: WebSocket 없음');
      return;
    }
    if (coWS.readyState !== WebSocket.OPEN) {
      console.warn('sendCenterMessage: WS not OPEN');
      return;
    }
    const input = document.getElementById('coInput');
    const msg = (input ? input.value.trim() : '');
    if (!msg) return;

    const payload = {
      type: 'chat',
      room_id: coRoomId,
      product_id: coProductId,
      sender_id: CURRENT_MEMBER_ID,
      receiver_id: coOpponentId,
      message: msg
    };

    const now = Date.now();
    appendMessage('나', msg, true, now);
    const sig = makeSignature(CURRENT_MEMBER_ID, msg, now);
    pendingLocalSignatures.add(sig);

    try {
      coWS.send(JSON.stringify(payload));
    } catch(e) {
      console.error('[coWS] send failed', e);
      pendingLocalSignatures.delete(sig);
    }

    if(input) { input.value = ''; input.focus(); }
  }

  /* -------------------- .btn-open-chat (detail page) 클릭 처리 -> createRoomAjax 호출 -------------------- */
  $(document).on('click', '.btn-open-chat', function(e){
    e.preventDefault();
    const $btn = $(this);

    // 로그인 체크 (client)
    if (typeof CURRENT_MEMBER_ID === 'undefined' || CURRENT_MEMBER_ID === null) {
      window.location.href = CTX + '/member/login';
      return;
    }

    const productId = Number($btn.data('product-id') || 0);
    const sellerId  = Number($btn.data('seller-id') || 0);
    const sellerNick = $btn.data('seller-nick') || '상대';

    if (sellerId === CURRENT_MEMBER_ID) {
      alert('자기 자신과는 채팅할 수 없습니다.');
      return;
    }

    // 중복 클릭 방지
    if ($btn.data('loading')) return;
    $btn.data('loading', true).prop('disabled', true);

    $.ajax({
      url: CTX + '/chat/createRoomAjax',
      method: 'POST',
      data: { product_id: productId, seller_id: sellerId },
      dataType: 'json'
    })
    .done(function(data){
      if(!data) {
        alert('서버 응답이 없습니다.');
        return;
      }
      if (data.success) {
        coRoomId = Number(data.room_id);
        coProductId = Number(data.product_id);
        coOpponentId = Number(data.seller_id);
        coOpponentNick = data.sellerNick || sellerNick;
        openCenterChat();
      } else {
        if (data.error === 'not_logged_in') {
          window.location.href = CTX + '/member/login';
          return;
        }
        alert('채팅방을 열 수 없습니다. (' + (data.error || '서버 오류') + ')');
      }
    })
    .fail(function(jqXHR, textStatus, errorThrown){
      if (jqXHR.status === 401) {
        window.location.href = CTX + '/member/login';
        return;
      }
      console.error('createRoomAjax failed:', textStatus, errorThrown);
      alert('네트워크 오류가 발생했습니다. 잠시 후 다시 시도하세요.');
    })
    .always(function(){
      $btn.data('loading', false).prop('disabled', false);
    });
  });

  /* -------------------- 유틸 함수들 -------------------- */

  function fmtTime(ts) {
    if (!ts) return '';
    let d;
    if (typeof ts === 'number') d = new Date(ts);
    else if (typeof ts === 'string') d = new Date(ts.replace(' ', 'T'));
    else d = new Date(ts);
    if (isNaN(d)) return ('' + ts).substring(11, 16);
    const hh = String(d.getHours()).padStart(2, '0');
    const mm = String(d.getMinutes()).padStart(2, '0');
    return hh + ':' + mm;
  }

  function makeSignature(senderId, message, when) {
    let d;
    if (!when) d = new Date();
    else if (typeof when === 'number') d = new Date(when);
    else if (typeof when === 'string') d = new Date(when.replace(' ', 'T'));
    else d = new Date(when);
    if (isNaN(d)) d = new Date();
    const key = d.getFullYear() + '-' + String(d.getMonth() + 1).padStart(2, '0') + '-' +
                String(d.getDate()).padStart(2, '0') + 'T' +
                String(d.getHours()).padStart(2, '0') + ':' +
                String(d.getMinutes()).padStart(2, '0');
    return `${senderId}|${message}|${key}`;
  }

  function normalizeServerMessagesHtml(html) {
    const tmp = document.createElement('div');
    tmp.innerHTML = html;
    let lines = Array.from(tmp.querySelectorAll('.co-line'));
    if (lines.length === 0) {
      const root = tmp.querySelector('#chatMessages');
      if (root) lines = Array.from(root.children);
      else lines = Array.from(tmp.children);
    }
    const outNodes = [];
    lines.forEach(orig => {
      let isMine = false;
      if (orig.classList.contains('me')) isMine = true;
      if (orig.dataset && orig.dataset.senderId) isMine = String(orig.dataset.senderId) === String(CURRENT_MEMBER_ID);

      const line = document.createElement('div');
      line.className = 'co-line ' + (isMine ? 'me' : 'other');

      if (!isMine) {
        const avatar = orig.querySelector('.avatar') || orig.querySelector('img.avatar');
        const img = document.createElement('img');
        img.className = 'avatar';
        img.alt = 'avatar';
        if (avatar && avatar.getAttribute('src')) img.src = avatar.getAttribute('src');
        else img.src = CTX + '/dist/images/avatar.png';
        line.appendChild(img);
      }

      const bubble = document.createElement('div');
      bubble.className = 'bubble';

      let nickText = '';
      const nickNode = orig.querySelector('.nick') || orig.querySelector('.nickname') || orig.querySelector('.senderNickname');
      if (nickNode) nickText = nickNode.textContent.trim();
      if (!isMine && nickText) {
        const nickDiv = document.createElement('div');
        nickDiv.className = 'nick';
        nickDiv.textContent = nickText;
        bubble.appendChild(nickDiv);
      }

      let messageText = '';
      const textNode = orig.querySelector('.text') || orig.querySelector('.message') || orig.querySelector('.message-text');
      if (textNode) messageText = textNode.textContent;
      else messageText = orig.textContent || '';

      const txtDiv = document.createElement('div');
      txtDiv.className = 'text';
      txtDiv.textContent = (messageText || '').trim();
      bubble.appendChild(txtDiv);

      bubble.style.maxWidth = '58%';
      bubble.style.fontSize = '14px';
      bubble.style.padding = '8px 12px';

      line.appendChild(bubble);

      let timeText = '';
      const timeNode = orig.querySelector('.time') || orig.querySelector('.sent_time') || orig.querySelector('time');
      if (timeNode) timeText = timeNode.textContent.trim();
      if (!timeText && orig.dataset && orig.dataset.sentTime) timeText = fmtTime(orig.dataset.sentTime);
      const timeDiv = document.createElement('div');
      timeDiv.className = 'time';
      timeDiv.textContent = timeText ? timeText : '';
      line.appendChild(timeDiv);

      outNodes.push(line);
    });

    return outNodes;
  }

  // 메시지 DOM 추가 (중앙창)
  function appendMessage(who, text, isMine, when, avatar) {
    maybeAddDaySeparator(when);

    const line = document.createElement('div');
    line.className = 'co-line ' + (isMine ? 'me' : 'other');

    if (!isMine) {
      const avatarImg = document.createElement('img');
      avatarImg.className = 'avatar';
      avatarImg.src = avatar ? (CTX + '/uploads/member/' + avatar) : (CTX + '/dist/images/avatar.png');
      avatarImg.alt = 'avatar';
      avatarImg.onerror = function(){ this.onerror = null; this.src = CTX + '/dist/images/avatar.png'; };
      line.appendChild(avatarImg);
    }

    const bubble = document.createElement('div');
    bubble.className = 'bubble';

    if (!isMine) {
      const nick = document.createElement('div');
      nick.className = 'nick';
      nick.textContent = who || '상대';
      bubble.appendChild(nick);
    }

    const txt = document.createElement('div');
    txt.className = 'text';
    txt.textContent = text || '';
    bubble.appendChild(txt);

    bubble.style.maxWidth = '58%';
    bubble.style.fontSize = '14px';
    bubble.style.padding = '8px 12px';

    line.appendChild(bubble);

    const timeDiv = document.createElement('div');
    timeDiv.className = 'time';
    timeDiv.textContent = when ? fmtTime(when) : '';
    line.appendChild(timeDiv);

    const container = document.getElementById('coMessages');
    if (container) container.appendChild(line);

    afterAppendPostProcess();
    scrollBottom();
  }

  // 날짜 구분선
  var __lastDateKey = null;
  function dayKey(when) {
    if (!when) return null;
    const d = (typeof when === 'number') ? new Date(when) : (typeof when === 'string' ? new Date(when.replace(' ','T')) : new Date(when));
    if (isNaN(d)) return null;
    return d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
  }
  function maybeAddDaySeparator(when){
    const key = dayKey(when);
    if (!key) return;
    if (key === __lastDateKey) return;
    __lastDateKey = key;
    const sep = document.createElement('div');
    sep.className = 'co-day-sep';
    sep.textContent = key;
    const container = document.getElementById('coMessages');
    if (container) container.appendChild(sep);
  }

  function afterAppendPostProcess(){
    const container = document.getElementById('coMessages');
    if(!container) return;
    const children = Array.from(container.children);
    let prevSender = null;
    children.forEach(ch => {
      if(!ch.classList) return;
      if(ch.classList.contains('co-day-sep')) { prevSender = null; return; }
      const isMe = ch.classList.contains('me');
      const sender = isMe ? 'me' : 'other';
      const bubble = ch.querySelector('.bubble');
      if(prevSender === sender){
        ch.classList.add('compact');
        if(bubble){
          bubble.style.maxWidth = '52%';
          bubble.style.padding = '6px 10px';
        }
      } else {
        ch.classList.remove('compact');
        if(bubble){
          bubble.style.maxWidth = '58%';
          bubble.style.padding = '8px 12px';
        }
      }
      prevSender = sender;
    });
  }

  function scrollBottom(){
    const el = document.getElementById('coMessages');
    if(!el) return;
    el.scrollTop = el.scrollHeight;
  }

  /* -------------------- 채팅 배지 제어 -------------------- */
  function setChatBadge(count) {
    const el = document.getElementById('chatNotificationBadge');
    if (!el) return;
    if (!count || count <= 0) { el.classList.add('d-none'); el.textContent = '0'; return; }
    const text = count > 9 ? '9+' : String(count);
    el.textContent = text;
    el.classList.remove('d-none');
    if (count > 9) el.classList.add('overflow'); else el.classList.remove('overflow');
  }
  function incChatBadge(delta = 1) {
    const el = document.getElementById('chatNotificationBadge');
    let curr = el && !el.classList.contains('d-none') ? parseInt(el.textContent) || 0 : 0;
    setChatBadge(curr + delta);
  }
  function clearChatBadge(){ setChatBadge(0); }

  window.setChatBadge = setChatBadge;
  window.incChatBadge = incChatBadge;
  window.clearChatBadge = clearChatBadge;

  if (CURRENT_MEMBER_ID) {
    try {
      const url = WS_PROTO + '://' + location.host + CTX + '/ws/chat?roomId=0&member_id=' + encodeURIComponent(CURRENT_MEMBER_ID);
      const nws = new WebSocket(url);
      nws.onopen = function() {
        try { nws.send(JSON.stringify({ type:'joinNotification', member_id: CURRENT_MEMBER_ID })); } catch(e) {}
      };
      nws.onmessage = function(evt) {
        try {
          const msg = JSON.parse(evt.data);
          if (!msg) return;
          const sender = msg.sender_id ? Number(msg.sender_id) : null;
          const receiver = msg.receiver_id ? Number(msg.receiver_id) : null;
          if (sender && Number(CURRENT_MEMBER_ID) === sender) return;
          if (receiver && Number(CURRENT_MEMBER_ID) === receiver) {
            const panelOpen = $('#chatPanel').hasClass('open');
            if (!panelOpen) incChatBadge(1);
          }
        } catch(e) { console.warn('[NOTIFY] parse failed', e); }
      };
      window.__notificationSocket = nws;
    } catch(e) {
      console.warn('[NOTIFY] init failed', e);
    }
  }

  $(function(){});

})(window, jQuery);


$(function(){
	$(document).on('click', '.btn-chat-delete', function(e) {
		e.preventDefault();
		const $btn = $(this);
		const roomId = $btn.data('room-id');
		if(! roomId) return;
		
		if(! confirm('채팅방을 삭제하시겠습니까? ')) return;
		
		$btn.prop('disabled', true);
		
		$.ajax({
			url: window.CTX + '/chat/deleteroomAjax',
			method: 'POST',
			contentType: 'application/json',
			dataType: 'json',
			data: JSON.stringify(
				{room_id: roomId}
			),
			success: function(res) {
				if (res && res.result === 'success') {
					$btn.closest('.chat-room-item').remove();
				} else {
					alert(res && res.message ? res.message : '삭제 실패했습니다.');
					$btn.prop('disabled', false);
				}
			},
			error: function(xhr, status, err) {
				console.error('delete error', err);
				alert('서버 오류가 발생했습니다.');
				$btn.prop('disabled', false);
			}
		});
	});
});







