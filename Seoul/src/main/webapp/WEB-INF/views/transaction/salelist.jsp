<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>판매내역</title>
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/salelist.css" type="text/css">

</head>
<body>

<header>
  <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="wrap">
  <div class="mypage-row">
    <aside class="left-column">
      <jsp:include page="/WEB-INF/views/layout/leftmypage.jsp"/>
    </aside>

    <section class="content-column">
      <div class="section">
        <div class="container" data-aos="fade-up" data-aos-delay="100">
          <div class="row justify-content-center">
            <div class="col-md-12 board-section my-4 p-4">

              <div class="row py-1 mb-3 align-items-center">
                <div class="col-md-8">
                  <div class="d-flex align-items-center flex-wrap gap-2">
                    <span class="small-title">나의 판매내역</span>
                    <span class="dataCount">${dataCount}개 (${page}/${total_page} 페이지)</span>
                  </div>
                </div>
                <div class="col-md-4 text-end">
                  <button type="button" class="btn btn-sm btn-light" onclick="location.href='${pageContext.request.contextPath}/mypage/salelist'">새로고침</button>
                </div>
              </div>

              <form name="listForm" method="post">
                <table class="table table-hover board-list" style="width:100%; border-collapse:collapse;">
                    <colgroup>
					    <col style="width:8%;">   
					    <col style="width:14%;"> 
					    <col style="width:50%;">  
					    <col style="width:12%;">  
					    <col style="width:16%;">  
				  	</colgroup>
                  

				  <thead>
				    <tr>
				      <th class="num">번호</th>
				      <th class="product-thumb">썸네일</th>
				      <th class="subject">상품명</th>
				      <th class="status">상태</th>
				      <th class="date">등록일</th>
				    </tr>
				  </thead>

                  <tbody>
                    <c:if test="${empty list}">
                      <tr>
                        <td colspan="5" class="no-data">판매한 상품이 없습니다.</td>
                      </tr>
                    </c:if>

                    <c:if test="${not empty list}">
                      <c:forEach var="p" items="${list}" varStatus="status">
                        <tr data-product-row="${p.product_id}">
                         <td class="align-middle num">
					  	    <span class="index-chip">${dataCount - (page - 1) * size - status.index}</span>
					     </td>

                          <td class="align-middle">
                            <div class="product-thumb">
                              <c:choose>
                                <c:when test="${not empty p.thumbnail}">
                                  <img src="${pageContext.request.contextPath}/uploads/product/${p.thumbnail}" alt="${p.product_name}"
                                       onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/dist/images/no-image.png'"/>
                                </c:when>
                                <c:otherwise>
                                  <img src="${pageContext.request.contextPath}/dist/images/no-image.png" alt="no image"/>
                                </c:otherwise>
                              </c:choose>
                            </div>
                          </td>

                          <td class="subject align-middle">
                            <div class="text-wrap">
                              <a href="${articleUrl}&product_id=${p.product_id}" style="font-weight:700; color:#111; text-decoration:none;">
                                <c:out value="${p.product_name}"/>
                              </a>
                            </div>
                          </td>

						<td class="align-middle status-cell" data-product-id="${p.product_id}" data-member-id="${p.member_id}">
						  <span class="status-text">${p.status}</span>
						
						  <c:choose>
						    <c:when test="${p.status == '판매중'}">
						      <span class="status-actions">
						        <button type="button" class="btn btn-sm btn-outline-success btn-small btn-complete"
						                data-product-id="${p.product_id}" title="구매자 선택하여 판매완료">판매완료</button>
						        <button type="button" class="btn btn-sm btn-outline-secondary btn-small btn-status-edit"
						                data-product-id="${p.product_id}" data-current-status="${p.status}">수정</button>
						      </span>
						    </c:when>
						
						    <c:when test="${p.status == '판매완료'}">
						      <span class="badge">판매완료</span>
						    </c:when>
						
						    <c:otherwise>
						      <span class="status-actions">
						        <button type="button" class="btn btn-sm btn-outline-secondary btn-small btn-status-edit"
						                data-product-id="${p.product_id}" data-current-status="${p.status}">수정</button>
						      </span>
						    </c:otherwise>
						  </c:choose>
						</td>
							

                          <td class="align-middle date"><c:out value="${p.reg_date}"/></td>
                        </tr>
                      </c:forEach>
                    </c:if>
                  </tbody>
                </table>
              </form>

              <div class="page-navigation text-center my-4">
                <c:out value="${dataCount == 0 ? '판매한 상품이 없습니다.' : paging}" escapeXml="false"/>
              </div>

            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</main>

<div id="buyerModalBackdrop" class="modal-backdrop" aria-hidden="true">
  <div class="modal-panel" role="dialog" aria-modal="true" aria-labelledby="buyerModalTitle">
    <h3 id="buyerModalTitle">구매자 선택</h3>
    <p id="buyerModalInfo" style="margin:0.25rem 0 8px 0; color:#555;">구매자를 선택하면 거래가 확정됩니다.</p>

    <div id="buyerList" class="modal-list">
    </div>

    <div style="text-align:right; margin-top:12px;">
      <button id="buyerModalCancel" type="button" class="btn btn-sm btn-light btn-small">취소</button>
      <button id="buyerModalConfirm" type="button" class="btn btn-sm btn-primary btn-small">확정</button>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
$(function() {
  const ctx = '${pageContext.request.contextPath}';
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

});
</script>

</body>
</html>













