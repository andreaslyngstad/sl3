// import "nprogress";
import jquery from 'jquery'
window.jQuery = jquery
window.$ = jquery
import "@hotwired/turbo-rails"
import "tasks"
import "controllers"







//= require jquery
//= require jquery_ujs

 //= require jquery-ui/jquery-ui.min

//= require external/chosen.jquery.min
/*
 * Modded jquery.validate date format recognition
//= require external/jquery.validate
 *
 */
 //= require external/history
//= require external/history_adapter_jquery
//= require translation
//= require locales/messages_no
//= require locales/messages_de
//= require locales/messages_en
//= require external/jquery.quicksearch
//= require timeFormatter
//= require navigation
//= require far_right
//= require logs
//= require tabs
//= require tasks
//= require reports
//= require log_tracking
//= require employees
//= require subscriptions
//= require nprogress.js
//= require sl_graphs

//= require timesheet
//= require external/strftime-min.js
//= require external/jquery.tablesorter.min
//= require memberships
//= require invoices/invoices
//= require invoices/invoices_files.js
//= require invoices/currency.js
//= require jquery.xcolor.min
"//= require nvd3_new/lib/d3.v2"
//= require nvd3_new/nv.d3.js
//= require nvd3_new/src/core
//= require nvd3_new/src/utils
//= require nvd3_new/src/models/axis
//= require nvd3_new/src/tooltip
//= require nvd3_new/src/models/legend
//= require nvd3_new/src/models/axis
//= require nvd3_new/src/models/scatter
//= require nvd3_new/src/models/stackedArea
//= require nvd3_new/src/models/stackedAreaChart
//= require nvd3_new/src/models/pie
//= require nvd3_new/src/models/pieChart
//= require nvd3_new/src/models/multiBar
//= require nvd3_new/src/models/multiBarChart
//= require nvd3_new/src/models/discreteBar
//= require nvd3_new/src/models/discreteBarChart
//= require dashboard
//= require economic_statistics
//= require colorArrays
//= require stackedAndPie
//= require tabs

//= require_self


 // History.Adapter.bind(window,'statechange',function(){ // Note: We are using statechange instead of popstate
 //        var State = History.getState(); // Note: We are using History.getState() instead of event.state
 //        console.log("tdsetset!" + State)
 //    });


jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})
function set_date_format_str(){
  var dateformat = $('.current_firm_data').data("dateformat")
  if (dateformat =="1"){
            return '%d.%m.%y'
          }else if (dateformat =="2") {
            return '%m/%d/%y'
          };
}

jQuery.fn.set_date_format = function(){
  	$.each($('.date_format_setter'),function(k,v){
  		$(v).html(strftimeTZ(set_date_format_str(), new Date($(v).data("date"))))
  	});
}
jQuery.fn.delete_firm_link = function(){
  $(this).click(function(){

  })
}

jQuery.fn.set_clock_format = function(){
  var clockformat = $('.current_firm_data').data("clockformat")
  if (clockformat == 1){
  	$.each($('.clock_format_setter'),function(k,v){
  		$(v).html(strftime('%H:%M', new Date($(v).data("time"))))
  	});
  }else if (clockformat == 2)
  {
  	var time = new Date(this.data("time"))
  	$.each($('.clock_format_setter'),function(k,v){
  		$(v).html(strftime('%I:%M%P', new Date($(v).data("time"))))
  	});

  }

}

jQuery.fn.chosen_reset = function(n){
  $(this).chosen('destroy');
  $(this).prop('selectedIndex', 0);
  $(this).chosen(n)
}

jQuery.fn.display_help = function(){
  if ($(".page_help").length !== 0){
      $(this).show()
    $(this).click(function(){
    $(this).data('clicked',!$(this).data('clicked'));
    if ($(this).data('clicked'))
      {
        var help_height = $(".page_help").height()
        $(".page_help").show()

      }
    else
      {
        $(".page_help").hide()

      };
    });
  };
};

//submitting forms with ajax
jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
    $.post(this.action, $(this).serialize(), null, "script");
    NProgress.start();
    return false;
  })
  return this;
};
jQuery.fn.submit_dialog_WithAjax = function() {
    $.post(this.attr("action"), $(this).serialize(), null, "script");
    NProgress.start();
    return false;
};
jQuery.fn.membership = function (){
  this.on('click', function() {
    NProgress.start();
    var user_id =  $(this).attr("id");
    var project_id = $(this).attr("project_id")
  $.getScript("/membership/" + user_id + "/" + project_id)
    })
};
jQuery.fn.highlight = function (className)
{
    return this.addClass(className);
};
jQuery.fn.UIdialogs = function(){
  $(this).dialog({
      autoOpen: false,
      resizable: false,
      width: 400,
      modal: true,
      position: ['middle',50],
      close: function(event, ui) {
      	$(this).find(".hasDatepicker").datepicker( "destroy" );
    	  $("#logProjectId").val('').trigger("chosen:updated")
      	$(this).dialog("destroy");
      }
  });
};

jQuery.fn.UIdialogs_autoopen = function(){
  $(this).dialog({
      autoOpen: true,
      resizable: false,
      width: 400,
      modal: true,
      position: ['middle',50],
      close: function(event, ui) {
        $(this).find(".hasDatepicker").datepicker( "destroy" );
        $("#logProjectId").val('').trigger("chosen:updated")
        $(this).dialog("destroy");
      }
  });
};
jQuery.fn.disableUIdialogs = function(){
  $(this).dialog("destroy");
};

jQuery.fn.validateWithErrors = function(){
    $(this).validate({
     submitHandler: function(form) {
    $(form).submit_dialog_WithAjax();
    $(form).parent().disableUIdialogs();
      },
   		errorElement: "div",
        wrapper: "div",  // a wrapper around the error message
     	errorPlacement: function(error, element) {
        element.before(error);
        offset = element.offset();
        error.css('left', offset.left);
        error.css('top', offset.top - element.outerHeight());

     },

   });

};
jQuery.fn.validateNoSubmit = function(){
    $(this).validate({
   		errorElement: "em",
     	errorPlacement: function(error, element) {
     	$(".signup-form-field-subdomain em").remove();
         error.appendTo( element.parent("div"));
         element.css("border:1px solid red;");
     }
   });
};
jQuery.fn.collapse_menu = function(){
  $(this).click(function(el){
    $('.selected').removeClass('selected')
    $(this).addClass('selected')
    id = $(this).attr("id")
    type =  $(this).data('type')
    $('.pref_fields').hide();
    $('.pref_buttons').hide();
    $('#' + id + '_fields').show()
    $('#' + type + '_buttons').show()

  })

};
jQuery.fn.UIdialogs_links = function(){
	$(this).button().click(function(){
  var form = '#' + $(this).attr('id') + '_form'
  var date = '#' + $(this).attr('id') + '_date'
  var object = $(this).attr("data-object")
  	$(form).UIdialogs();
    $(date).datepicker();
    $(form).find("form").validateWithErrors();
    $(form).find("select").chosen({width:'369px'})
    $(form).dialog( "open" );
  });
};
jQuery.fn.UIdialogs_edit_links = function(){
  $(this).click(function(){
    var data_id = $(this).attr('data-id')
    // get edit action via ajax for all in the ajax_form array
    var ajax_form = ["project", "customer", "invoice","todo", "user", "employee"]
    var object = $(this).attr("data-object")
    if ($.inArray(object, ajax_form) >= 0){
    $.get("/"+ object +"s/" + data_id + "/edit/")
    }
    var form_id = '#' + $(this).attr('id') + '_' + data_id + '_form'
    $(form_id).find("#date" + '_' + object + '_' + data_id).datepicker();
    // $(form_id).find(".edit_" + object).validateWithErrors();
    $(form_id).find("li").css("display", "");
    $(form_id).UIdialogs();
    $(form_id).dialog( "open" );
    });
};
// Project archive
jQuery.fn.activate_projects = function(){
	$(this).button().click(function(){
		if (confirm("The project, all its tasks, logged hours and milestones will be arcivated. You'll find the project in the arcivated projects page, where you can reopen it or delete it.")){
		NProgress.start();;
		var id = $(this).attr("data-id")
  	$.post("/activate_projects/" + id)}
    });
};
jQuery.fn.reopen_project = function(){
	$(this).click(function(){
		NProgress.start();;
		var id = $(this).attr("data-id")
  	$.post("/activate_projects/" + id)
    });
};

jQuery.fn.activate_projects_no_button = function(){
  $(this).click(function(){
    if (confirm("The project, all its tasks, logged hours and milestones will be arcivated. You'll find the project in the arcivated projects page, where you can reopen it or delete it.")){

    NProgress.start();;
    var id = $(this).attr("data-id")
    $.post("/activate_projects/" + id)}
    });

};
jQuery.fn.set_buget_width = function(){
    var procent = Math.round(this.data("procent") * 100)
    if (this.data("procent") == 10000 || this.data("procent") == 20000){
      $(this).css("width", "100%")
        $(".budget_red").css("width", "0%")
        $(".budget_red").html("")
        if (this.data("procent") == 10000){
                $(this).html("<p>" + $.jsi18n.messages.not_set    +"</p>")

              }else if(this.data("procent") == 20000){
                $(this).html("<p>" + $.jsi18n.messages.nothing_used  +"</p>")
              }
    }else if(procent < 100) {
      if (procent > 0){
        $(this).html(procent+ "%<p>" + $.jsi18n.messages.spent + "</p>")
      }
      var invert_procent = 100 - procent
      $(this).css("width", procent + "%")

      // $(this).css("color", "white")
      $(".budget_red").css("width", invert_procent + "%")
      $(".budget_red").html(invert_procent+ "%<p>" + $.jsi18n.messages.left + "</p>")

    }else if(procent > 100){
      var invert_procent = 100 - procent
      $(this).css("width", "100%")
      $(".budget_red").hide()
      $(this).html(procent+ "%<p>" + $.jsi18n.messages.spent + "</p>")
    }
};

// Project archive

jQuery.fn.set_selected_value = function(from,to){
  $(this).find('input#from').val(from)
  $(this).find('input#to').val(to)
}

// jQuery.fn.add_alternate_date_field = function(){
//   var name = $(this).attr('name')
//   var value = $(this).attr('value');
//   if (/_formated/i.test(name)){
//   }else{
//     $(this).parent().append('<input id="alternate" name="' + name + '" type="hidden" value="' + $.datepicker.parseDate('mm/dd/yy', value) + '">');
//     $(this).attr('name', name + '_formated');

//   }
// };



//ok

jQuery.fn.delete_firm_link = function(){
  $(this).click(function(){
    $('.delete_for_sure').slideDown()
    $(this).hide()
  })
}

jQuery.fn.delete_subdomain_validation = function(){
  $(this).keyup(function(){
    if (this.value == $(this).data('validate')){
        $('.name_checker').show()
      }
  })
}
jQuery.fn.delete_name_validation = function(){
  $(this).keyup(function(){
    if (this.value == $(this).data('validate')){
        $('.delete_for_real_link').show()
      }
  })
}
var get_ready = new $.Deferred();
get_ready
    .done(function () {
        $(".total_log_time").set_hours()
    })
;

// $(document).on('page:fetch',   function() { NProgress.start(); });
// $(document).on('page:change',  function() { NProgress.done(); });
// $(document).on('page:restore', function() { NProgress.remove(); });
// NProgress.configure({ showSpinner: false });
///////////////////////////////////////////////////////////////document.ready///////////////////////////////////////////////////////
if (document.all && document.addEventListener && !window.atob) {
    alert('IE8 or lower');
}
$.ajaxSetup({
  statusCode: {
  401: function(){

// Redirec the to the login page.
  location.href = "/sign_in";

  }
  }
  });

$(document).ready(function() {
  // $("#invoices_table").tablesorter();
  $('.delete_link').delete_firm_link()
  $('.delete_subdomain_validation').delete_subdomain_validation()
  $('.delete_name_validation').delete_name_validation()

  $('.pref_links').collapse_menu()
  $(".budget_green").set_buget_width()
  $('.date_format_setter').set_date_format()
  $(".show_avatar_upload").click(function(){
      $(".avatar_upload").show();
      $(".avatar_show_page").hide();
      return false
    });

  $(".hide_avatar_upload").click(function(){
    $(".avatar_upload").hide();
    $(".avatar_show_page").show();
    return false
  });
  // $(".total_log_time").set_hours()
  $(".tasks_percent").countDone();
  $("#dialog_customer").UIdialogs_links();
  $(".range_date").datepicker({
      onSelect: function() {
        $('#range_form').submit();
        }
    }).attr( 'readOnly' , 'true' )
	if ($('.current_firm_data').data("dateformat") == 1 ){
			$.datepicker.setDefaults( {
        dateFormat: "dd.mm.yy"
      } );

	}else if($('.current_firm_data').data("dateformat") == 2 ){
    // $('.hasDatepicker').parent().append('<input id="alternate" name="' + $(this).attr('name') + '" type="hidden" value="' + $.datepicker.parseDate('mm/dd/yy', '12/29/2013') + '">');
		$.datepicker.setDefaults( {
        dateFormat: "mm/dd/yy"
       } );
	}
  	$('.date_format_setter').set_date_format()
  	$('.clock_format_setter').set_clock_format()

   $(".display_help").display_help();

//jquery UI dialogs
  $("#dialog_todo").UIdialogs_links();
  $("#dialog_project").UIdialogs_links();
  $("#dialog_customer").UIdialogs_links();
  $("#dialog_user").UIdialogs_links();
  $("#dialog_employees").UIdialogs_links();

  $("#activate_project").button();


  $(".open_project_update").UIdialogs_edit_links();
  $(".open_user_update").UIdialogs_edit_links();
  $(".open_customer_update").UIdialogs_edit_links();

  $(".open_todo_update").UIdialogs_edit_links();

  $(".account_update_select").chosen({width:'367px'});
  $(".big_selector").chosen({width:'369px'});
  $(".small_selector").chosen({width:'150px'});


  $(".mini_selector").chosen({width:'177px', disable_search:true});
  $('.logs_pr_date_select').chosen({width:'150px', disable_search:true});
  $('.view_selector_select').chosen({width:'150px', disable_search:true});
  $(".date").datepicker();

 	$(".tracking_log").submitWithAjax();
	$("#form_holder").find(".edit_log").submitWithAjax();

	$(".button").button();
	$(".activate_project").activate_projects();
	$(".reopen_project").reopen_project();
 //  $(".background_style_color").css({"background-color":$("input.background_style").val()})
 //  $(".text_style_color").css({"background-color":$("input.text_style").val()})
 //  $(".background_style").keyup(function(){
 //  	var val_input = this.value
 //  $(".background_style_color").css({"background-color":val_input})

	// });
 //  $(".text_style").keyup(function(){
 //  	var val_input = this.value
 //  $(".text_style_color").css({"background-color":val_input})

	// });


 $("input.membership").membership();
 $(".register_firm").validateNoSubmit();
 $(".first_user").validateNoSubmit();


   // $(".slider_range").slider({
        // range: true,
        // min: 0,
        // max: 1439,
        // values: [ 740, 1020 ],
        // step:10,
        // slide: slideTime
    // });

//non-ajax search
  $("input#id_search_list").quicksearch('ul#cus_pro_us_listing li', {});

})
