window.addEventListener('DOMContentLoaded', () => {

	
	window.changeList = function() {
		const f = document.pageSizeForm;
		const formData = new FormData(f);
		const params = new URLSearchParams(formData).toString();
		location.href = `${ctx}/faq/list?` + params;
	};

	window.searchList = function() {
		const f = document.searchForm;
		if (!f.kwd.value.trim()) return;

		const formData = new FormData(f);
		const params = new URLSearchParams(formData).toString();
		location.href = `${ctx}/faq/list?` + params;
	};
	
});