function Change_select(log_id, object_id, url, http_method){
		NProgress.start();;
		    if(object_id === ""){
		      $.get("/" + url + "/0/" + log_id  )
		    }else{
		      $.get("/" + url + "/" + object_id + "/" + log_id)
	    };
};

jQuery.fn.UIdialogs_tracking_logs_links = function(){
  $(this).click(function(){
  	$(".tracking_select").slideToggle();
  	$(".open_tracking_select").toggleClass("close_tracking_select");

    var data_id = $(".open_tracking_select").attr('data-id')
    var form_id = '#form_holder'

    // get todo and saving log when selecting project
	    $(form_id).find("select#logProjectIdTracking").change(function(){
        if (this.value.toString() == ""){
          $.post("/project_select_tracking/0/" + $(this).attr("log"))
        }else{
          $.post("/project_select_tracking/" + this.value.toString() + "/" + $(this).attr("log"))
       }
	    });
	    $(form_id).find("select#logTodoIdTracking" + data_id).change(function(){
        if (this.value.toString() == ""){
          $.post("/todo_select_tracking/0/" + $(this).attr("log"))
        }else{
          $.post("/todo_select_tracking/" + this.value.toString() + "/" + $(this).attr("log"))
       }
	    });
	  // get employees and saving log when selecting customer
	    $(form_id).find("select#logCustomerIdTracking" + data_id).change(function(){
        if (this.value.toString() == ""){
          $.post("/customer_select_tracking/0/" + $(this).attr("log"))
        }else{
          $.post("/customer_select_tracking/" + this.value.toString() + "/" + $(this).attr("log"))
       }
	    });

	    $(form_id).find("select#logEmployeeIdTracking" + data_id).change(function(){
        if (this.value.toString() == ""){
          $.post("/employee_select_tracking/0/" + $(this).attr("log"))
        }else{
          $.post("/employee_select_tracking/" + this.value.toString() + "/" + $(this).attr("log"))
       }
	    });
   });

};
jQuery.fn.save_while_typing = function(){
      var delay = (function(){
      var timer = 0;
      return function(callback, ms){
        clearTimeout (timer);
        timer = setTimeout(callback, ms);
      };
      })();
    var $this = $(this)
    var id = $(this).data('id')
    $(this).on('keyup', function(e) {
      delay(function(){
        $.ajax({
        url: "/logs/" + id,
        type: "PUT",
        data:  {log:{event: $this.val()}},
        chache:false,
        dateType: "JSON"
      });
      }, 5000 );
        $('#log_info_'+ id).find('.event_on_log').text($this.val())
    });
  //  var log = $(this).parent('.stop_tracking_form')
};
jQuery.fn.select_projects_customers = function() {
	$(this).UIdialogs();
   	$(this).dialog( "open" );
   	var data_id = $(this).attr('data-id')
	if (data_id === undefined ) {
		$(this).find("select#logProjectId").change(function(){
    	Change_select($(this).attr("log"), this.value.toString(), "project_select")
		});
   		$(this).find("select#logTodoId").change(function(){
	    Change_select("", this.value.toString(), "todo_select")
	    });
   		$(this).find("select#logCustomerId").change(function(){
    	Change_select("", this.value.toString(), "customer_select")
    	});
	}else{
		$(this).find("select#logProjectId" + data_id).change(function(){
    	Change_select($(this).attr("log"), this.value.toString(), "project_select")
		});
	    $(this).find("select#logTodoId" + data_id).change(function(){
	    Change_select($(this).attr("log"), this.value.toString(), "todo_select")
   		});
	    $(this).find("select#logCustomerId" + data_id).change(function(){
    	Change_select($(this).attr("log"), this.value.toString(), "customer_select")
		});
     };
};



jQuery.fn.UIdialogs_log_links = function(){
  var form = '#' + $(this).attr('id') + '_form'
  $(this).button().click(function(){
  	$(form).find(".date").datepicker()
  	var log_time_from = $("#log_times_from_").val();
    var log_time_to = $("#log_times_to_").val();
    $(form).children(".new_log").validateWithErrors()
  	$(form).find(".slider_range").slider({
        range: true,
        min: 0,
        max: 1439,

        values: [ time_to_value(log_time_from)-300, time_to_value(log_time_to) ],
        step:10,
        slide: slideTime
    });
    $(form).find(".searchableS").chosen({width:'369px'});
    $(form).select_projects_customers();
    });

};

jQuery.fn.UIdialogs_edit_logs_links = function(){
  $(this).click(function(){
    var data_id = $(this).attr('data-id')
    var form_id = '#' + $(this).attr('id') + '_' + data_id + '_form'
    $.get("/logs/" + data_id + "/edit/")

    });

};
function getTime(value, format){
			if (format == 'undefined')
				format = 1;
            var time = null,
                minutes,
                hours;
			hours = Math.floor(value / 60);
			minutes = value - (hours * 60);
			if (format == 2)
			{
				if (hours === 0) {
					hours = 12;
				}
				if (hours > 12) {
					hours = hours - 12;
					time = "pm";
				}
				else {
					time = "am";
				}
				if (minutes < 10) {
					minutes = "0" + minutes;
				}
				return hours + ":" + minutes + time;
			}
			else if (format == 1)
			{
				if (hours < 10) {
         			hours = "0" + hours;
    			 }

				if (minutes < 10) {
					minutes = "0" + minutes;
				}
				return hours + ":" + minutes;
			}
        }

function slideTime(event, ui){
   var log = $(this).attr("log")
    var val0 = parseInt(ui.values[ 0 ]);
    var val1 = parseInt(ui.values[ 1 ]);
    var format = $(".current_firm_data").data("clockformat")
    $("#log_times_from_" + log).val(getTime(val0,format ));
    $("#log_times_to_" + log).val(getTime(val1, format));
   };

// function slideTime(event, ui){
   // var log = $(this).attr("log")
    // var minutes0 = parseInt(ui.values[ 0 ]  % 60);
    // var hours0 = parseInt(ui.values[ 0 ]  / 60 % 24);
    // var minutes1 = parseInt(ui.values[ 1 ]  % 60);
    // var hours1 = parseInt(ui.values[ 1 ]  / 60 % 24);
    // $("#log_times_from_" + log).val(getTime(hours0, minutes0));
    // $("#log_times_to_" + log).val(getTime(hours1, minutes1));
   // };
//
// function getTime(hours, minutes) {
    // var time = null;
    // minutes = minutes + "";
    // if (minutes.length == 1) {
        // minutes = "0" + minutes;
    // }
    // hours = hours + "";
    // if (hours.length == 1) {
        // hours = "0" + hours;
    // }
//
    // return hours + ":" + minutes;
// };

function time_to_value(time){
    var b = time
    var temp = new Array
    temp = b.split(":")

    var hours = parseInt(temp[0] *60)
    var min = parseInt(temp[1])

    return hours + min
};
jQuery.fn.pr_date_select = function(){
	this.change(function(){
    NProgress.start();;
    $.get("/" + $(this).attr('data-object') + "_range",{time: this.value,
                                        url: $(this).attr("data-url"),
                                        id: $(this).attr("data-id")
                                      });
  });
  };
jQuery.fn.set_hours = function(){
	var firm_format = $(".current_firm_data").data("timeformat")
		this.each(function(index, element) {
	    	var hours = $(element).attr("data-hours")
	        $(element).html(secondsToString(hours, firm_format))
    });
  };

function set_hours(element){
	var firm_format = document.getElementById("current_firm_data").dataset.timeformat
  var hours = element.dataset.hours
  element.innerHTML = secondsToString(hours, firm_format)
  }

// jQuery.fn.set_budget_procent = function(){
//   var budget       = $('.budget_green').data('budget')
//   var hourly_price = $
//   var hours        =
// };
function update_hours(hours){
  var firm_format = $(".current_firm_data").data("timeformat")
  var pre_hours    = $('.statistics_unit_hours').data('hours')
  var post_hours   = (pre_hours + hours)
  $('.statistics_unit_hours').data('hours', post_hours)
  $('.statistics_unit_hours').html(secondsToString(post_hours, firm_format))
};
function update_budget_useage(hours, hourly_price){
  var budget      = $('.budget_green').data('budget')
  var pre_usage   = $('.budget_green').data('procent')
  var this_usage  = ((hours/3600)*hourly_price)/budget
  var post_usage  = this_usage + pre_usage
  $('.budget_green').data('procent', post_usage )
  $('.budget_green').set_buget_width()
};
jQuery.fn.set_view = function(){
  $(this).click(function(){
    val   = $(this).attr('id')
    user  = $(this).parent().data('user')
    date  = $(this).parent().data('date')
    klass = $(this).parent().data('klass')
    id    = $(this).parent().data('id')
    $('.view_selector').find('.current').removeClass('current')
    $('.view_selector').find('#' + val).addClass('current')
    if (val === "week_view"){
      $.get("/timesheet_week", {user_id: user, date: date, class: klass, id: id });
      window.location.hash = "tabs-3#week"
    }else if(val === "month_view")
    {
      $.get("/timesheet_month", {user_id: user, date: date, class: klass, id: id } )
      window.location.hash = "tabs-3#month"
    }else if(val === "list_view"){
      $.get("/tabs/tabs_logs/" + id + "/" + klass)
      window.location.hash = "tabs-3"
    }
  })
}
function looper(clas, func){
	  document.querySelectorAll(clas).forEach(box => { func(box) })
}
$(document).ready(function() {
  $('.view_selector').find('span').set_view()
  $('.log_event_recording').save_while_typing()
	// document.querySelector(".total_log_time").set_hours()
	$(".searchableS_tracking").chosen({width: '200px'});
  $("select#logs_pr_date_select").pr_date_select();
	$("#dialog_log").UIdialogs_log_links();
	$(".open_log_update").UIdialogs_edit_logs_links();
	$(".date").datepicker();

	$(".slider_range").slider({
	        range: true,
	        min: 0,
	        max: 1439,
	        values: [ 740, 1020 ],
	        step:10,
	        slide: slideTime
	    });
	$(".open_tracking_select_container").UIdialogs_tracking_logs_links();
})
var ready = (callback) => {
  if (document.readyState != "loading") callback();
  else document.addEventListener("DOMContentLoaded", callback);
}

ready(() => {

looper(".total_log_time", set_hours)


});
