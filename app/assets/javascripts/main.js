require.config();

require([], function() {
	window.requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame ||
                              window.webkitRequestAnimationFrame || window.msRequestAnimationFrame;

	function randColor() {
		var r = Math.random() * 256 | 0;
    var g = Math.random() * 256 | 0;
    var b = Math.random() * 256 | 0;
    return 'rgba(' + r + "," + g + "," + b + "," + 255.0 + ")";
  }

	function washUpAndWashDown(drawingContext, cWidth, cHeight, stripeWidth, intervalLength) {
		var color = randColor();
		var numStripes =  cWidth / stripeWidth;
		var increment = 60;
		var x0 = 0;
		var y0 = 0;
		function updateY() {
			increment = -increment;
			x0 = (x0 + stripeWidth) % cWidth;
			color = randColor();
		}

		var intervalId = setInterval(function() {
			washDown(drawingContext,
								x0,
								y0,
								stripeWidth,
								increment,
								color);
			y0 += increment;
			if(y0 < 0) {
				y0 = 0;
				updateY();
			} else if(y0 > cHeight) {
				y0 = cHeight;
				updateY();
			}
		}, intervalLength);
		return intervalId;
	}

	function washDown(drawingContext, x, y, stripeWidth, increment, color) {
		drawingContext.fillStyle = color;
		if(increment < 0) {
			drawingContext.fillRect(x, y + increment, stripeWidth, Math.abs(increment));
		} else {
			drawingContext.fillRect(x, y, stripeWidth, increment);
		}
	}

	function drawLayer(drawingContext, layer, layers, color) {
			drawingContext.fillStyle = color;
			var x0 =  layers - layer;
			var x1 = layers + layer;
			var y0 = layers - layer;
			var y1 = layers + layer;
			var length = layer * 2;
			drawingContext.fillRect(x0, y0, length, 1);
			drawingContext.fillRect(x0, y1, length + 1, 1);
			drawingContext.fillRect(x0, y0, 1, length);
			drawingContext.fillRect(x1, y0, 1, length);
	}

	function spiralDrawing(canvas2DContext, layers, rate) {
		var last = null;
		var layer = 0;
		function draw(timestamp) {
			if(last === null) last = timestamp;
			var layersDelta = (timestamp - last) * rate;
			for(l = layer; l < layer + layersDelta; l++) {
				drawLayer(canvas2DContext, l, layers, randColor());
			}
			layer += layersDelta;	
			if(layer < layers) 
			{
				requestAnimationFrame(draw);
			}
		}
		return draw;	
	}

	function bindToClick(element, intervals, drawFunction) {
		element.click(function() {
			if(intervals.length == 1) {
				clearInterval(intervals.pop());
			}
			intervals.push(drawFunction());
		});
	}
	
	function stop(intervals) {
		while(intervals.length > 0) {
			console.log(intervals);
			clearInterval(intervals.pop());
		}
	}


	$(document).ready(function() {
		var canvas = $("#screen").get(0);
  	var canvas2DContext = canvas.getContext("2d");
  	var width = canvas.width;
  	var xLayers = width / 2;
  	var height = canvas.height;
  	var imageData = canvas2DContext.createImageData(width, height);
  	var intervals = [];

  	$("#spiral-btn").click(function() {
			var rate = 0.01;
			var draw = spiralDrawing(canvas2DContext, xLayers, rate);
	 		requestAnimationFrame(draw);
  	});

  	bindToClick($("#wash-btn"), intervals, function(){
  		return washUpAndWashDown(canvas2DContext, width, height, 11, 20);
  	});

  	$("#stop-btn").click(function(){
  		stop(intervals);
  	});
	});
});