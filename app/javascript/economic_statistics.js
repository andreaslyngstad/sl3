function prepareAndCallEconomicStatisticsJson(){
		var url 	= $("#stats").val()
		from = $(".one_month_back").data("lastmonth")
   	to = $(".one_month_back").data("today")
		var klass = $("#range_date_fields_graphs").data("klass")
		var id 		= $("#range_date_fields_graphs").data("id")
		// var ColorArray = customer_users_logsColorArrayColorArray
		$("#stacked svg").empty();
		$("#pie svg").empty()
		$("#legend").empty()
    	$.getJSON('/economicstatistics_json.json', {from: from, to: to, klass: klass, id: id}, function(data) {
  				income_by_month(data)   
 		})
    } 