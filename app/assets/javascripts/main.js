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

  	function washRight(drawingContext, height, width, color, rate) {
		var last = null;
		var x = 0;
		function draw(timestamp) {
			if(last === null) last = timestamp;
			var xDelta = Math.pow(timestamp - last, 2) * rate;
			last = timestamp;
			drawingContext.fillStyle = color;
			drawingContext.fillRect(x, 0, x + xDelta + 1, height);
			x+=xDelta;
			if(x < width){
				requestAnimationFrame(draw);
			}
		}
		return draw;
	}

	function stripes(drawingContext, cWidth, cHeight, stripeWidth, rate) {
		var numStripes =  cWidth / stripeWidth;
		var x = 0;
		var y = 0;
		// var increment = 60;
		var yDirection = 1;
		var last = null;
		var color = randColor();

		function updateY(yDirection, xPos) {
			return [-yDirection, xPos + stripeWidth, randColor()];
		}

		function draw(timestamp){
			var updated = null;
			if(last === null) last = timestamp;
			var increment = (timestamp - last) * 1.5;
			last = timestamp;
			drawStripe(drawingContext,
								x,
								y,
								stripeWidth,
								increment * yDirection,
								color);
			y = Math.floor(y + increment * yDirection);
			if(y < 0) {
				y = 0;
				updated = updateY(yDirection, x);
				yDirection = updated[0];
				x = updated[1];
				color = updated[2];
			} else if(y > cHeight) {
				y = cHeight;
				updated = updateY(yDirection, x);
				yDirection = updated[0];
				x = updated[1];
				color = updated[2];
			}
			if(x <= cWidth) {
				requestAnimationFrame(draw);
			}
		}
		return draw;
	}

	function drawStripe(drawingContext, x, y, stripeWidth, increment, color) {
		drawingContext.fillStyle = color;
		if(increment < 0) {
			drawingContext.fillRect(x, y + increment, stripeWidth, Math.abs(increment) + 1);
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
			last = timestamp;
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

	function circleSweep(ctx, rate) {
		var last = null;
		var circles = [
			{
				radius: 50,
				center: { x: 250, y : 250},
				angleFilled: 0
			}
		];

		function draw(timestamp) {
			if(last === null) last = timestamp;
			var angleDelta = (timestamp - last) * rate;
			for(var i = 0; i < circles.length; i++) {
				ctx.fillStyle = randColor();
				var circle = circles[i];
				ctx.beginPath();
				ctx.moveTo(circle.center.x, circle.center.y);
				var yD0 = (circle.radius * Math.sin(circle.angleFilled)) + circle.center.y;
				var xD0 = (circle.radius * Math.cos(circle.angleFilled)) + circle.center.x;
				ctx.lineTo(xD0, yD0);	
				ctx.arc(circle.center.x, circle.center.y, circle.radius, circle.angleFilled, circle.angleFilled + angleDelta, false);
				ctx.moveTo(circle.center.x, circle.center.y);
				ctx.fill();
				circle.angleFilled += angleDelta;
				circle.radius += 15;
			}
			last = timestamp;
			requestAnimationFrame(draw);
		}

		return draw;
	}

	$(document).ready(function() {
		var canvas = $("#screen").get(0);
  	var canvas2DContext = canvas.getContext("2d");
  	var width = canvas.width;
  	var xLayers = width / 2;
  	var height = canvas.height;
  	var imageData = canvas2DContext.createImageData(width, height);

  	$("#spiral-btn").click(function() {
			var rate = 0.5;
			var draw = spiralDrawing(canvas2DContext, xLayers, rate);
	 		requestAnimationFrame(draw);
  	});

  	$("#wash-btn").click(function(){
  		var draw = circleSweep(canvas2DContext, 0.01);
  		// var draw = stripes(canvas2DContext, width, height, 20, 0.5);
  		requestAnimationFrame(draw);
  	});
  	$("#right-btn").click(function(){
  		var draw = washRight(canvas2DContext, width, height, randColor(), 0.05);
  		requestAnimationFrame(draw);
  	});

	});
});