function prepareAndCallJson(){
		var url 	= $("#stats").val()
		var from 	= $("#from_stat").val() 
		var to 		= $("#to_stat").val()
		var klass = $("#range_date_fields_graphs").data("klass")
		var id 		= $("#range_date_fields_graphs").data("id")
		var ColorArray = eval(url + "ColorArray")
		$("#stacked svg").empty();
		$("#pie svg").empty()
		$("#legend").empty()
    	$.getJSON('/' + url + '.json', {from: from, to: to, klass: klass, id: id}, function(data) {
  				stackedAndPie(data, ColorArray)     
 		})
    } 
jQuery.fn.fixDateformat = function() {
  this.each(function(i, el) {
    ar = $(el).text().split("/");
    output = [ar[1], ar[0], ar[2]].join(".");
    $(el).text(output);
  });
  return this;
};
	

$(document).ready(function() {
	$("text[x='0']").fixDateformat()	
	var from = $(".one_month_back").data("lastmonth") 
	var to = $(".one_month_back").data("today")
	$("#from_stat").val(from)
	$("#to_stat").val(to)
	$(".range_date_graphs").datepicker({
		onSelect: function() {
			prepareAndCallJson()
  		}
		}).attr( 'readOnly' , 'true' )
	
	$("#stats").change(function() {
		prepareAndCallJson()
	});
	
});
