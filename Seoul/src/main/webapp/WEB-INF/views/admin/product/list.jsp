<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>hShop</title>
<jsp:include page="/WEB-INF/views/admin/layout/headerResources.jsp"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/tabs.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/board.css" type="text/css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/paginate.css" type="text/css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<style type="text/css">
  .product-subject { width: 330px; }
  .product-subject img { vertical-align: top; width: 50px; height: 50px; border-radius: 5px;
	  border: 1px solid #d5d5d5; }
  .product-subject label { display: inline-block; max-width: 300px; padding-left: 5px;
	  vertical-align: top; white-space: pre-wrap; }
</style>
</head>
<body>

<header>
	<jsp:include page="/WEB-INF/views/admin/layout/header.jsp"/>
</header>

<main class="main-container">
	<jsp:include page="/WEB-INF/views/admin/layout/left.jsp"/>

	<div class="right-panel">
		<div class="page-title">
			<h2><i class="bi bi-bag-check-fill"></i> 판매 상품 <span class="page-small-title">&nbsp;&nbsp;|&nbsp;&nbsp; Sales List</span></h2>
		</div>

		<div class="section p-5" data-aos="fade-up" data-aos-delay="100">
			<div class="section-body p-5">
				<div class="row gy-4 m-0">
					<div class="col-lg-12 board-section p-5 m-2">

						<div class="tab-content pt-4" id="myTabContent">
							<div class="tab-pane fade show active" id="tab-pane" role="tabpanel" aria-labelledby="tab-1" tabindex="0">

								<div class="row mb-2">
                                    <div class="col-md-8">
                                        <div class="row">
                                            <div class="col-md-4 pe-1">
                                                <select id="changeCategory" class="form-select round-select" onchange="changeList();">
                                                    <c:if test="${listCategory.size() == 0}">
                                                        <option value="0">:: 메인카테고리 ::</option>
                                                    </c:if>
                                                    <c:forEach var="vo" items="${listCategory}">
                                                        <option value="${vo.categoryNum}" ${parentNum==vo.categoryNum?"selected":""}>${vo.categoryName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-4 pe-1">
                                                <select id="changeSubCategory" class="form-select" onchange="changeSubList();">
                                                    <c:if test="${listSubCategory.size() == 0}">
                                                        <option value="0">:: 카테고리 ::</option>
                                                    </c:if>
                                                    <c:forEach var="vo" items="${listSubCategory}">
                                                        <option value="${vo.categoryNum}" ${categoryNum==vo.categoryNum?"selected":""}>${vo.categoryName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-4 ps-1">
                                                <select id="changeShowProduct" class="form-select" onchange="changeList();">
                                                    <option value="-1">:: 진열 여부 ::</option>
                                                    <option value="1" ${productShow==1?"selected":""}>상품 진열</option>
                                                    <option value="0" ${productShow==0?"selected":""}>상품 숨김</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4 pt-2 text-end page-small-title">
                                        ${dataCount}개 (${page} / ${total_page} 페이지)
                                    </div>
                                </div>

                                <table class="table table-hover board-list">
                                    <thead>
                                        <tr>
                                            <th width="130">상품코드</th>
                                            <th>상품명</th>
                                            <th width="100">가격</th>
                                            <th width="60">재고</th>
                                            <th width="60">진열</th>
                                            <th width="90">수정일</th>
                                            <th width="120">변경</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="dto" items="${list}" varStatus="status">
                                            <tr valign="middle">
                                                <td>${dto.productNum}</td>
                                                <td class="product-subject left">
                                                    <img src="${pageContext.request.contextPath}/uploads/products/${dto.thumbnail}">
                                                    <a href="#"><label>${dto.productName}</label></a>
                                                </td>
                                                <td>${dto.price}</td>
                                                <td>${dto.totalStock}</td>
                                                <td>${dto.productShow==1?"표시":"숨김"}</td>
                                                <td>${dto.update_date}</td>
                                                <td>
                                                    <c:url var="updateUrl" value="/admin/products/update/${classify}">
                                                        <c:param name="productNum" value="${dto.productNum}"/>
                                                        <c:param name="parentNum" value="${parentNum}"/>
                                                        <c:param name="categoryNum" value="${categoryNum}"/>
                                                        <c:param name="page" value="${page}"/>
                                                    </c:url>
                                                    <button type="button" class="btn-default btn-sm btn-productStock" data-productNum="${dto.productNum}" data-optionCount="${dto.optionCount}">재고</button>
                                                    <button type="button" class="btn-default btn-sm" onclick="location.href='${updateUrl}';">수정</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>

                                <div class="page-navigation">
                                    ${dataCount == 0 ? "등록된 상품이 없습니다." : paging}
                                </div>

                                <div class="row mt-3">
                                    <div class="col-md-3">
                                        <button type="button" class="btn-default" onclick="location.href='${pageContext.request.contextPath}/admin/products/main/${classify}';" title="새로고침"><i class="bi bi-arrow-clockwise"></i></button>
                                    </div>
                                    <div class="col-md-6 text-center">
                                        <form name="searchForm" class="form-search">
                                            <select name="schType">
                                                <option value="all" ${schType=="all"?"selected":""}>상품명+설명</option>
                                                <option value="productNum" ${schType=="productNum"?"selected":""}>상품코드</option>
                                                <option value="productName" ${schType=="productName"?"selected":""}>상품명</option>
                                                <option value="content" ${schType=="content"?"selected":""}>설명</option>
                                            </select>
                                            <input type="text" name="kwd" value="${kwd}">
                                            <input type="hidden" name="size" value="${size}">
                                            <input type="hidden" name="parentNum" value="${parentNum}">
                                            <input type="hidden" name="categoryNum" value="${categoryNum}">
                                            <input type="hidden" name="productShow" value="${productShow}">
                                            <button type="button" class="btn-default" onclick="searchList();"><i class="bi bi-search"></i></button>
                                        </form>
                                    </div>
                                    <div class="col-md-3 text-end">
                                        <c:url var="url" value="/admin/products/write/${classify}"/>
                                        <button type="button" class="btn-accent btn-md" onclick="location.href='${url}';">상품등록</button>
                                    </div>
                                </div>

                            </div>
                        </div>

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
// 탭
$(function(){
    $('button[role="tab"]').on('click', function(){
        const tab = $(this).attr('aria-controls');

        if(tab === '1') { // 일반상품
            location.href = '${pageContext.request.contextPath}/admin/products/main/100';
        } else if( tab === '2') { // 오늘의 특가
            location.href = '${pageContext.request.contextPath}/admin/products/main/200';
        } else if( tab === '3') { // 기획상품
            location.href = '${pageContext.request.contextPath}/admin/products/main/300';
        }
    });
});

window.addEventListener('DOMContentLoaded', () => {
    const inputEL = document.querySelector('form input[name=kwd]');
    inputEL.addEventListener('keydown', function (evt) {
        if(evt.key === 'Enter') {
            evt.preventDefault();

            searchList();
        }
    });
});

function searchList() {
    const f = document.searchForm;
    if(! f.kwd.value.trim()) {
        return;
    }

    listProduct();
}

function listProduct() {
    const f = document.searchForm;

    const formData = new FormData(f);
    let requestParams = new URLSearchParams(formData).toString();

    let url = '${pageContext.request.contextPath}/admin/products/main/${classify}';
    location.href = url + '?' + requestParams;
}

function changeList() {
    let parentNum = $('#changeCategory').val();
    let productShow = $('#changeShowProduct').val();

    const f = document.searchForm;
    f.parentNum.value = parentNum;
    f.categoryNum.value = 0;
    f.productShow.value = productShow;

    listProduct();
}

function changeSubList() {
    let parentNum = $('#changeCategory').val();
    let categoryNum = $('#changeSubCategory').val();
    let productShow = $('#changeShowProduct').val();

    const f = document.searchForm;
    f.parentNum.value = parentNum;
    f.categoryNum.value = categoryNum;
    f.productShow.value = productShow;

    listProduct();
}

$(function(){
    // 재고 관리 대화상자
    $('.btn-productStock').click(function(){
        let productNum = $(this).attr('data-productNum');
        let optionCount = $(this).attr('data-optionCount');
        let url = '${pageContext.request.contextPath}/admin/products/listProductStock?productNum=' + productNum + '&optionCount=' + optionCount;

        $('.modal-productStock').load(url);

        $('#productStockDialogModal').modal('show');
    });

    // 재고 일괄 변경
    $('.modal-productStock').on('click', '.btn-allStockUpdate', function(){
        if(! confirm('재고를 일괄 변경 하시겠습니까 ? ')) {
            return false;
        }

        let productNum = $(this).attr('data-productNum');
        let url = '${pageContext.request.contextPath}/admin/products/updateProductStock';
        let formData = 'productNum=' + productNum;

        let isValid = true;
        $('.productStcok-list tr').each(function(){
            let $input = $(this).find('input[name=totalStock]');
            let $btn = $(this).find('.btn-stockUpdate');

            if(!/^\d+$/.test($input.val())) {
                alert('재고량은 숫자만 가능합니다.');
                $input.focus();
                isValid = false;
                return false;
            }

            let stockNum = $btn.attr('data-stockNum');
            let detailNum = $btn.attr('data-detailNum');
            detailNum = detailNum ? detailNum : 0;
            let detailNum2 = $btn.attr('data-detailNum2');
            detailNum2 = detailNum2 ? detailNum2 : 0;
            let totalStock = $input.val().trim();

            formData += '&stockNums=' + stockNum;
            formData += '&detailNums=' + detailNum;
            formData += '&detailNums2=' + detailNum2;
            formData += '&totalStocks=' + totalStock;
        });

        if( ! isValid ) {
            return false;
        }

        const fn = function(data) {
            if(data.state === 'true') {
                alert('재고가 일괄 변경 되었습니다.');
            } else {
                alert('재고 일괄 변경이 실패 했습니다.');
            }
        };

        ajaxRequest(url, 'post', formData, 'json', fn);
    });

    // 재고 변경
    $('.modal-productStock').on('click', '.btn-stockUpdate', function(){
        let productNum = $(this).attr('data-productNum');
        let stockNum = $(this).attr('data-stockNum');
        let detailNum = $(this).attr('data-detailNum');
        detailNum = detailNum ? detailNum : 0;
        let detailNum2 = $(this).attr('data-detailNum2');
        detailNum2 = detailNum2 ? detailNum2 : 0;
        let totalStock = $(this).closest('tr').find('input[name=totalStock]').val();

        if(!/^\d+$/.test(totalStock)) {
            alert('재고량은 숫자만 가능합니다.');
            $(this).closest('tr').find('input[name=totalStock]').focus();
            return false;
        }

        let url = '${pageContext.request.contextPath}/admin/products/updateProductStock';
        let formData = {productNum:productNum, stockNums:stockNum, detailNums:detailNum,
                detailNums2:detailNum2, totalStocks:totalStock};

        const fn = function(data) {
            if(data.state === 'true') {
                alert('재고가 변경 되었습니다.');
            } else {
                alert('재고 변경이 실패 했습니다.');
            }
        };

        ajaxRequest(url, 'post', formData, 'json', fn);
    });
});

const productStockModalEl = document.getElementById('productStockDialogModal');
productStockModalEl.addEventListener('show.bs.modal', function(){
    // 모달 대화상자가 보일때
});

productStockModalEl.addEventListener('hidden.bs.modal', function(){
    // 모달 대화상자가 안보일때
    listProduct();
});
</script>

<footer>
    <jsp:include page="/WEB-INF/views/admin/layout/footer.jsp"/>
</footer>

<jsp:include page="/WEB-INF/views/admin/layout/footerResources.jsp"/>

</body>
</html>