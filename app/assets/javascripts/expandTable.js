$(document).ready(function(){		
	var profileIsOpen = true;
	var tableIsOpen = false;
	
	$(".x_box.profile").click(function() {
		check_Open(profileIsOpen, 895, ".profile");
		profileIsOpen = !profileIsOpen;
	});
	
	$(".x_box.table").click(function() {
		check_Open(tableIsOpen, 775, ".table");
		tableIsOpen = !tableIsOpen;
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
});