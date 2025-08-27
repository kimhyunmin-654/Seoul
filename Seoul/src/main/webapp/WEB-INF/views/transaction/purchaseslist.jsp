<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>구매내역</title>
<link href="${pageContext.request.contextPath}/dist/images/favicon.png" rel="icon">
<link rel="stylesheet" href="${pageContext.request.contextPath}/dist/css/purchaseslist.css" type="text/css">

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
        <div class="container-fluid px-0" data-aos="fade-up" data-aos-delay="100">
          <div class="row justify-content-center">
            <div class="col-md-12 board-section my-4 p-4">

              <div class="row py-1 mb-3 align-items-center">
                <div class="col-md-8">
                  <div class="d-flex align-items-center flex-wrap gap-2">
                    <span class="small-title">나의 구매내역</span>
                    <span class="dataCount">${dataCount}개 (${page}/${total_page} 페이지)</span>
                  </div>
                </div>
                <div class="col-md-4 text-end">
                  <button type="button" class="btn btn-sm btn-light" onclick="location.href='${pageContext.request.contextPath}/transaction/purchaseslist'">새로고침</button>
                </div>
              </div>

              <form name="listForm" method="post">
                <table class="table table-hover board-list" style="width:100%; border-collapse:collapse;">
                    <colgroup>
					    <col style="width:5%;">   
					    <col style="width:14%;"> 
					    <col style="width:35%;">  
					    <col style="width:10%;">  
					    <col style="width:10%;">  
					    <col style="width:20%;">  
					    <col style="width:8%;">  
				  	</colgroup>

				  <thead>
				    <tr>
				      <th class="num">번호</th>
				      <th class="product-thumb">썸네일</th>
				      <th class="subject">상품명</th>
				      <th class="seller_nickname">판매자</th>
				      <th class="buyer_nickname">구매자</th>
				      <th class="buyer_nickname">확정일</th>
				      <th class="review">후기</th>
				      
				    </tr>
				  </thead>

                  <tbody>
                    <c:if test="${empty list}">
                      <tr>
                        <td colspan="7" class="no-data">구매한 상품이 없습니다.</td>
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
                                  <img src="<c:url value='/uploads/product/${p.thumbnail}'/>" alt="<c:out value='${p.product_name}'/>"
                                       onerror="this.onerror=null;this.src='<c:url value="/dist/images/no-image.png"/>'"/>
                                </c:when>
                                <c:otherwise>
                                  <img src="<c:url value='/dist/images/no-image.png'/>" alt="no image"/>
                                </c:otherwise>
                              </c:choose>
                            </div>
                          </td>

                          <td class="subject align-middle">
                            <div class="text-wrap">
                                <c:out value="${p.product_name}"/>        
                            </div>
                          </td>

                          <td class="align-middle"><c:out value="${p.seller_nickname}"/></td>
                          <td class="align-middle"><c:out value="${p.buyer_nickname}"/></td>
	                      <td class="align-middle"><c:out value="${p.created_at}"/></td>
						  <td class="align-middle">
						    <c:if test="${not empty p.room_id}">
						      <button type="button" class="btn btn-sm btn-outline-primary btn-write-review"
						              data-room_id="${p.room_id}" data-product_id="${p.product_id}">
						        후기작성
						      </button>
						    </c:if>
						  </td>
                        </tr>
                      </c:forEach>
                    </c:if>
                  </tbody>
                </table>
              </form>

              <div class="page-navigation text-center my-4">
                <c:out value="${dataCount == 0 ? '구매한 상품이 없습니다.' : paging}" escapeXml="false"/>
              </div>

            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
  
	<div id="reviewModal" class="modal" tabindex="-1" style="display:none;">
	  <div class="modal-dialog" role="document" style="max-width:520px;margin:6% auto;">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">판매자 후기 작성</h5>
	        <button type="button" class="btn-close" id="reviewModalClose"></button>
	      </div>
	      <div class="modal-body">
	        <input type="hidden" id="rv_chat_id" />
	        <input type="hidden" id="rv_room_id" />
	        <input type="hidden" id="rv_product_id" />
	        <div id="rv_product_name" style="font-weight:700;margin-bottom:8px;"></div>
	
	        <label>별점</label>
	        <select id="rv_rating" class="form-select form-select-sm" style="width:120px;">
	          <option value="5">5</option>
	          <option value="4">4</option>
	          <option value="3">3</option>
	          <option value="2">2</option>
	          <option value="1">1</option>
	        </select>
	
	        <label style="display:block;margin-top:8px;">내용</label>
	        <textarea id="rv_content" rows="4" style="width:100%;"></textarea>
	
	        <div id="rv_msg" style="color:red;margin-top:6px;"></div>
	      </div>
	      <div class="modal-footer" style="justify-content:flex-end;">
	        <button type="button" class="btn btn-light" id="rv_cancel">취소</button>
	        <button type="button" class="btn btn-primary" id="rv_submit">등록</button>
	      </div>
	    </div>
	  </div>
	</div>
  
  
</main>

<script>
  window.ctx = '${pageContext.request.contextPath}';
</script>

<script src="${pageContext.request.contextPath}/dist/js/purchaseslist.js"></script>



</body>
</html>
