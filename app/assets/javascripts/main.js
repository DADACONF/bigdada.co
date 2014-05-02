require.config();

require([], function() {
	function randColor() {
		var r = Math.random() * 256 | 0;
    var g = Math.random() * 256 | 0;
    var b = Math.random() * 256 | 0
    return 'rgba(' + r + "," + g + "," + b + "," + 255.0 + ")";
  }

	function washUpAndWashDown(drawingContext, cWidth, cHeight, stripeWidth, color) {
		var numStripes =  cWidth / stripeWidth;
		washDown(drawingContext, 0,  stripeWidth, 0, cWidth, cHeight, 60, randColor());
	}

	function washDown(drawingContext, x, stripeWidth, y, cWidth, cHeight, increment, color) {
		drawingContext.fillStyle = color;
		if(increment < 0) {
			drawingContext.fillRect(x, y + increment, stripeWidth, Math.abs(increment));			
		} else {
			drawingContext.fillRect(x, y, stripeWidth, increment);
		}

		if(y >= 0 && y <= cHeight) {
			setTimeout(function() {
			washDown(drawingContext,
							 x, 
							 stripeWidth,
							 y + increment,
							 cWidth,
							 cHeight,
							 increment,
							 color);
			}, 5);
		} else if(x < cWidth){
			var startingY; 
			if(increment > 0) {
				startingY = cHeight;
			} else {
				startingY = 0;
			};
			washDown(drawingContext,
							 x + stripeWidth,
							 stripeWidth, 
							 startingY,
							 cWidth,
							 cHeight,
							 -increment,
							 randColor());			
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

	function drawSpirals(imageData, canvas2DContext, totalLayers) {
		var currentLayer = 0;
		var intervalId = setInterval(function(){
			drawLayer(imageData, currentLayer, totalLayers, randColor());
			currentLayer = (currentLayer + 1)	% (totalLayers + 1);
		}, 5);
		return intervalId;
	}

	$(document).ready(function() {
		var canvas = $("#screen").get(0);
  	var canvas2DContext = canvas.getContext("2d");
  	var width = canvas.width;
  	var xLayers = width / 2;
  	var height = canvas.height;
  	var imageData = canvas2DContext.createImageData(width, height);
  	// washUpAndWashDown(canvas2DContext, width, height, 11, randColor());
  	var spiralInterval = drawSpirals(canvas2DContext, canvas2DContext, xLayers);
  	$("#spiral-control").click(function() {
	  	clearInterval(spiralInterval);
	  });
	});
});