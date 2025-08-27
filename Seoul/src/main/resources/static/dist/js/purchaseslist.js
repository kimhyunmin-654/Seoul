$(function(){
  $(document).on('click', '.btn-write-review', function(){
    var roomId = $(this).data('room_id');
    var productId = $(this).data('product_id');

    $.getJSON(ctx + '/transaction/reviewForm',
      { room_id: roomId, product_id: productId })
    .done(function(res){
      if(!res || !res.success){
        alert(res && res.message ? res.message : '후기 작성 불가');
        return;
      }
      $('#rv_chat_id').val(res.chat_id);
      $('#rv_room_id').val(res.room_id);
      $('#rv_product_id').val(res.product_id);
      $('#rv_product_name').text(res.product_name || '');
      $('#rv_rating').val(5);
      $('#rv_content').val('');
      $('#rv_msg').text('');

      $('#reviewModal').show();
    })
    .fail(function(){ alert('서버 오류'); });
  });

  $('#rv_cancel, #reviewModalClose').on('click', function(){
    $('#reviewModal').hide();
  });

  $('#rv_submit').on('click', function(){
    var chatId = $('#rv_chat_id').val();
    var productId = $('#rv_product_id').val();
    var rating = parseInt($('#rv_rating').val(),10);
    var content = $('#rv_content').val();

    if(!chatId || !productId){
      $('#rv_msg').text('잘못된 요청입니다.');
      return;
    }
    if(rating < 1 || rating > 5){
      $('#rv_msg').text('별점을 선택하세요.');
      return;
    }

    $.post(ctx + '/transaction/writeReview',
      { chat_id: chatId, product_id: productId, rating: rating, content: content })
    .done(function(resp){
      if(resp && resp.success){
        alert(resp.message || '후기 등록 완료');
        $('#reviewModal').hide();
      } else {
        alert(resp.message || '실패');
      }
    })
    .fail(function(){ alert('서버 오류'); });
  });
});