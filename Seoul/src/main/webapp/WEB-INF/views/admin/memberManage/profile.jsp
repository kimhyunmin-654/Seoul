<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<h3 class="form-control-plaintext fs-6 fw-semibold"><i class="bi bi-chevron-double-right"></i> 회원 상세 정보</h3>
<table class="table table-bordered">
	<tr>
		<td class="bg-light col-sm-2">회원번호</td>
		<td class="col-sm-4">${dto.member_id}</td>
		<td class="bg-light col-sm-2">권 한</td>
		<td class="col-sm-4">
			<c:choose>
				<c:when test="${dto.userLevel==1}">회원</c:when>
				<c:when test="${dto.userLevel==5}">셀러</c:when>
				<c:otherwise>기타</c:otherwise>
			</c:choose>
		</td>
	</tr>
	
	<tr>
		<td class="bg-light col-sm-2">이 름</td>
		<td class="col-sm-4">${dto.name}</td>
		<td class="bg-light col-sm-2">회원구분</td>
		<td class="col-sm-4">${empty dto.login_id ? 'SNS 회원' : (empty dto.sns_id ? '로컬 회원' : '로컬, SNS 회원')}</td>
	</tr>
		
	<tr>
		<td class="bg-light col-sm-2">로그인 아이디</td>
		<td class="col-sm-4">${dto.login_id}</td>
		<td class="bg-light col-sm-2">전화번호</td>
		<td class="col-sm-4"></td> <!-- 전화번호 필드가 누락되어 있어 빈 <td> 추가 -->
	</tr>	

	<tr>
		<td class="bg-light col-sm-2">SNS 아이디</td>
		<td class="col-sm-4">${dto.sns_id}</td>
		<td class="bg-light col-sm-2">SNS 제공자</td>
		<td class="col-sm-4">${dto.sns_provider}</td>
	</tr>	

	<tr>
		<td class="bg-light col-sm-2">이메일</td>
		<td colspan="3">${dto.email}</td>
	</tr>

	<tr>
		<td class="bg-light col-sm-2">가입일</td>
		<td class="col-sm-4">${dto.created_at}</td>
		<td class="bg-light col-sm-2">최근수정일</td>
		<td class="col-sm-4">${dto.update_at}</td>
	</tr>
	<tr>
		<td class="bg-light col-sm-2">최근로그인</td>
		<td class="col-sm-4">${dto.last_login}</td>
		<td class="bg-light col-sm-2">로그인실패</td>
		<td class="col-sm-4">${dto.failure_cnt}</td>
	</tr>
	<tr>
		<td class="bg-light col-sm-2">계정상태</td>
		<td class="col-sm-4">${dto.enabled==1 ? "활성":"잠금"}</td>
	</tr>
	<tr>
		<td class="bg-light col-sm-2">상태정보</td>
		<td colspan="3">${memberStatus.memo}</td>
	</tr>
</table>

<table class="table table-borderless">
	<tr> 
		<td class="text-end">
			<button type="button" class="btn-default" onclick="statusDetailesMember();">계정상태</button>
			<c:if test="${dto.userLevel < 50 || sessionScope.member.userLevel > 90 }">
				<button type="button" class="btn-default" onclick="updateMember();">수정</button>
				<button type="button" class="btn-default" onclick="deleteMember('${dto.member_id}', '${page}');">삭제</button>
			</c:if>
			<button type="button" class="btn-default" onclick="listMember('${page}');">리스트</button>
		</td>
	</tr>
</table>

<!-- 수정 대화상자 -->
<div class="modal fade" data-bs-backdrop="static" id="memberUpdateDialogModal" tabindex="-1" aria-labelledby="memberUpdateDialogModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="memberUpdateDialogModalLabel">회원정보수정</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
			
				<form name="memberUpdateForm" id="memberUpdateForm" method="post">
					<table class="table write-form mb-1">
						<tr>
							<td width="110" class="bg-light">아이디</td>
							<td><p class="form-control-plaintext">${dto.login_id}</p></td>
						</tr>
						<tr>
							<td class="bg-light">이름</td>
							<td>
								<input type="text" name="name" class="form-control" value="${dto.name}" style="width: 95%;">
							</td>
						</tr>
						<tr>
							<td class="bg-light">권한</td>
							<td>
								<select name="userLevel" class="form-select" style="width: 95%;">
									<c:choose>
										<c:when test="${dto.userLevel < 6}">
											<option value="1" ${dto.userLevel==1 ? "selected":""}>일반회원</option>
											<option value="5" ${dto.userLevel==5 ? "selected":""}>셀러</option>
											<option value="0" ${dto.userLevel==0 ? "selected":""}>비회원</option>
										</c:when>
										<c:otherwise>
											<option value="5" ${dto.userLevel==5 ? "selected":""}>셀러</option>
											<c:if test="${sessionScope.member.userLevel > 90}">
												<option value="50" ${dto.userLevel==50 ? "selected":""}>폐점</option>
											</c:if>
										</c:otherwise>
									</c:choose>
								</select>
							</td>
						</tr>
					</table>
					<div class="text-end">
						<input type="hidden" name="member_id" value="${dto.member_id}">
						<input type="hidden" name="login_id" value="${dto.login_id}">
						<input type="hidden" name="enabled" value="${dto.enabled}">
						
						<button type="button" class="btn-default" onclick="updateMemberOk('${page}');">수정완료</button>
					</div>
				</form>
			
			</div>
		</div>
	</div>
</div>

<!-- 상태 대화상자 -->
<div class="modal fade" data-bs-backdrop="static" id="memberStatusDetailesDialogModal" tabindex="-1" aria-labelledby="memberStatusDetailesDialogModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" style="max-width: 650px;">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="memberStatusDetailesModalLabel">회원상태정보</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<h3 class="form-control-plaintext fs-6 fw-semibold pt-1"><i class="bi bi-chevron-double-right"></i> 상태 변경</h3>
				<form name="memberStatusDetailesForm" id="memberStatusDetailesForm" method="post">
					<table class="table table-bordered mb-1">
						<tr>
							<td width="110" class="bg-light align-middle">이름(아이디)</td>
							<td>
								<p class="form-control-plaintext">${dto.name}(${dto.login_id})</p>
							</td>
						</tr>
						<tr>
							<td class="bg-light align-middle">계정상태</td>
							<td>
								<select name="status_code" id="statusCode" class="form-select" onchange="selectStatusChange()">
									<option value="">:: 상태코드 ::</option>
									<c:if test="${dto.enabled==0}">
										<option value="0">잠금 해제</option>
									</c:if>
									<option value="2">불법적인 방법으로 로그인</option>
									<option value="3">불건전 게시물 등록</option>
									<option value="4">다른 유저 비방</option>
									<option value="5">타계정 도용</option>
									<option value="6">약관 위반</option>
									<option value="7">1년이상 로그인하지 않음</option>
									<option value="8">기타</option>
								</select>
							</td>
						</tr>
						<tr>
							<td class="bg-light align-middle">메 모</td>
							<td>
								<input type="text" name="memo" id="memo" class="form-control">
							</td>
						</tr>
					</table>
					<div class="text-end">
						<input type="hidden" name="member_id" value="${dto.member_id}">
						<input type="hidden" name="register_id" value="${sessionScope.member.member_id}">
						
						<button type="button" class="btn-default" onclick="updateStatusOk('${page}');">상태변경</button>
					</div>
				</form>
			
				<h3 class="form-control-plaintext fs-6 fw-semibold pt-3"><i class="bi bi-chevron-double-right"></i> 상태 리스트</h3>			
				<table class="table board-list">
					<thead class="table-light">
						<tr>
							<th>내용</th>
							<th width="120">담당자</th>
							<th width="180">등록일</th>
						</tr>
					</thead>
					
					<tbody>
						<c:forEach var="vo" items="${listStatus}">
							<tr>
								<td class="left">${vo.memo}</td>
								<td>관리자</td>
								<td>${vo.reg_date}</td>
							</tr>
						</c:forEach>
				  
						<c:if test="${listStatus.size()==0}">
							<tr>
								<td colspan="3" style="border: none;">등록된 정보가 없습니다.</td>
							</tr>  
						</c:if>
					</tbody>
				</table>  

			</div>
		</div>
	</div>
</div>

<!-- 커스텀 알림/확인 모달 -->
<div class="modal fade" id="customDialogModal" tabindex="-1" aria-labelledby="customDialogModalLabel" aria-hidden="true" data-bs-backdrop="static">
  <div class="modal-dialog modal-dialog-centered modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="customDialogModalLabel">알림</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body text-center" id="customDialogMessage">
      </div>
      <div class="modal-footer justify-content-center">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">확인</button>
        <button type="button" class="btn btn-primary d-none" id="customDialogConfirmBtn">확인</button>
      </div>
    </div>
  </div>
</div>



