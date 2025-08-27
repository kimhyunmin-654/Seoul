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
                            <a  href="${pageContext.request.contextPath}/product/detail?product_id=${p.product_id}">
	                            <div class="text-wrap">
	                                <c:out value="${p.product_name}"/>
	                            </div>
                            </a>								
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
						    </c:when>
						
						    <c:otherwise>
						      <span class="status-actions">
						        <button type="button" class="btn btn-sm btn-outline-secondary btn-small btn-status-edit"
						                data-product-id="${p.product_id}" data-current-status="${p.status}">수정</button>
						      </span>
						    </c:otherwise>
						  </c:choose>
						</td>
							
                          <td class="align-middle date">
						  <div class="d-flex align-items-center justify-content-between gap-2">
						    <span class="reg-date"><c:out value="${p.reg_date}"/></span>
						    <button type="button"
						            class="btn btn-sm btn-outline-danger btn-small btn-delete"
						            data-product-id="${p.product_id}" >
						      삭제
						    </button>
						  </div>
						</td>
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

<script>
  window.ctx = '${pageContext.request.contextPath}';
</script>

<script src="${pageContext.request.contextPath}/dist/js/salelist.js"></script>

</body>
</html>













