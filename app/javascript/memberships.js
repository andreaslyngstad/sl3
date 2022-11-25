function droppable_members(){
	$(".draggable").draggable({
	  	containment: '#users_list',
	  	revert: true,
	  	opacity: 0.7
	  	});
    $("#members").droppable({
  		accept: ".not_member",
      	drop: function(event,ui) { 
	      	NProgress.start();;
	      	ui.draggable.addClass("member")
	      	ui.draggable.removeClass("not_member") 
	      	ui.draggable.draggable( 'option', 'revert', false );
		    var user_id =  ui.draggable.attr("user_id");
		    var project_id = ui.draggable.attr("project_id");
		  	$.post("/membership/" + user_id + "/" + project_id);
          	 }
    });
    $("#not_members").droppable({
		accept: ".member",
  		drop: function(event,ui) { 
      	NProgress.start();; 
      	ui.draggable.addClass("not_member")
      	ui.draggable.removeClass("member")  
      	ui.draggable.draggable( 'option', 'revert', false );
      	$("#not_members").find(".user_info:last")
	    var user_id =  ui.draggable.attr("user_id");
	    var project_id = ui.draggable.attr("project_id"); 
	  	$.post("/membership/" + user_id + "/" + project_id + "?membership=false");
		}
    });
}