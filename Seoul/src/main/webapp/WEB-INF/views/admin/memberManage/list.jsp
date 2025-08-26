<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
		
<table class="table table-borderless mt-2 mb-0">
	<tr>
		<td align="left" width="50%" valign="bottom">
			<p class="form-control-plaintext p-0">
				${dataCount}개(${page}/${total_page} 페이지)
			</p>
		</td>
		<td align="right">
			<div class="wrap-search-check">
				<div class="form-check-inline">
					<input type="checkbox" id="enabledCheck1" class="form-check-input" ${enabled == '1' || enabled == '' ? "checked":""}>
					<label class="form-check-label" for="enabledCheck1">활성</label>
				</div>
				<div class="form-check-inline">
					<input type="checkbox" id="enabledCheck2" class="form-check-input" ${enabled == '0' || enabled == '' ? "checked":""}>
					<label class="form-check-label" for="enabledCheck2">비활성</label>
				</div>
			</div>
		</td>
	</tr>
</table>
	
<table class="table table-hover board-list">
	<thead class="table-light">
		<tr> 
			<th width="80">번호</th>
			<th width="180">아이디</th>
			<th width="100">구분</th>
			<th width="100">이름</th>
			<th width="80">권한</th>
			<th width="70">상태</th>
			<th>이메일</th>
		</tr>
	</thead>
	
	<tbody>
		<c:forEach var="dto" items="${list}" varStatus="status">
			<tr class="hover-cursor" onclick="profile('${dto.member_id}', '${page}');"> 
				<td>${dataCount - (page-1) * size - status.index}</td>
				<td>${empty dto.login_id ? dto.sns_id : dto.login_id}</td>
				<td>${empty dto.login_id ? 'SNS 회원' : (empty dto.sns_id ? '로컬 회원' : '로컬, SNS 회원')}</td>
				<td>${dto.name}</td>
				<td>
					<c:choose>
						<c:when test="${dto.userLevel==1}">회원</c:when>
						<c:when test="${dto.userLevel==5}">셀러</c:when>
						<c:otherwise>기타</c:otherwise>
					</c:choose>
				</td>
				<td>${dto.enabled==1 ? "활성":"잠금"}</td>
				<td>${dto.email}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
		 
<div class="page-navigation">
	${dataCount == 0 ? "등록된 자료가 없습니다." : paging}
</div>

<div class="row board-list-footer">
	<div class="col-md-3">
		<button type="button" class="btn-default" onclick="resetList();" title="새로고침"><i class="bi bi-arrow-counterclockwise"></i></button>
	</div>
	<div class="col-md-6 text-center">
		<div class="form-search">
			<select id="searchType" name="schType">
				<option value="login_id"  ${schType=="login_id" ? "selected":""}>아이디</option>
				<option value="name"      ${schType=="name" ? "selected":""}>이름</option>
				<option value="email"     ${schType=="email" ? "selected":""}>이메일</option>
			</select>
			<input type="text" id="keyword" name="kwd" value="${kwd}">
			<button type="button" class="btn-default" onclick="searchList()"> <i class="bi bi-search"></i> </button>
		</div>
	</div>
	<div class="col-md-3 text-end">
		&nbsp;
	</div>
	
</div>
