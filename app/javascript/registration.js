//= require jquery
//= require jquery_ujs
"// = require jquery.turbolinks"
//= require jquery.ui.core
//= require jquery.ui.position
//= require jquery.ui.widget
//= require external/chosen.jquery.min
//= require_self
//= require turbolinks

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery.fn.validates_uniqe = function(){
 	$(this).keyup(function(){
 	var value = $(this).val().toLowerCase();
 	if (value.length == 0){
	$(".signup-form-field-subdomain em").remove();
 	$(".signup-form-field-subdomain").append("<em class='error'>This field is required.</em>");
 	}
 	else if (/^[a-z0-9]+$/i.test(value) == false){
 	$(".signup-form-field-subdomain em").remove();
 	$(".signup-form-field-subdomain").append("<em class='error'>No spesial charaters or spaces.</em>");

 	}else{
 	$(".signup-form-field-subdomain em").remove();
 	$(".signup-form-field-subdomain").append("<em class='check'>Cheking..</em>");
 	$.get("/validates_uniqe/" + value);
 	}
 	});
};

jQuery.fn.open_not_required = function(){
	 $(this).click(function(){
  	$(".not_required").slideToggle();
  	$(".open_not_required").toggleClass("close_not_required");
  	// event.preventDefault();
  });
};


$(document).ready(function() {
	if (document.all && !document.addEventListener ) {
    alert('Hello and welcome to squadlink! We are really happy to have you here.\n\nSadly we are not happy about you browser.\nThe browser is the application you use to view internet sites. You are using Internet Explorer version 8 or older.\nThis browser will not work well in the squadlink application.\n\nPlease upgrade your browser to the newest Internet Explorer version.\nAlternatively  you can use a different browser like Chrome, Firefox or Opera.');
	}
	if (document.all && document.documentMode && 8 >= document.documentMode) {
    alert('Hello and welcome to squadlink! We are really happy to have you here.\n\nSadly we are not happy about you browser.\nThe browser is the application you use to view internet sites. You are using Internet Explorer version 8 or Internet Explorer version 9 and higher in Internet Explorer 8 compatibility mode \nThis will not work well in the squadlink application.\n\nPlease upgrade your browser to the newest Internet Explorer version.\nAlternatively  you can use a different browser like Chrome, Firefox or Opera.');

	}
	$(".start").hover(function(){
		$(this).toggleClass("on")
	})
	$(".start").on("click", function(){
		$(this).hide();
		$(".play_a_video").hide();
		$(".video_container").show();
		$(".video_container").addClass("on")
		$(".video_container").append('<iframe src="http://player.vimeo.com/video/30698649?title=0&amp;byline=0&amp;portrait=0&autoplay=1&byline=0" width="640" height="360" frameborder="0" webkitAllowFullScreen allowFullScreen></iframe>')

	})
	var box = $('.hide');
        var link = $('#login_link');

        link.click(function() {
            box.slideDown(); return false;
        });

        $(document).click(function() {
            box.slideUp();
        });

        box.click(function(e) {
            e.stopPropagation();
        });


	$(".register_firm_subdomain").validates_uniqe();
	$(".open_not_required_container").open_not_required();
	$(".signup select, .update select").chosen({width:364});
})
