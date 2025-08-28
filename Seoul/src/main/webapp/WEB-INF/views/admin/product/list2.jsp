<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>서울 한바퀴</title>

<jsp:include page="/WEB-INF/views/admin/product/layout/headerResources.jsp" />
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<!-- =========================
     카드 그리드 전용 CSS (텍스트가 이미지와 겹치지 않게 수정)
     ========================= -->
<style>
/* 컨테이너 중앙 정렬, 최대 너비 */
.main-container { max-width: 1200px; margin: 0 auto; padding: 28px 16px; }

/* 카드 그리드 */
.cards-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 18px;
  align-items: start;
  padding: 8px;
  margin: 18px 0;
}

/* 카드 비주얼 */
.card-item {
  background: #0f1315;
  border-radius: 10px;
  overflow: hidden;
  display:flex;
  flex-direction:column;
  min-height: 360px;
  transition: transform .12s ease, box-shadow .12s ease;
  box-shadow: 0 6px 16px rgba(0,0,0,0.20);
  position: relative;
}
.card-item:hover { transform: translateY(-6px); box-shadow: 0 18px 36px rgba(0,0,0,0.25); }

/* 이미지 영역: 일정 비율 유지 */
.card-thumb {
  width:100%;
  height: auto;
  display:block;
  object-fit: cover;
  aspect-ratio: 4 / 3;
  background: linear-gradient(180deg,#0b0b0c,#121212);
}

/* 이미지 오류(대체) 시 표시 스타일 (외부 파일 요청 없음) */
.card-thumb.default {
  object-fit: contain;
  background: linear-gradient(180deg,#121212,#0f0f10);
}

/* --- 여기서 오버레이 제거: 텍스트가 이미지 아래에 위치하도록 함 --- */
/* 이전에 사용하던 ::after, margin-top 음수는 삭제/무시 */

/* body (타이틀/가격/메타) - 이미지 아래에 위치하도록 수정 */
.card-body {
  padding: 12px 14px;
  display:flex;
  flex-direction:column;
  gap:8px;
  flex:1 1 auto;
  position: relative;
  z-index: 2;
  margin-top: 0; /* 음수 제거 */
  background: transparent; /* 이미지와 자연스럽게 분리 */
  border-bottom-left-radius: 10px;
  border-bottom-right-radius: 10px;
}

/* 제목: 2줄 고정, 말줄임 */
.card-title {
  font-size:0.95rem;
  font-weight:800;
  color:#ffffff;
  line-height:1.25;
  display:-webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow:hidden;
  text-overflow:ellipsis;
  margin: 0;
}

/* 가격/메타 스타일 */
.card-price { font-size:1.05rem; font-weight:800; color:#ffd; }
.card-meta { color:#bdbdbd; font-size:0.82rem; display:flex; justify-content:space-between; align-items:center; gap:8px; }

/* footer */
.card-footer {
  padding:10px 14px;
  border-top: 1px solid rgba(255,255,255,0.03);
  background: linear-gradient(180deg, rgba(255,255,255,0.01), rgba(255,255,255,0.015));
  display:flex; justify-content:space-between; align-items:center;
  font-size:0.78rem; color:#bdbdbd;
  z-index:2;
}

@media (max-width:768px) {
  .card-item { min-height: 320px; }
}
@media (max-width:420px) {
  .cards-grid { grid-template-columns: repeat(1,1fr); gap:12px; }
  .card-thumb { height: 180px; }
  .card-item { min-height:300px; }
}

table.board-list { display:none !important; }

.card-title {
  color: #ffffff !important;
  font-weight: 800;
  text-shadow: 0 2px 8px rgba(0,0,0,0.7);
  display: block;
  line-height: 1.2;
  margin-bottom: 6px;
}
</style>
</head>
<body>
<header>
  <jsp:include page="/WEB-INF/views/layout/header.jsp"/>
</header>

<main class="main-container">
  <div class="right-panel">
    <div class="page-title">
      <h2><i class="bi bi-bag-check-fill"></i> 판매 상품</h2>
    </div>

    <div class="section p-5">
      <div class="section-body p-5">

        <table class="table table-hover board-list">
          <thead>
            <tr>
              <th width="130">상품코드</th>
              <th>상품명</th>
              <th width="100">가격</th>
              <th width="60">재고</th>
              <th width="60">진열</th>
              <th width="60">상태</th>
              <th width="90">수정일</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="dto" items="${list}">
              <tr valign="middle">
                <td>${dto.productNum}</td>
                <td class="product-subject left">
                  <img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}" alt="thumb">
                  <label>${dto.productName}</label>
                </td>
                <td>${dto.price}</td>
                <td>${dto.totalStock}</td>
                <td>${dto.productShow == 1 ? "표시" : "숨김"}</td>
                <td>S</td>
                <td>${dto.updateDate}</td>
                <td>
                  <c:url var="updateUrl" value="/admin/product/update/${dto.productNum}">
                    <c:param name="page" value="${page}" />
                    <c:param name="size" value="${size}" />
                    <c:param name="parentNum" value="${parentNum}" />
                    <c:param name="categoryNum" value="${categoryNum}" />
                    <c:param name="productShow" value="${productShow}" />
                    <c:param name="schType" value="${schType}" />
                    <c:param name="kwd" value="${kwd}" />
                  </c:url>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>

        <c:if test="${empty list}">
          <div class="text-center py-5 fs-5">등록된 상품이 없습니다.</div>
        </c:if>



      </div>
    </div>
  </div>
</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const table = document.querySelector('table.board-list');
  if (!table) return;
  const tbody = table.querySelector('tbody');
  if (!tbody) return;

  const defaultImg = 'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==';

  const rows = Array.from(tbody.querySelectorAll('tr'));
  const grid = document.createElement('div');
  grid.className = 'cards-grid';

  const nf = new Intl.NumberFormat('ko-KR');

  rows.forEach(tr => {
    try {
      const tds = tr.querySelectorAll('td');

      const productNum = (tds[0] ? tds[0].textContent.trim() : '');
      const subjectTd = tds[1] || null;
      let thumbnailSrc = '';
      let productName = '';
      if (subjectTd) {
        const img = subjectTd.querySelector('img');
        if (img) thumbnailSrc = img.getAttribute('src') || '';
        const label = subjectTd.querySelector('label');
        productName = label ? label.textContent.trim() : subjectTd.textContent.trim();
      }
      const rawPrice = (tds[2] ? tds[2].textContent.trim() : '');
      const priceNum = parseInt((rawPrice || '').replace(/[^\d]/g,''), 10);
      const priceText = Number.isFinite(priceNum) ? nf.format(priceNum) + '원' : (rawPrice || '');

      const stockText = (tds[3] ? tds[3].textContent.trim() : '');
      const showText = (tds[4] ? tds[4].textContent.trim() : '');
      const updateDate = (tds[6] ? tds[6].textContent.trim() : (tds[5] ? tds[5].textContent.trim() : ''));

      const card = document.createElement('article');
      card.className = 'card-item';

      const imgEl = document.createElement('img');
      imgEl.className = 'card-thumb';
      imgEl.alt = productName || '상품 이미지';
      imgEl.loading = 'lazy';
      if (thumbnailSrc && thumbnailSrc.trim() !== '') {
        imgEl.src = thumbnailSrc;
      } else {
        imgEl.src = defaultImg;
        imgEl.classList.add('default');
      }
      imgEl.onerror = function() {
        if (imgEl.src !== defaultImg) {
          imgEl.src = defaultImg;
        }
        imgEl.classList.add('default');
        imgEl.style.objectFit = 'contain';
      };

      const body = document.createElement('div');
      body.className = 'card-body';

      const titleEl = document.createElement('h3');
      titleEl.className = 'card-title';
      titleEl.textContent = productName || '상품명 없음';

      const priceEl = document.createElement('div');
      priceEl.className = 'card-price';
      priceEl.textContent = priceText || '가격 없음';

      const metaEl = document.createElement('div');
      metaEl.className = 'card-meta';
      const leftMeta = document.createElement('div');
      leftMeta.textContent = stockText ? ('재고: ' + stockText) : '';
      const rightMeta = document.createElement('div');
      rightMeta.textContent = showText || '';
      metaEl.appendChild(leftMeta);
      metaEl.appendChild(rightMeta);

      body.appendChild(titleEl);
      body.appendChild(priceEl);
      body.appendChild(metaEl);

      const footer = document.createElement('div');
      footer.className = 'card-footer';
      const leftFooter = document.createElement('div');
      leftFooter.textContent = updateDate || '';
      const rightFooter = document.createElement('div');
      rightFooter.textContent = productNum ? ('상품번호 ' + productNum) : '';
      footer.appendChild(leftFooter);
      footer.appendChild(rightFooter);

      let linkHref = '';
      const linkTd = tr.querySelector('td a[href]');
      if (linkTd) linkHref = linkTd.getAttribute('href');

      if (linkHref) {
        const aWrap = document.createElement('a');
        aWrap.href = linkHref;
        aWrap.style.color = 'inherit';
        aWrap.style.textDecoration = 'none';
        aWrap.appendChild(imgEl);
        aWrap.appendChild(body);
        card.appendChild(aWrap);
        card.appendChild(footer);
      } else {
        card.appendChild(imgEl);
        card.appendChild(body);
        card.appendChild(footer);
      }

      grid.appendChild(card);
    } catch(e) {
      console.error('card convert error:', e);
    }
  });

  table.parentNode.replaceChild(grid, table);

  const paging = document.querySelector('.page-navigation');
  if (paging) grid.parentNode.insertBefore(paging, grid.nextSibling);
});
</script>
</body>
</html>
