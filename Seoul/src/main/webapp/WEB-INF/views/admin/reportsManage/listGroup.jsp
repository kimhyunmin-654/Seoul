<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<table class="table table-hover board-list">
	<thead>
		<tr>
			<th width="80">번호</th>
			<th>콘텐츠</th>
			<th width="90">글번호</th>
			<th width="130">분류</th>
			<th width="200">테이블명</th>
			<th width="90">신고건수</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="dto" items="${list}" varStatus="status">
			<tr> 
				<td>${dataCount - (pageNo-1) * size - status.index}</td>
				<td class="left">
					${dto.target_title}
				</td>
				<td>${dto.target_num}</td>
				<td>${dto.target_type}</td>
				<td>${dto.target_table}</td>
				<td>${dto.reportsCount}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>

<div class="page-navigation">
	${dataCount == 0 ? "등록된 자료가 없습니다." : paging}
</div>