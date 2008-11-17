	function wait_DIV() {
		var DHTML = (document.getElementById || document.all || document.layers);
		if (!DHTML) return;
			var x = gv_getObj("waitDiv");
			x.visibility = 'visible';  
			if(! document.getElementById) {
				if(document.layers) {
					alert("7");
					x.left=280/2;
				}
			}
		return true;
	}
	function gv_getObj(name) {
		if (document.getElementById) {
			return document.getElementById(name).style;
		} else if (document.all) {
			return document.all[name].style;
		} else if (document.layers) {
			return document.layers[name];
		}
	}
	function previous_page()
	{
		if(current_page > 1){
			var current = "";
			if(((current_page - 1) + "").length == 1)
				current = "0" + (current_page - 1);
			wait_DIV();
			window.location.href="../CH" + current + "/IView_l.htm";
		}
	}
	function next_page()
	{
		if(current_page < 50){
			var current = "";
			if(((current_page + 1) + "").length == 1)
				current = "0" + (current_page + 1);
			wait_DIV();
			window.location.href="../CH" + current + "/IView_l.htm";
		}
	}