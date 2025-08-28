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
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/board.css"
	type="text/css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/dist/css/paginate.css"
	type="text/css">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<style>
.product-subject {
	width: 330px;
}

.product-subject img {
	vertical-align: top;
	width: 50px;
	height: 50px;
	border-radius: 5px;
	border: 1px solid #d5d5d5;
}

.product-subject label {
	display: inline-block;
	max-width: 300px;
	padding-left: 5px;
	vertical-align: top;
	white-space: pre-wrap;
}
</style>
</head>
<body>
<header>
	<jsp:include page="/WEB-INF/views/admin/product/layout/header.jsp" />
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/product/layout/left.jsp" />

	<div class="right-panel">
		<div class="page-title">
			<h2><i class="bi bi-bag-check-fill"></i> 판매 상품</h2>
		</div>

		<div class="section p-5">
			<div class="section-body p-5">

				<!-- 필터 영역 -->
				<div class="row mb-2">
					<div class="col-md-8">
						<div class="row">
							<div class="col-md-4 pe-1">
								<select id="changeCategory" class="form-select" onchange="changeList();">
								  <option value="">:: 카테고리 선택 ::</option>
								  <c:forEach var="vo" items="${categoryList}">
								    <option value="${vo.categoryNum}" ${parentNum == vo.categoryNum ? 'selected' : ''}>
								      ${vo.categoryName}
								    </option>
								  </c:forEach>
								</select>
							</div>
							<div class="col-md-4 pe-1">
								<select id="changeSubCategory" class="form-select" onchange="changeSubList();">
								  <option value="">하위 카테고리</option>
								  <c:forEach var="vo" items="${listSubCategory}">
								    <option value="${vo.categoryNum}" ${categoryNum == vo.categoryNum ? 'selected' : ''}>
								      ${vo.categoryName}
								    </option>
								  </c:forEach>
								</select>
							</div>
							<div class="col-md-4 ps-1">
								<select id="changeShowProduct" class="form-select" onchange="changeList();">
									<option value="-1">:: 진열 여부 ::</option>
									<option value="1" ${productShow == 1 ? "selected" : ""}>상품 진열</option>
									<option value="0" ${productShow == 0 ? "selected" : ""}>상품 숨김</option>
								</select>
							</div>
						</div>
					</div>
					<div class="col-md-4 pt-2 text-end page-small-title">
						${dataCount}개 (${page} / ${total_page} 페이지)
					</div>
				</div>

				<!-- 상품 목록 테이블 -->
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
							<th width="120">변경</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="dto" items="${list}">
							<tr valign="middle">
								<td>${dto.productNum}</td>
								<td class="product-subject left">
									<img src="${pageContext.request.contextPath}/uploads/product/${dto.thumbnail}">
									<label>${dto.productName}</label>
								</td>
								<td>${dto.price}</td>
								<td>${dto.totalStock}</td>
								<td>${dto.productShow == 1 ? "표시" : "숨김"}</td>
								<td>S</td>
								<td>${dto.updateDate}</td>
								<td>
									<c:url var="updateUrl" value="/admin/product/update/${dto.productNum}">
									  <!-- 컨트롤러가 받는 파라미터 -->
									  <c:param name="page" value="${page}" />
									  <c:param name="size" value="${size}" />
									  <!-- 화면 상태(필터)도 같이 보존하고 싶으면 추가로 넘겨도 무방 -->
									  <c:param name="parentNum" value="${parentNum}" />
									  <c:param name="categoryNum" value="${categoryNum}" />
									  <c:param name="productShow" value="${productShow}" />
									  <c:param name="schType" value="${schType}" />
									  <c:param name="kwd" value="${kwd}" />
									</c:url>
									<button type="button" class="btn-default btn-sm btn-productStock"
						            data-productnum="${dto.productNum}" data-optioncount="${dto.optionCount}">재고</button>
									<a href="${updateUrl}" class="btn-default btn-sm">수정</a>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

				<c:if test="${empty list}">
				  <div class="text-center py-5 fs-5">등록된 상품이 없습니다.</div>
				</c:if>
				<c:if test="${not empty list}">
				  <div class="page-navigation">
				    ${paging}
				  </div>
				</c:if>

				<!-- 검색 및 등록 -->
				<div class="row mt-3">
					<div class="col-md-3">
						<button type="button" class="btn-default"
							onclick="location.href='${pageContext.request.contextPath}/admin/product/list';">
							<i class="bi bi-arrow-clockwise"></i>
						</button>
					</div>

					<div class="col-md-6 text-center">
						<form name="searchForm" class="form-search">
							<select name="schType">
								<option value="all" ${schType == "all" ? "selected" : ""}>상품명+설명</option>
								<option value="productNum" ${schType == "productNum" ? "selected" : ""}>상품코드</option>
								<option value="productName" ${schType == "productName" ? "selected" : ""}>상품명</option>
								<option value="content" ${schType == "content" ? "selected" : ""}>설명</option>
							</select>
							<input type="text" name="kwd" value="${kwd}">
							<input type="hidden" name="size" value="${size}">
							<input type="hidden" name="parentNum" value="${parentNum}">
							<input type="hidden" name="categoryNum" value="${categoryNum}">
							<input type="hidden" name="productShow" value="${productShow}">
							<button type="button" class="btn-default" onclick="searchList();">
								<i class="bi bi-search"></i>
							</button>
						</form>
					</div>

					<div class="col-md-3 text-end">
						<c:url var="url" value="/admin/product/write" />
						<button type="button" class="btn-accent btn-md" onclick="location.href='${url}';">
							상품등록
						</button>
					</div>
				</div>

			</div>
		</div>
	</div>
</main>

<!-- 재고 관리 대화상자  -->
<div class="modal fade" id="productStockDialogModal" tabindex="-1" aria-labelledby="productStockDialogModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="productStockDialogModalLabel">재고관리</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body pt-1">
				<div class="modal-productStock"></div>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
//엔터로 검색
window.addEventListener('DOMContentLoaded', () => {
  const inputEL = document.querySelector('form input[name=kwd]');
  if (inputEL) {
    inputEL.addEventListener('keydown', function (evt) {
      if (evt.key === 'Enter') {
        evt.preventDefault();
        searchList();
      }
    });
  }
});

function searchList() {
  const f = document.searchForm;
  if (!f.kwd.value.trim()) return;
  listProduct();
}

function listProduct() {
  const f = document.searchForm;
  const formData = new FormData(f);
  const requestParams = new URLSearchParams(formData).toString();
  const url = '${pageContext.request.contextPath}/admin/product/list';
  location.href = url + '?' + requestParams;
}

// 상위 카테고리 변경 시
function changeList() {
  const f = document.searchForm;
  f.parentNum.value = $('#changeCategory').val();
  // 상위 카테고리 변경 시, 하위 카테고리 값을 초기화합니다.
  f.categoryNum.value = "";
  f.productShow.value = $('#changeShowProduct').val();
  listProduct();
}

// 하위 카테고리 변경 시
function changeSubList() {
  const f = document.searchForm;
  f.parentNum.value = $('#changeCategory').val();
  f.categoryNum.value = $('#changeSubCategory').val();
  f.productShow.value = $('#changeShowProduct').val();
  listProduct();
}

// 재고 모달
$(function () {
  // 모달 열기
  $('.btn-productStock').click(function () {
    const productNum = $(this).data('productnum');
    const optionCount = $(this).data('optioncount');
    const url = '${pageContext.request.contextPath}/admin/product/listProductStock?productNum=' + productNum + '&optionCount=' + optionCount;

    $('.modal-productStock').load(url);
    $('#productStockDialogModal').modal('show');
  });

  // 재고 일괄 변경
  $('.modal-productStock').on('click', '.btn-allStockUpdate', function () {
    if (!confirm('재고를 일괄 변경 하시겠습니까 ?')) return false;

    const productNum = $(this).data('productnum');
    const url = '${pageContext.request.contextPath}/admin/product/updateProductStock';
    let formData = 'productNum=' + productNum;

    let ok = true;
    $('.productStcok-list tr').each(function () {
      const $input = $(this).find('input[name=totalStock]');
      const $btn = $(this).find('.btn-stockUpdate');

      if (!/^\d+$/.test($input.val())) {
        alert('재고량은 숫자만 가능합니다.');
        $input.focus();
        ok = false;
        return false;
      }

      const stockNum = $btn.data('stocknum');
      const detailNum = $btn.data('detailnum') || 0;
      const detailNum2 = $btn.data('detailnum2') || 0;
      const totalStock = $input.val().trim();

      formData += '&stockNums=' + stockNum + '&detailNums=' + detailNum + '&detailNums2=' + detailNum2 + '&totalStocks=' + totalStock;
    });

    if (!ok) return false;

    ajaxRequest(url, 'post', formData, 'json', function (data) {
      alert(data.state === 'true' ? '재고가 일괄 변경 되었습니다.' : '재고 일괄 변경 실패');
    });
  });

  // 개별 변경
  $('.modal-productStock').on('click', '.btn-stockUpdate', function () {
    const productNum = $(this).data('productnum');
    const stockNum = $(this).data('stocknum');
    const detailNum = $(this).data('detailnum') || 0;
    const detailNum2 = $(this).data('detailnum2') || 0;
    const totalStock = $(this).closest('tr').find('input[name=totalStock]').val();

    if (!/^\d+$/.test(totalStock)) {
      alert('재고량은 숫자만 가능합니다.');
      $(this).closest('tr').find('input[name=totalStock]').focus();
      return false;
    }

    const url = '${pageContext.request.contextPath}/admin/product/updateProductStock';
    const payload = { productNum, stockNums: stockNum, detailNums: detailNum, detailNums2: detailNum2, totalStocks: totalStock };

    ajaxRequest(url, 'post', payload, 'json', function (data) {
      alert(data.state === 'true' ? '재고가 변경 되었습니다.' : '재고 변경 실패');
    });
  });
});

// 모달 닫히면 목록 새로고침(필터 유지)
const productStockModalEl = document.getElementById('productStockDialogModal');
if (productStockModalEl) {
  productStockModalEl.addEventListener('hidden.bs.modal', function () {
    listProduct();
  });
}


$(function(){
  // 상위 카테고리 변경 시
  $('#changeCategory').on('change', function(){
    const parentNum = $(this).val();
    const subSelect = $('#changeSubCategory');
    subSelect.empty();
    
    // 이전에 선택된 categoryNum 값을 초기화합니다.
    const f = document.searchForm;
    f.categoryNum.value = "";

    if (!parentNum) {
      subSelect.append('<option value="">하위 카테고리</option>');
      changeList();
      return;
    }

    $.ajax({
      url: '${pageContext.request.contextPath}/admin/product/category/sub',
      type: 'get',
      data: { parentNum: parentNum },
      success: function(data) {
        if(data.length === 0) {
          subSelect.append('<option value="">하위 카테고리 없음</option>');
        } else {
          subSelect.append('<option value="">하위 카테고리 선택</option>');
          $.each(data, function(i, item){
            subSelect.append(`<option value="${item.categoryNum}">${item.categoryName}</option>`);
          });
        }
        changeList();
      },
      error: function(xhr) {
        console.log("카테고리 불러오기 실패", xhr.responseText);
      }
    });
  });

  // 하위 카테고리 변경 시
  $('#changeSubCategory').on('change', function(){
    changeSubList();
  });
});
</script>

<footer>
	<jsp:include page="/WEB-INF/views/admin/product/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/product/layout/footerResources.jsp"/>

</body>
</html>