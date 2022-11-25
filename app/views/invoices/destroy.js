$(".flash_notice").empty()
$(".flash_notice").append("<%= j(flash.discard(:notice))%>")
$("#invoice_<%=@invoice.id%>").remove();
NProgress.done();
