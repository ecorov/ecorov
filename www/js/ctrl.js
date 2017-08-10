// password to control ECOROV
function pwd () {
    // tianhd
	if (md5($( "#ctrlpwd" )[0].value) == "8caf447c1cd0db7adbec6c890eb82c70") {
		$( "#CtrlPannel" ).css( "display", "block" ) 
		$( "#CtrlPwd" ).css( "display", "none" ) 
	} else {
		$( "#CtrlPwd" ).css( "display", "none" ) 
		alert("You can't control this ROV, but you can receive its video stream");
	}
}


// Get video streaming
var domain = 'http://' + document.domain
$("#webcam").attr('src', domain + ":8080/javascript_simple.html"); 


// LED control
$( "#led_button" ).on('click', function() {
	var led = $('#led_button img').attr('src');
	if (led.match(/led-1/g) != null) {
		$.ajax({
			type: 'GET',
			dataType: 'jsonp',
			url: domain + '/ecorov.py?led=on'
		});	
		$('#led_button img').attr('src', "img/led-0.png");
	} else {
		$.ajax({
			type: 'GET',
			dataType: 'jsonp',
			url: domain + '/ecorov.py?led=off'
		});	
		$('#led_button img').attr('src', "img/led-1.png");
	}
});



// Camera control
$('#image_button img').attr('src', "img/camera-1.png");
$( "#image_button" ).on('click', function() {
	var src_icon = $('#image_button img').attr('src');
	if (src_icon == "img/camera-1.png") {
		$.ajax({
			type: 'GET',
			dataType: 'jsonp',
			url: domain + '/ecorov.py?cam=im'
		});	
        // read status_mjpeg.txt
        var tt = setInterval(function(){
            $.ajax({
                async: false,
                type: 'GET',
                url: "status_mjpeg.txt",
                success: function(data){
                    console.log(data)
                    if (data == "ready") {
                        $('#image_button img').attr('src', "img/camera-1.png");
                    } else {
                        $('#image_button img').attr('src', "img/camera-0.png");
                        clearInterval(tt)
                    }
                }
            })
          },100);
	}
});





















// Propeller control
var pwmLft0 = 1000
var pwmRgt0 = 1000
$("#ctrlrod").draggable ({
	containment : "#boundary",
	revert: "invalid",
	revertDuration: 10,
	drag: function() {	
		var x = Number($("#ctrlrod").css("left").replace("px", "")) - 120
		var y = Number($("#ctrlrod").css("top" ).replace("px", "")) - 120
		if (y < 0) {
			var v0 = parseInt(Math.abs(y))
			var v1 = parseInt(Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2)))
			var scale = 2
			if (x < 0) {
				var pwmLft = v1*scale + 1000
				var pwmRgt = v0*scale + 1000
			} else {
				var pwmLft = v0*scale + 1000
				var pwmRgt = v1*scale + 1000
			}
			console.log(pwmLft)
			console.log(pwmRgt)
			var pwmLft1 = Math.floor(pwmLft/10) * 10
			var pwmRgt1 = Math.floor(pwmRgt/10) * 10
			
			if (pwmLft1 != pwmLft0) {
				pwmLft0 = pwmLft1
				$("#debug").text('Left: '+ pwmLft1);
				$.ajax({
					type: 'GET',
					dataType: 'jsonp',
					url: domain + '/ecorov.py?lft='+pwmLft1
				});	
			}
			if (pwmRgt1 != pwmRgt0) {
				pwmRgt0 != pwmRgt1
				$("#debug").text('Right: ' + pwmRgt1);
				$.ajax({
					type: 'GET',
					dataType: 'jsonp',
					url: domain + '/ecorov.py?rgt=' + pwmRgt1
				});	
			}
		} else {
			$("#debug").text('Left: '+ 1000 + '   &   Right: ' + 1000);
			$.ajax({
				type: 'GET',
				dataType: 'jsonp',
				url: domain + '/ecorov.py?lft=1000&rgt=1000'
			});	
		}
	},
	stop: function () {
		$("#debug").text('Left: '+ 1000 + '   &   Right: ' + 1000);
		$.ajax({
			type: 'GET',
			dataType: 'jsonp',
			url: domain + '/ecorov.py?lft=1000&rgt=1000'
		});				
	}
});


// Step-motor control
var p0
$( "#slider" ).slider({
	orientation: "vertical",
	min:0,
	max:380,
	value: 200,
	start: function() {
		p0 = $( "#slider" ).slider( "value" )
		console.log(p0)
	}, 
	stop: function() {
		var step = $( "#slider" ).slider( "value" )-p0
		$("#debug").text('Current:' + $( "#slider" ).slider( "value" ) + "; moved: " + step);
		$.ajax({
			type: 'GET',
			dataType: 'jsonp',
			url: domain + '/ecorov.py?stp=' + step
		});	
		console.log(domain + '/ecorov.py?stp=' + step)
	}
});




$("#showsys").on('click', function() {
	if ($( "#syscmd" ).css( "display" ) == "none") {
		$( "#syscmd" ).css( "display", "block" ) 
  } else if ($( "#syscmd" ).css( "display" ) == "block") {
		$( "#syscmd" ).css( "display", "none" ) 
  }
});

