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
		function drawFunc(resolve) {
			function draw(timestamp) {
				if(last === null) last = timestamp;
				var xDelta = Math.pow(timestamp - last, 2) * rate;
				last = timestamp;
				drawingContext.fillStyle = color;
				drawingContext.fillRect(x, 0, x + xDelta + 1, height);
				x+=xDelta;
				if(x < width){
					requestAnimationFrame(draw);
				} else {
					resolve(5);
				}
			}
			return draw;
		}
		return drawFunc;
	}

	function stripes(drawingContext, cWidth, cHeight, stripeWidth, rate) {
		var numStripes =  cWidth / stripeWidth;
		var x = 0;
		var y = 0;
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
		function drawFunc(resolve){
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
				} else {
					resolve(5);
				}
			}
			return draw;
		}
		return drawFunc;
	}

	function Circle(x, y, radius, color) {
		this.radius = radius;
		this.center = {
			"x" : x,
			"y" : y
		};
		this.angleFilled = 0;
		this.color = color || randColor();
	}

	function CircleByBox(x0, y0, x1, y1, color) {
		var radius = ((x1 - x0) / 2) - ((x1 - x0) / 16);
		var x = (x1 - x0) / 2 + x0;
		var y = (y1 - y0) / 2 + y0;
		return new Circle(x, y, radius);
	}

	function circleSweep(ctx, angleRate, width, height, exp) {
		var last = null;
		var circles = [];
		var numCircles = Math.pow(4, exp);
		var boxWidth = (width / Math.sqrt(numCircles));
		var boxHeight = (height / Math.sqrt(numCircles));
		for(i = 0; i < numCircles; i++) {
			var x0 = boxWidth * (i % Math.sqrt(numCircles));
			// var y0 = boxHeight * i;
			var y0 = boxHeight * (Math.floor(i / Math.sqrt(numCircles)));
			// i is which box, height
			circles.push(new CircleByBox(x0, y0, x0 + boxWidth, y0 + boxHeight));
		}
		function drawFunc(resolve) {
			function draw(timestamp) {
				if(last === null) last = timestamp;
				var angleDelta = (timestamp - last) * angleRate;
				var circlesRemaining = circles.length;
				while(circlesRemaining > 0) {
					var circle =  circles.shift();
					circlesRemaining--;
					ctx.fillStyle = circle.color;
					ctx.beginPath();
					ctx.moveTo(circle.center.x, circle.center.y);
					var yD0 = (circle.radius * Math.sin(circle.angleFilled)) + circle.center.y;
					var xD0 = (circle.radius * Math.cos(circle.angleFilled)) + circle.center.x;
					ctx.lineTo(xD0, yD0);
					ctx.arc(circle.center.x, circle.center.y, circle.radius, circle.angleFilled, circle.angleFilled + angleDelta, false);
					ctx.moveTo(circle.center.x, circle.center.y);
					ctx.fill();
					ctx.closePath();
					circle.angleFilled += (angleDelta * 0.2);
					if(circle.angleFilled < Math.PI * 2) {
						circles.push(circle);
					}
				}
				last = timestamp;
				if(circles.length > 0) {
					requestAnimationFrame(drawFunc(resolve));
				} else {
					resolve(5);
				}
			}
			return draw;
		}
		return drawFunc;
	}

	$(document).ready(function() {
		var canvas = $("#screen").get(0);
  	var canvas2DContext = canvas.getContext("2d");
  	var width = canvas.width;
  	var xLayers = width / 2;
  	var height = canvas.height;
  	var imageData = canvas2DContext.createImageData(width, height);
  	var drawingQueue = [];

  	function queueAnimation(drawFunc) {
			var p = new Promise(function(resolve, reject) {
				requestAnimationFrame(drawFunc(resolve));
			});
  		p.then(function(){
  			if(drawingQueue.length > 0) {
	  			var next = drawingQueue.shift();
  				queueAnimation(next);
  			}
  		});
		}

  	$("#spiral-btn").click(function() {
			var draw = spiralDrawing(canvas2DContext, xLayers, 0.05);
	 		requestAnimationFrame(draw);
  	});
  	$("#wash-btn").click(function(){
  		var draw = stripes(canvas2DContext, width, height, 20, 0.5);
  		requestAnimationFrame(draw);
  	});
  	$("#right-btn").click(function(){
  		var draw = washRight(canvas2DContext, width, height, randColor(), 0.05);
  		requestAnimationFrame(draw);
  	});
  	$("#circles-btn").click(function(){
	  	drawingQueue.push(washRight(canvas2DContext, width, height, randColor(), 0.06));
  		drawingQueue.push(circleSweep(canvas2DContext, 0.03, width, height, 1));
	  	drawingQueue.push(washRight(canvas2DContext, width, height, randColor(), 0.07));
	  	drawingQueue.push(circleSweep(canvas2DContext, 0.03, width, height, 2));
	  	drawingQueue.push(washRight(canvas2DContext, width, height, randColor(), 0.08));
	  	drawingQueue.push(circleSweep(canvas2DContext, 0.03, width, height, 3));
	  	drawingQueue.push(washRight(canvas2DContext, width, height, randColor(), 0.09));
	  	drawingQueue.push(circleSweep(canvas2DContext, 0.03, width, height, 4));
			drawingQueue.push(spiralDrawing(canvas2DContext, xLayers, 0.05));

			queueAnimation(circleSweep(canvas2DContext, 0.03, width, height, 0));
  	});
	});
});