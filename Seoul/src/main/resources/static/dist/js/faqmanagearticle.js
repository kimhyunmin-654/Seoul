function deleteOk() {
	if(confirm('게시글을 삭제하시겠습니까 ? ')) {
		let params = 'faq_id=\${dto.faq_id}&page=\${page}';
		let url = CTX + '/admin/faqManage/delete?' + params;
		location.href = url;
	}
}