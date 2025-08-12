window.addEventListener('DOMContentLoaded', () => {
	const btnDeleteEL = document.querySelector('button#btnDeleteList');
	const chkAllEL = document.querySelector('input#chkAll');
	const numsELS = document.querySelectorAll('form input[name=faq_ids]');
	
	btnDeleteEL.addEventListener('click', () => {
		const f = document.listForm;
		const checkedELS = document.querySelectorAll('form input[name=faq_ids]:checked');
		
		if(checkedELS.length === 0) {
			alert("삭제할 질문을 먼저 선택하세요.");
			return;
		}
		
		if(confirm('선택한 질문을 삭제하시겠습니까?')) {
			console.log(f);
			f.action = `${ctx}/admin/faqManage/deletelist`;
			f.submit();
		}
	});
	
	chkAllEL.addEventListener('click', () => {
	    numsELS.forEach(inputEL => inputEL.checked = chkAllEL.checked);
	});

	numsELS.forEach(el => {
	    el.addEventListener('click', () => {
	        const checked = document.querySelectorAll('form input[name=faq_ids]:checked');
	        chkAllEL.checked = numsELS.length === checked.length;
	    });
	});
	
	const kwdEL = document.querySelector('form[name=searchForm] input[name=kwd]');
	kwdEL.addEventListener('keydown', function(evt) {
		if(evt.key === 'Enter') {
			evt.preventDefault();
			searchList();
		}
	});
	
	window.changeList = function() {
		const f = document.pageSizeForm;
		const formData = new FormData(f);
		const params = new URLSearchParams(formData).toString();
		location.href = `${ctx}/admin/faqManage/list?` + params;
	};

	window.searchList = function() {
		const f = document.searchForm;
		if (!f.kwd.value.trim()) return;

		const formData = new FormData(f);
		const params = new URLSearchParams(formData).toString();
		location.href = `${ctx}/admin/faqManage/list?` + params;
	};
	
});