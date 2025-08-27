$(function() {
  const $modal = $('#buyerModalBackdrop');
  const $list = $('#buyerList');
  let currentProductId = null;

  function openModal(productId) {
    currentProductId = productId;
    $list.empty().append('<div class="modal-empty">로딩 중...</div>');
    $modal.css('display','flex');

    // 구매자 후보 요청
    $.getJSON(ctx + '/transaction/buyers', { product_id: productId })
      .done(function(res) {
        if (!res || !res.success) {
          $list.html('<div class="modal-empty">구매자 목록을 불러오지 못했습니다.<br/>' + (res && res.message ? res.message : '') + '</div>');
          return;
        }
        const buyers = res.buyers || [];
        if (buyers.length === 0) {
          $list.html('<div class="modal-empty">아직 채팅한 구매자가 없습니다.</div>');
          return;
        }

        // 목록 렌더링 (라디오로 선택)
        const $ul = $('<div></div>');
        buyers.forEach(function(b, idx) {
          const idRadio = 'buyer_radio_' + idx;
          const $row = $('<div style="padding:8px 6px; border-bottom:1px solid #f1f1f1;"></div>');
          const $label = $('<label style="display:flex; gap:10px; align-items:center; cursor:pointer;"></label>');
          const $radio = $('<input type="radio" name="buyer_select">')
                           .val(JSON.stringify({ room_id: b.room_id, buyer_id: b.buyer_id }))
                           .attr('id', idRadio);
          $label.append($radio);
          $label.append($('<strong style="margin-right:6px;"></strong>').text(b.nickname || ('user' + b.buyer_id)));
          $row.append($label);
          $ul.append($row);
        });
        $list.empty().append($ul);
      })
      .fail(function() {
        $list.html('<div class="modal-empty">서버 오류로 구매자 목록을 불러올 수 없습니다.</div>');
      });
  }

  function closeModal() {
    $modal.hide();
    $list.empty();
    currentProductId = null;
  }

  // 버튼 바인딩
  $(document).on('click', '.btn-complete', function() {
    const productId = $(this).data('product-id');
    if (!productId) {
      console.warn('product-id missing on button');
      return;
    }
    openModal(productId);
  });
  $('#buyerModalCancel').on('click', closeModal);

  // 확정 클릭
  $('#buyerModalConfirm').on('click', function() {
    if (!currentProductId) return alert('상품 정보가 없습니다.');

    const sel = $list.find('input[name="buyer_select"]:checked').val();
    if (!sel) return alert('구매자를 선택하세요.');

    let selobj;
    try { selobj = JSON.parse(sel); } catch(e) { return alert('선택값 오류'); }

    const product_id = currentProductId;
    const room_id = selobj.room_id;
    const buyer_id = selobj.buyer_id;

    const $btn = $(this);
    $btn.prop('disabled', true).text('확정 중...');

    $.ajax({
      url: ctx + '/transaction/completeSale',  
      method: 'POST',
      data: {
        product_id: product_id,
        room_id: room_id,
        buyer_id: buyer_id
      },
      dataType: 'json'
    }).done(function(res) {
      if (res && res.success) {
        const $row = $('tr[data-product-row="' + product_id + '"]');
        $row.find('.status-text').text('판매완료');
        $row.find('.status-actions').remove();
        closeModal();
        alert('거래가 확정되었습니다.');
      } else {
        alert('거래 확정 실패: ' + (res && res.message ? res.message : '서버 오류'));
      }
    }).fail(function(xhr) {
      console.error('completeSale error', xhr.responseText);
      alert('서버 오류가 발생했습니다.');
    }).always(function() {
      $btn.prop('disabled', false).text('확정');
    });
  });

  const STATUS_OPTIONS = ['판매중', '예약중'];

  function createSelect(current) {
    const $sel = $('<select>').addClass('form-select form-select-sm')
                             .css({display:'inline-block', width:'120px'});
    STATUS_OPTIONS.forEach(function(s) {
      const $opt = $('<option>').val(s).text(s);
      if (s === current) $opt.prop('selected', true);
      $sel.append($opt);
    });
    return $sel;
  }

  $(document).on('click', '.btn-status-edit', function(e) {
    const $btn = $(this);
    const productId = $btn.data('product-id');
    const currentStatus = $btn.data('current-status');
    const $cell = $btn.closest('.status-cell');

    if (!productId) { console.warn('product_id missing'); return; }
    if ($cell.data('editing') === true) return;
    $cell.data('editing', true);

    const $textSpan = $cell.find('.status-text');
    $textSpan.hide();
    $btn.hide();

    const $sel = createSelect(currentStatus);
    const $saveBtn = $('<button type="button" class="btn btn-sm btn-primary btn-small">저장</button>').css('margin-left','8px');
    const $cancelBtn = $('<button type="button" class="btn btn-sm btn-secondary btn-small">취소</button>').css('margin-left','6px');

    $cell.append($sel).append($saveBtn).append($cancelBtn);

    $saveBtn.on('click', function() {
      const newStatus = $sel.val();
      if (newStatus === '판매완료') {
        alert('판매완료는 구매자 선택 후 거래 확정 기능을 사용하세요.');
        return;
      }
      $saveBtn.prop('disabled', true).text('저장중...');
      $cancelBtn.prop('disabled', true);

      $.ajax({
        url: ctx + '/transaction/updateStatus',
        method: 'POST',
        data: {
          product_id: productId,
          status: newStatus
        },
        dataType: 'json'
      }).done(function(resp) {
        if (resp && resp.success) {
          $textSpan.text(newStatus);
        } else {
          alert('상태 변경 실패: ' + (resp && resp.message ? resp.message : '서버 오류'));
        }
      }).fail(function(xhr) {
        console.error('updateStatus error', xhr.responseText);
        alert('상태 변경 중 오류가 발생했습니다.');
      }).always(function() {
        cleanup();
      });
    });

    $cancelBtn.on('click', function() { cleanup(); });

    function cleanup() {
      $sel.remove();
      $saveBtn.remove();
      $cancelBtn.remove();
      $textSpan.show();
      $btn.show();
      $cell.removeData('editing');
    }
  });

$(document).on('click', '.btn-delete', function () {
    const productId = $(this).data('product-id');
    if (!productId) return;

    if (!confirm('해당 상품을 삭제하시겠습니까? 삭제 시 복구할 수 없습니다.')) {
      return;
    }

    const $btn = $(this);
    $btn.prop('disabled', true).text('삭제 중...');

    $.ajax({
      url: ctx + '/transaction/deleteProduct',
      method: 'POST',
      data: { product_id: productId },
      dataType: 'json'
    }).done(function (res) {
      if (res && res.success) {
        // 가장 간단하고 안전하게 새로고침하여 페이징/카운트/순번 갱신
        location.reload();
      } else {
        alert('삭제 실패: ' + (res && res.message ? res.message : '서버 오류'));
        $btn.prop('disabled', false).text('삭제');
      }
    }).fail(function (xhr) {
      console.error('deleteProduct error', xhr.responseText);
      alert('서버 오류가 발생했습니다.');
      $btn.prop('disabled', false).text('삭제');
    });
  });
  
});