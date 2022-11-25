function roster_done_box(){
	$(".roster_done_box").on("click", function() { 
  	 var id = $(this).attr("id")
  	 $("#roster_edit_done_todo_" + id).submitDoneWithAjax(id)
  });
}
function kookka(n){
	var ala = n
	return ala
} 
$(document).ready(function() {	
		roster_done_box() 
	 	$( "#accordion" ).accordion({
              heightStyle: "content"
        });
		$(".task_accordion").one("click", function(){
			$.getScript("/roster_task")
		});
		
		$(".milestone_accordion").one("click", function(){
			$.getScript("/roster_milestone")
		});
	



	$('.far_right_container_min').show();
	$('.far_right_container').hide().css({"top": "50px",  "right": "50px" });

	$('.far_right_container').draggable(
		{handle: ".far_right_container_max", 
		 cursor: "move"});	
		
	
	$('.open_chatbox').click(function(){
		$('.far_right_container').toggle();
			$('.far_right_container_min').toggle();
        
        });
});