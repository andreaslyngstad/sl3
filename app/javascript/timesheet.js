jQuery.fn.timeheet_user_select = function(){
	$(this).change(function(){
  NProgress.start();

  $.get("/timesheetWeek", {user_id: $(this).val(),
  													class: $(this).parent('.add_some_timesheet').data('klass'),
  													id: $(this).parent('.add_some_timesheet').data('id'), 
  													date:$(this).parent('.add_some_timesheet').data('date')  });
  });
}; 

jQuery.fn.timeheet_month_user_select = function(){
	$(this).change(function(){
  NProgress.start();
  $.get("/timesheetMonth", {user_id: $(this).val(),
  													class: $(this).parent('.add_some_timesheet').data('klass'),
  													id: $(this).parent('.add_some_timesheet').data('id'), 
  													date:$(this).parent('.add_some_timesheet').data('date')  });
  });
};  
function ready_timesheet(){
	var firm_format = $(".current_firm_data").data("timeformat") 
	$(".calendar_span").set_hours()
	$("tr.project_hours").each(function(index, element) {
    var row = $(this).find('td.total');
    var total = 0;
    $(this).find("td.number").each(function (index, element) {
    	var hours = $(element).data("hours")
      total += parseFloat(hours);
      $(element).html(secondsToString(hours, firm_format))
    });
    row.data("hours", total)
    row.html(secondsToString(total, firm_format));
	});
 	var total = 0;
	$("td.timesheet_day_total").each(function(index, element) {
	 total += parseFloat($(element).data("hours"));
	$(element).html(secondsToString($(element).data("hours"), firm_format))})
	$("td.timesheet_week_total").html(secondsToString(total, firm_format))
	$("td.timesheet_week_total").data("hours", total)
	$("#timeheet_project_select").chosen().change(function(){
	    this_value = $(this).val()
	    this_klass = $(this).data('klass')
	    $(".form_input_cell").each(function(i,v){
	    	$(v).addClass("log_date_" + $(v).data("date"))
	    })
		  $(".form_input_cell").attr("data-select_klass", this_klass)
		  $(".form_input_cell").attr("data-select_id", this_value)
			$(".form_input_cell").val("")
			$(".form_input_cell").data("logid", "")
			$(".form_input_cell").data("prehours", "")
			$(".form_input_cell").prop('disabled', false);
			if (!this_value){	
				$(".form_input_cell").prop('disabled', true)	
			}	
	})
	$("select#timeheet_user_select").chosen()
	$("select#timeheet_user_select").timeheet_user_select();
	$("select#timeheet_month_user_select").chosen()
	$("select#timeheet_month_user_select").timeheet_month_user_select();

	$("table.timesheet_table tbody tr td.number input").focusout(function(){
	val_input = this.value
	regexp1 	= /^[0-9]+.[0-9]+$/  // test denne => /[0-9,:]+(?:\.[0-9]*)?/
	regexp2		= /^[0-9][0-9]*$/
	params    = {	select_klass: $(this).data("select_klass"), 
								select_id: 		$(this).attr("data-select_id"),		 
								klass: 				$(".timesheet_table").data("klass"),
								id: 					$(".timesheet_table").data("id"),
								date: 				$(this).data("date"), 
								log_id: 			$(this).data("logid"),
								val_input: 		val_input}
	if (regexp1.test(val_input) || regexp2.test(val_input)){
		$(this).css("color", "")
			NProgress.start();;
		$.ajax({
			url: "/add_hour_to_project/",	
			type: "POST",
    		data: params,
    		chache:false,
    		dateType: "JSON"
			});	
	
	}else{
		$(this).css("color", "red")
		
		setTimeout(function(){
	      
		},0);}	
  });
  $('.go_to_day_link').go_to_day_link()
  $('.spinning').hide();
} 
jQuery.fn.go_to_day_link = function(){
	$(this).click(function(){
  $.get("/log_range", {	from: $(this).data('from'), 
  											to: $(this).data('to'),
  											url: $(this).data('url'), 
  											id:$(this).data('id') 
  										});
	})
}

$(document).ready(function() {
	
	ready_timesheet()
})