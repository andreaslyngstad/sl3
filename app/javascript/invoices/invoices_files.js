function pollJob(jobId, url) {
      function poll() {
        poll.calledTimes++;
        if(poll.calledTimes < 10){
        $.ajax({
          url: "/jobs/fetch_job/", // coupled to your app's routes
          type: "GET",
            data: {id: jobId},
            dataType: 'JSON',
            statusCode: {
              200: function(data) { 
                if(url == "ajax_sending"){
                    $.ajax({
                      url: "/jobs/" + url,
                      type: "GET",
                      data: {id: jobId, file: data.file},
                      })
                }else{
                  window.location.href = "/jobs/" + url + "?file=" + data.file + "&id=" + jobId;  $('.flash_notice').empty()  
                }
              },
              202: function(data) { setTimeout(poll, 2000); $('.flash_notice').text($.jsi18n.messages.generating_file)},
              500: function(data) { console.log('Error!'); }
            }
        });
      }else{
        $.ajax({
            url: "/jobs/time_out",
            type: "GET",
            data: {id: jobId},
            })
      }

      };
      poll.calledTimes = 0;
      poll();

    }

jQuery.fn.sending_to_handeling_invoice = function(action){
  $(document).on('click', '.download_invoice:not(.clicked2)', function(){
    $(this).addClass('clicked2')
    var id = $(this).attr("data-id")
    handeling_invoice(action, id)
     });
} 

function handeling_invoice(action, id){
  $.ajax({
        url: "/jobs/handeling_invoice/",  
        type: "POST",
          data: {id: id},
          dateType: "JSON",
          statusCode: {
            202: function(data) {$('.flash_notice').empty(), NProgress.done()},
            200: function(data) {pollJob(data.id, "ajax_" + action)} 
          }
        });
  };
jQuery.fn.download_invoice = function(){
   $(this).click(function(){
    $(this).hide()
    var id = $(this).attr("data-id")
    window.location.href = "/jobs/download/" + id;  $('.flash_notice').empty() 
  })
}
jQuery.fn.send_invoice = function(){
   $(this).click(function(){
    $(this).hide()
    var id = $(this).attr("data-id")
  $.ajax({
        url: "/emails/quick_send/" + id,  
        type: "GET"
        });
  });
};

$(document).ready(function() {
  $('.quick_send_invoice').send_invoice()
  // $('.download_invoice').download_invoice()
  // $('.quick_send_invoice').sending_to_handeling_invoice("sending")
  $('.download_invoice').sending_to_handeling_invoice("download")
});