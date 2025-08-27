$(function() {
    loadContent(1);
});

function loadContent(page) {
	const url = ctx + '/transaction/reviewslistData';

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