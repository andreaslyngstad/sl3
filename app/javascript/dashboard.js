function prepareAndCallDashboardJson(){
		var url 	= $("#stats").val()
		from = $(".one_month_back").data("lastmonth")
   	to = $(".one_month_back").data("today")
		var klass = $("#range_date_fields_graphs").data("klass")
		var id 		= $("#range_date_fields_graphs").data("id")
		// var ColorArray = customer_users_logsColorArrayColorArray
		$("#stacked svg").empty();
		$("#pie svg").empty()
		$("#legend").empty()
    	$.getJSON('/dashboard_json.json', {from: from, to: to, klass: klass, id: id}, function(data) {
  				dashboardPie(data)  
  				income_by_month(data)   
 		})
    } 
function dashboardPie(data){ 

nv.addGraph(function() {
	  var chart = nv.models.pieChart()
	      .x(function(d) { return d.label })
	      .y(function(d) { return d.value })
	      .showLegend(false)
	      .margin({top: 0, bottom: 0, left: 0, right: 0})
	      .color(customer_users_logsColorArray)
	      .donut(true)
	      .showLabels(true)
	      .noData($.jsi18n.messages.no_data);
	    d3.select("#project_pie svg")
	      .datum(data.project_pie)
	      .transition().duration(500).call(chart);
	    d3.selectAll(".nv-area").each(function(d,i) { 
	    d3.select(this).attr("id", function() { return i })
	      });
	    d3.selectAll(".nv-series").each(function(d,i) { 
	    d3.select(this).attr("id", function() { return 'nv-series-' + i })
	      
	      });
	  //hide original legend
	    // d3.selectAll(".nv-legendWrap").style("display","none")
	  // pie_chart = chart
	  // pieDisableSetter(pie_chart, "#stacked svg","#pie svg")
	  return chart;
	});
nv.addGraph(function() {
	  var chart = nv.models.pieChart()
	      .x(function(d) { return d.label })
	      .y(function(d) { return d.value })
	      .showLegend(false)
	      .margin({top: 0, bottom: 0, left: 0, right: 0})
	      .color(users_logsColorArray)
	      .donut(true)
	      .noData($.jsi18n.messages.no_data)
	      .showLabels(true);
	
	    d3.select("#user_pie svg")
	      .datum(data.user_pie)
	      .transition().duration(500)
	      .call(chart);
	    
	  //hide original legend
	    // d3.selectAll(".nv-legendWrap").style("display","none")
	  // pie_chart = chart
	  // pieDisableSetter(pie_chart, "#stacked svg","#pie svg")
	  return chart;
	});

}
function income_by_month(data){ 
	nv.addGraph(function() {
    var chart = nv.models.multiBarChart()
		  .margin({top: 10, bottom: 30, left:0, right: 10})
      .showControls(false)
      .showLegend(false)
      // .style('stacked')
      .x(function(d) { return d[0] })
      .y(function(d) { return d[1] })
      .clipEdge(true)
      .delay(3)
      .showYAxis(false)
      .rightAlignYAxis(true)
      .color(customers_logsColorArray)
      .noData($.jsi18n.messages.no_data)
      .tooltips(true)
      .tooltip(function(key, x, y, e, graph) {
        return '<p>' + x + ': ' +  y + '</p>'
      })
      // .interpolate("cardinal");
		    
  chart.xAxis
    .showMaxMin(false)
    
  chart.yAxis
    
	
  d3.select('#income_stack svg')
      .datum(data.income_stack)
      .transition().duration(500).call(chart);
  d3.selectAll(".nv-series").each(function(d,i) { 
  d3.select(this).attr("id", function() { return 'nv-series-' + i }) 
    }); 
   
 stacked_chart = chart
 
 // stackDisableSetter(stacked_chart, "#stacked svg","#pie svg")        
 return chart; 
	});
}
$(document).ready(function() {
	$(".db_done_box").on("click", function() { 
  	 var id = $(this).attr("id")
   	 $("#db_edit_done_todo_" + id).submitDoneWithAjax(id)
    })
 });