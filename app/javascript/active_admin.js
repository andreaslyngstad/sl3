//= require active_admin/base
"//= require nvd3/lib/d3.v2" 
//= require jquery.xcolor.min
//= require nvd3/src/core
//= require nvd3/src/utils
//= require nvd3/src/models/axis
//= require nvd3/src/tooltip
//= require nvd3/src/models/legend
//= require nvd3/src/models/axis
//= require nvd3/src/models/scatter
//= require nvd3/src/models/stackedArea
//= require nvd3/src/models/stackedAreaChart
//= require nvd3/src/models/pie
//= require nvd3/src/models/pieChart
//= require nvd3/src/models/line
//= require nvd3/src/models/lineWithFocusChart

//= require nvd3/src/models/discreteBar
//= require nvd3/src/models/discreteBarChart
//= require colorArrays
//= require stackedAndPie

function firmBySubscription(data) {
nv.addGraph(function() {
   var chart = nv.models.discreteBarChart()
       .x(function(d) { return d.label })
       .y(function(d) { return d.value})
       .showValues(true)
       .color($.xcolor.analogous("#31a354",20,20))
       chart.yAxis
 			.tickFormat(d3.format(''));
   d3.select('#chart svg')
       .datum(data)
 	   .transition().duration(500)
       .call(chart);

   nv.utils.windowResize(chart.update);

   return chart;
 });
}
function firmByCreation(data) {
nv.addGraph(function() {
  var chart = nv.models.stackedAreaChart()
		.x(function(d) { return d[0] })
	    .y(function(d) { return d[1] })

  chart.xAxis
      .tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) });
  // chart.x2Axis
      // .tickFormat(function(d) { return d3.time.format('%x')(new Date(d))});

  d3.select('#stacked svg')
      .datum(data)
    .transition().duration(500)
      .call(chart);

  nv.utils.windowResize(chart.update);

  return chart;
});

}

function firmResorses(data) {
nv.addGraph(function() {
  var chart = nv.models.lineWithFocusChart()
		.x(function(d) { return d[0] })
	    .y(function(d) { return d[1] })

  chart.xAxis
      .tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) });
  chart.x2Axis
      .tickFormat(function(d) { return d3.time.format('%x')(new Date(d))});

  d3.select('#resorses svg')
      .datum(data)
    .transition().duration(500)
      .call(chart);

  nv.utils.windowResize(chart.update);

  return chart;
});
};
function newFirms(data) {
nv.addGraph(function() {
  var chart = nv.models.lineWithFocusChart()
		.x(function(d) { return d[0] })
	    .y(function(d) { return d[1] })

  chart.xAxis
      .tickFormat(function(d) { return d3.time.format('%x')(new Date(d)) });
  chart.x2Axis
      .tickFormat(function(d) { return d3.time.format('%x')(new Date(d))});

  d3.select('#new_firms svg')
      .datum(data)
    .transition().duration(500)
      .call(chart);

  nv.utils.windowResize(chart.update);

  return chart;
});

}
$(document).ready(function() {
  var pathname = window.location.pathname;
  if (/dashboard/i.test(pathname)){

	$.getJSON('/obeqaslksdssdfnfdfysdfxm/dashboard/subscription_chart_data.json', function(data) {
  				firmBySubscription(data)
		})
	$.getJSON('/obeqaslksdssdfnfdfysdfxm/dashboard/firms_chart_data.json', function(data) {
  				firmByCreation(data)
		})

	$.getJSON('/obeqaslksdssdfnfdfysdfxm/dashboard/firms_resources_chart_data.json', function(data) {
  				firmResorses(data)
		})
	$.getJSON('/obeqaslksdssdfnfdfysdfxm/dashboard/new_firms_count_chart_data.json', function(data) {
  				newFirms(data)
		})}
})
