
// console.log(baseurl)
$(document).ready(function() {
// 	//old_url = $.param(baseurl, location.href, 2);
old_url = location.protocol + '//' + location.host + location.pathname;

	var text = 	old_url.match(/customers/i) ||
							old_url.match(/projects/i) ||
							old_url.match(/archive/i) ||
							old_url.match(/users/i) ||
							old_url.match(/invoices/i) ||
							old_url.match(/home/i) ||
							old_url.match(/logs/i)||
							old_url.match(/index/i)

	var text2 = old_url.match(/reports/i) ||
							old_url.match(/squadlink_report/i) ||
							old_url.match(/timesheet_week/i) ||
							old_url.match(/account/i) ||
							old_url.match(/dashboard/i) ||
							old_url.match(/home_user/i) ||
							old_url.match(/charts/i) ||
							old_url.match(/subscriptions/i) ||
							old_url.match(/plans/i) ||
							old_url.match(/payments/i) ||
							old_url.match(/firm_edit/i)||
							old_url.match(/firm_update/i) ||
							old_url.match(/timesheet_day/i)||
							old_url.match(/timesheet_month/i)||
							old_url.match(/logs/)

	var text3 = old_url.match(/invoices/i) ||
							old_url.match(/statistics/i)

	on_overview = old_url.match(/reports/i) ||
								old_url.match(/squadlink_report/i) ||
								old_url.match(/account/i) ||
								old_url.match(/dashboard/i) ||
								old_url.match(/charts/i) ||
								old_url.match(/plans/i) ||
								old_url.match(/payments/i) ||
								old_url.match(/subscriptions/i)



// console.log(location.pathname)
console.log( text)

	if (!(text2 == null)){
		var tab_text = text2.toString().charAt(0).toUpperCase() + text2.toString().substr(1);
		$("#html_tabs_home a.current_link").removeClass("current_link");
		$("#html_tabs_home a[data-name*='" + tab_text + "']").addClass("current_link");
		if(tab_text == "Charts" ){$("#html_tabs a[data-name*='Statistics']").addClass("current_link");}
		if(tab_text == "Account" ){$("#html_tabs a[data-name*='Account']").addClass("current_link");}
		if(tab_text == "Firm_edit" ){$("#html_tabs a[data-name*='Account']").addClass("current_link");}
		if(tab_text == "Firm_update" ){$("#html_tabs a[data-name*='Account']").addClass("current_link");}
		if(tab_text == "Reports" ){$("#html_tabs a[data-name*='Reports']").addClass("current_link");}
		if(tab_text == "Dashboard" ){$("#html_tabs a[data-name*='Dashboard']").addClass("current_link");}
		if(tab_text == "Squadlink_report" ){$("#html_tabs a[data-name*='Reports']").addClass("current_link");}

		if(tab_text == "Timesheet_day" || tab_text == "Logs"){$("#day_link").addClass("current");$(".tab_logs").addClass("current_link") ;}
		if(tab_text == "Timesheet_week" ){$("#week_link").addClass("current");$(".tab_logs").addClass("current_link") ;}
		if(tab_text == "Timesheet_month" ){$("#month_link").addClass("current");$(".tab_logs").addClass("current_link") ;}

		if(tab_text == "Plans" ){$("#html_tabs a[data-name*='Plan']").addClass("current_link");}
		if(tab_text == "Payments" ){$("#html_tabs a[data-name*='Payments']").addClass("current_link");}
		if(tab_text == "Subscriptions" ){$("#html_tabs a[data-name*='Plan']").addClass("current_link");}
	}
	if (!(text3 == null)){
		var tab_text = text3.toString().charAt(0).toUpperCase() + text3.toString().substr(1);
		if(tab_text == "Invoices" ){$("#html_tabs a[data-name*='Invoices']").addClass("current_link");}
		if(tab_text == "Statistics" && text == null ){$("#html_tabs a[data-name*='Statistics']").addClass("current_link")
																	$('#navigation li#invoices_navi').addClass("current_main");}
	}
	if (!(text == null)){

			cap_text = text.toString();


		$('#navigation li#' + cap_text +'_navi').addClass("current_main")
		if(cap_text == "archive"){
			$('#navigation li#projects_navi').addClass("current_main")
		}
		if(cap_text == "index"){
			$('#navigation li#logs_navi').addClass("current_main")
		}
		}
	if(on_overview != null){
			$('#navigation li#home_navi').addClass("current_main")
		}
	if (location.pathname == "/"){
		$('#navigation li#logs_navi').addClass("current_main")
		$("#day_link").addClass("current")
	}
  $('#navigation li').click(function(e) {
   $('#navigation li').removeClass("current_main")
   $(this).addClass('current_main')
		});
  $("#active_projects").button();
  $("#archive").button().on('click', function(e) {
  	var href =	$(this).attr("href");
  	$("#pointer-text").text(text);
  });
	$(".back_button").button();
});


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
