
# String::contains = (it) ->
#   @indexOf(it) isnt -1

# showTabs = ->
#   url = window.location.hash
#   if url isnt ""
#     id = (url)
#     get_url = $("a[href=\"" + url + "\"]").attr("data-url")
#     $("#html_tabs li.active").removeClass "active"
#     $("#html_tabs li a.current_link").removeClass "current_link"
#     url and $("a[href=\"" + url + "\"]").parent().addClass("active")
#     url and $("a[href=\"" + url + "\"]").addClass("current_link")
#     $(id).siblings().addClass "hide"
#     $(id).removeClass "hide"
#     $(".has_url").children().remove()
#     if typeof (get_url) isnt "undefined"
#       NProgress.start();
#       $.get get_url
#   else
#     $("#html_tabs li:first").addClass "active"
#     $("#html_tabs li:first a").addClass "current_link"
#     get_url = $("#html_tabs li:first").find("a").attr("data-url")
#     NProgress.start();
#     $.get get_url

spendingsTab = ->
	# $("input#id_search_list").quicksearch "ul#cus_pro_us_listing li", {}
	# $(".currency_to_convert").text ->
 #  value = parseFloat($(this).attr("data-amount"))
 #  currency_converter value
	# $(".seconds").html secondsToString($(".seconds").data("hours"), $(".current_firm_data").data("timeformat"))

logsTab = ->

usersTab = ->
	droppable_members()
projectsTab = ->

milestonesTab = ->
	$("#dialog_milestone").UIdialogs_links();
	$('.date_format_setter').set_date_format()
	$(".open_milestone_update").UIdialogs_edit_links();
invoicesTab = ->


statisticsTab = ->
	unless $("#stats").length is 0
  	$("#from_stat").val $(".one_month_back").data("lastmonth")
  	$("#to_stat").val $(".one_month_back").data("today")
  	prepareAndCallJson()

dashboardTab = ->
	unless $("#dashboard_charts").length is 0
  	prepareAndCallDashboardJson()

econimoc_statisticsTab = ->
	unless $("#ecominc_statistics_charts").length is 0
		prepareAndCallEconomicStatisticsJson()

currentLink = ->
	path = location.pathname.split('/')
	route = path[path.length - 1]
	$('#html_tabs').find('.tab_' + route).addClass('current_link')

$(document).ready ->
	console.log("jasdhklf")
	econimoc_statisticsTab()
	currentLink()
	spendingsTab()
	usersTab()
	invoicesTab()
	milestonesTab()
	sQuadLink.todosTab()
	projectsTab()
	logsTab()
	statisticsTab()
	dashboardTab()
#   pathname = location.pathname
#   if pathname.match(/customers\//i) or pathname.match(/projects\//i) or pathname.match(/users\//i)
#     showTabs()
#     $("#html_tabs ul li a").click ->
#       url = window.location.hash
#       getUrl = $(this).attr("data-url")
#       title = $(this).attr('href');
#       # History.pushState({ state:getUrl, url: getUrl, target: getUrl }, title, title);

#       console.log("popstate", window.History.getState(), window.location.href);
#       id = (url)
#       get_url = $(this).attr("data-url")
#       $("#html_tabs li.active").removeClass "active"
#       $("#html_tabs li a.current_link").removeClass "current_link"
#       $(this).parent().addClass("active")
#       $(this).addClass("current_link")
#       $(id).siblings().addClass "hide"
#       $(id).removeClass "hide"
#       $(".has_url").children().remove()
#       if typeof (get_url) isnt "undefined"
#         NProgress.start();
#         $.get get_url


#   if pathname.match(/charts/i)
#     from = $(".one_month_back").data("lastmonth")
#     to = $(".one_month_back").data("today")
#     $.getJSON "/users_logs.json",
#       from: from
#       to: to
#     , (data) ->
#       stackedAndPie data, users_logsColorArray
