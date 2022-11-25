function stackedAndPie(data, ColorArray) {
  var labels = data.stacked.map(function(d){return d.key});
	var pieIdIncrement = labels.length;
	$("text[x='0']").fixDateformat()
	if(!Array.prototype.last) {
    Array.prototype.last = function() {
        return this[this.length - 1];
    }
  }
	data.stacked.map(function(d){
		});
	
	function disableSetter(area, id, graph, label){
	  var dot = $("#" + id +".node .legend_dot")
	  d3.select("#nv-series-" + id).attr("data", function(d){
	    if(!(d3.select(area).selectAll(".nv-series").data().filter(function(e) { return !e.disabled }).length === 1))
	    {
	      d.disabled = !d.disabled;
	      dot.toggleClass("disabled")
	    }else
	    {
	      d.disabled = false;
	      dot.removeClass("disabled")
	    }
	    graph.update()
	    })
	};
	
	function pieDisableSetter(area, stacked_svg, pie_svg){
		
			var click = 'elementClick'
			area.pie.dispatch.on(click, function(e) {
				console.log("click")
	    	var id = e.index
	    	var dot = $("#" + id +".node .legend_dot")
        	var data = d3.select(stacked_svg).selectAll(".nv-series").data()
        	var piedata = d3.select(pie_svg).selectAll(".nv-series").data()
        if (data.filter(function(d) { return !d.disabled }).length === 1){
          	piedata = piedata.map(function(d) {
            d.disabled = false;
          return d
          });
          	data = data.map(function(d) {
            d.disabled = false; 
          	$(".legend_dot").removeClass("disabled")
            return d
          });
        }else{
        	piedata = piedata.map(function(d, i) {
        		console.log("click2")
          	d.disabled = (i != e.index);
          	return d
          		});
          	data = data.map(function(d,i) {
            d.disabled = (i != e.index);
           	$(".legend_dot").addClass("disabled")
           	dot.removeClass("disabled")
            return d 
          	});
       		}
       	pie_chart.update();
        stacked_chart.update();
          });
		};	
		function stackDisableSetter(area, stacked_svg, pie_svg){
			var click = 'areaClick.toggle'
	  		area.stacked.dispatch.on(click, function(e) {
	    	var id = e.seriesIndex
	    	var dot = $("#" + id +".node .legend_dot")
        	var data = d3.select(stacked_svg).selectAll(".nv-series").data()
        	var piedata = d3.select(pie_svg).selectAll(".nv-series").data()
        if (data.filter(function(d) { return !d.disabled }).length === 1){
          	piedata = piedata.map(function(d) {
            d.disabled = false;
          return d
          });
          	data = data.map(function(d) {
            d.disabled = false; 
          	$(".legend_dot").removeClass("disabled")
            return d
          });
        }else{
        	piedata = piedata.map(function(d, i) {
          	d.disabled = (i != e.seriesIndex);
          	return d
          		});
          	data = data.map(function(d,i) {
            d.disabled = (i != e.seriesIndex);
           	$(".legend_dot").addClass("disabled")
           	dot.removeClass("disabled")
            return d 
          	});
       		}
       	pie_chart.update();
        stacked_chart.update();
          });
	  		
	  	}
	nv.addGraph(function() {
	    var chart = nv.models.stackedAreaChart()
	   				  .margin({top: 10, bottom: 30, left: 40, right: 10})
	                  .showControls(false)
	                  .showLegend(true)
	                  .style('stacked')
	                  .x(function(d) { return d[0] })
	                  .y(function(d) { return d[1] })
	                  .color(ColorArray)
	                  .clipEdge(true)
	                  .interpolate("cardinal");
	    
	    chart.xAxis
	        .showMaxMin(false)
	        .tickFormat(function(d) { return d3.time.format(set_date_format_str())(new Date(d)) });
	     
	    chart.yAxis
	        .tickFormat(d3.format(','));
	  	
	    d3.select('#stacked svg')
	        .datum(data.stacked)
	        .transition().duration(500).call(chart);
	    d3.selectAll(".nv-series").each(function(d,i) { 
	    d3.select(this).attr("id", function() { return 'nv-series-' + i }) 
	      }); 
	     
	   stacked_chart = chart
	   
	   stackDisableSetter(stacked_chart, "#stacked svg","#pie svg")        
	   return chart; 
	});
  
	
  
	  nv.addGraph(function() {
	  var chart = nv.models.pieChart()
	      .x(function(d) { return d.label })
	      .y(function(d) { return d.value })
	      .showLegend(true)
	      .margin({top: 10, bottom: 30, left: 40, right: 10})
	      .color(ColorArray)
	      .showLabels(false);
	
	    d3.select("#pie svg")
	      .datum(data.pie)
	      .transition().duration(500).call(chart);
	    d3.selectAll(".nv-area").each(function(d,i) { 
	    d3.select(this).attr("id", function() { return i })
	      });
	    d3.selectAll(".nv-series").each(function(d,i) { 
	    d3.select(this).attr("id", function() { return 'nv-series-' + i })
	      
	      });
	  //hide original legend
	    d3.selectAll(".nv-legendWrap").style("display","none")
	  pie_chart = chart
	  pieDisableSetter(pie_chart, "#stacked svg","#pie svg")
	  
	  return chart;
	});

	
//draw new legend
	var div = d3.select("#legend").append("div").attr("class", "labels");
	var li = div.selectAll("li")
	   .data(labels)
	   .enter()
	   .append("li")
	       .attr('id', function(d, i) { return   i  }) 
	       .attr('class', 'node');
	       
	       
	       
	var lidiv = li.append("div")
	         .attr('class', 'legend_dot')
	       
	lidiv.append("svg")
	        .attr("width", "20px")
	        .attr("height", "20px")
	    .append("circle")
	        .attr("r", 8)
	        .attr("cx", 10)
	        .attr("cy", 10)
	        .style('stroke-width', 2)
	        .style('fill', (function(d, i){ return ColorArray[i] }))
	        .style('stroke', (function(d, i){ return ColorArray[i] }));
	li.append("div")
	    .attr('class', 'legend_text')  
	    .text(function(d) { return jQuery.trim(d).substring(0, 30).trim(this) });
	
	d3.selectAll(".labels .node").on("click", function(d) {
	    var id = $(this).attr("id");
	    var pieId = parseInt(id) + parseInt(pieIdIncrement)  
	     disableSetter("#stacked svg", id, stacked_chart)
	     disableSetter("#pie svg", pieId, pie_chart)   
	 });
	
	
}

