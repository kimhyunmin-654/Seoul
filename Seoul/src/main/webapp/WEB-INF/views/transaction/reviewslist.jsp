<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>내 후기 보기</title>
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
                    <span class="small-title">내 후기 보기</span>
                    <span class="dataCount">후기 ${dataCount}개</span>
                  </div>
                </div>
              </div>

				<div class="mt-4 mb-1 wrap-inner">
					
					<div class="list-content" data-pageNo="0" data-totalPage="0"></div>
					
					<div class="list-footer mt-3 text-end">
						<span class="btn-default more-btn">&nbsp;더보기&nbsp;<i class="bi bi-chevron-down"></i>&nbsp;</span>
					</div>
				</div>

            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</main>

<script>
$(function() {
    loadContent(1);
});

function loadContent(page) {
	const url = '${pageContext.request.contextPath}/transaction/reviewslistData';

    $.ajax({
        url: url,
        method: 'GET',
        data: { pageNo: page },
        dataType: 'json'
    })
    .done(function(data) {
        console.log('reviewslist response:', data); 
        addNewContent(data);
    })
    .fail(function(jqXHR, textStatus, errorThrown) {
        console.error('reviewslist ajax error:', textStatus, errorThrown);
        alert('서버 오류가 발생했습니다.');
    });
}

function escapeHtml(str) {
    if (str === null || str === undefined) return '';
    return String(str).replace(/[&<>"']/g, function(ch) {
        return { '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#39;' }[ch];
    });
}

function addNewContent(data) {
    let dataCount = Number(data.dataCount) || 0;
    let pageNo = Number(data.pageNo) || 0;
    let total_page = Number(data.total_page) || 0;

    $('.list-content').attr('data-pageNo', pageNo);
    $('.list-content').attr('data-totalPage', total_page);

    $('.dataCount').text('후기 ' + dataCount + '개');

    $('.list-footer').hide();

    if (dataCount === 0) {
        if (pageNo === 1) {
            $('.list-content').empty().append('<div class="p-3 text-center text-muted">작성한 후기가 없습니다.</div>');
        }
        return;
    }

    if (pageNo < total_page) {
        $('.list-footer').show();
    }

    const ctx = '${pageContext.request.contextPath}';
    let htmlText = '';

    const list = Array.isArray(data.list) ? data.list : [];

    for (let item of list) {
        const nickname = escapeHtml(item.nickname || '익명');
        const content = escapeHtml(item.content || '');
        const created_at = escapeHtml(item.created_at || '');
        let profile = item.profile_photo || '';

        if (profile) {
            if (profile.startsWith('/') || profile.startsWith(ctx) || /^https?:\/\//i.test(profile)) {
            } else {
                profile = ctx + '/uploads/member/' + profile;
            }
        } else {
            profile = ctx + '/dist/images/default-profile.png';
        }

        const rating = Number(item.rating) || 0;
        let stars = '';
        for (let i = 1; i <= 5; i++) {
            stars += (i <= rating) ? '★' : '☆';
        }

        htmlText += ''
          + '<div class="item-content mb-3">'
          + '  <div class="d-flex align-items-start gap-3 p-3 border rounded bg-white">'
          + '    <img src="' + escapeHtml(profile) + '" alt="프로필" style="width:56px;height:56px;border-radius:50%;object-fit:cover;">'
          + '    <div class="flex-fill">'
          + '      <div class="d-flex justify-content-between align-items-start">'
          + '        <div><strong>' + nickname + '</strong></div>'
          + '        <div style="font-size:1.1rem;color:#f5b301;">' + stars + '</div>'
          + '      </div>'
          + '      <div class="mt-2 text-break" style="white-space:pre-wrap;">' + content + '</div>'
          + '      <div class="text-muted mt-2" style="font-size:0.85rem;">' + created_at + '</div>'
          + '    </div>'
          + '  </div>'
          + '</div>';
    }

    $('.list-content').append(htmlText);
}

$(function() {
    $('.list-footer .more-btn').click(function() {
        let pageNo = Number($('.list-content').attr('data-pageNo')) || 0;
        let total_page = Number($('.list-content').attr('data-totalPage')) || 0;

        if (pageNo < total_page) {
            pageNo++;
            loadContent(pageNo);
        }
    });
});
</script>

</body>
</html>