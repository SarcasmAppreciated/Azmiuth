$(document).ready(function(){		
	var profileIsOpen = true;
	var tableIsOpen = false;
	var pageWidth = $(document).width();
	
	if(pageWidth < 1200)
		$(".slide_span.profile").css('width','10');		

	$(".x_box.profile").click(function() {
		if(pageWidth > 1050)
			check_Open(profileIsOpen, 895, ".profile");
		else
			check_Open(profileIsOpen, 10, ".profile");
		profileIsOpen = !profileIsOpen;
	});
	
	$(".x_box.table").click(function() {
		if(pageWidth > 1050)
			check_Open(tableIsOpen, 775, ".table");
		else
			check_Open(tableIsOpen, 10, ".table");
		tableIsOpen = !tableIsOpen;
	});
	
	$(document).scroll(function(){
		if($(document).scrollTop() > 25) {
			$("#zoom_holder").appendTo("#header").addClass("zoom_header");
		}
		else
			$("#zoom_holder").prependTo("#map_wrapper").removeClass("zoom_header");
	});
	
	append_Table();
	
	function check_Open(isOpen, x, y){
		if(isOpen) {
			expand_Table(10,0,0,y);
			$(".sensitive" + y).fadeOut("fast");						
		}
		else {
			expand_Table(x,250,45,y)
			$(".sensitive" + y).fadeIn("slow");
		}
	}				
	
	function expand_Table(x, y, z, a) {
		$(".slide_span" + a + "").animate({width: x + "px" }, "fast",function(){
			$(".x_box" + a + "").css({
				 '-moz-transform':'rotate(' + z + 'deg)',
				 '-webkit-transform':'rotate(' + z + 'deg)',
				 '-o-transform':'rotate(' + z + 'deg)',
				 '-ms-transform':'rotate(' + z + 'deg)',
				 'transform':'rotate(' + z + 'deg)'
			});
		});
		$(".table_box" + a + "").animate({height: y + "px" }, "slow",function(){});
	}
	
	function append_Table() {
		for(var i = 0; i < icebergs.length; i++) {
			$(".coordinate_table").append("<li class='coordinate sensitive table'>" + icebergs[i].latitude +  ", " + icebergs[i].longitude +  "</li>");
		}
	}
	
	append_Tweets();
	function append_Tweets() {
		var tweets = users[0];
		if ((tweets != null) &&(tweets.length != 0)){
			for(var i = 0; i < tweets.length; i++)
			{
			$(".profile_horizontal.tweets").append("<div class='tweet_box'><p class='tweet_time_loc'>" + tweets[i].time_stamp + " \[" + tweets[i].latitude + ", " + tweets[i].longitude + "\]</p><p class='tweet_text'>" + tweets[i].tweet_text + "</p></div>");			
			}
		}
	}
});