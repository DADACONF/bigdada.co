require.config();

require([], function() {
	function setPixel(imageData, x, y, color) {	
		var index = (x + y * imageData.width) * 4;
		if(color.length < 4) {
			throw "Color array requires 4 values: [r, g, b, a]!"
		}
		imageData.data[index + 0] = color[0];
		imageData.data[index + 1] = color[1];
		imageData.data[index + 2] = color[2];
		imageData.data[index + 3] = color[3];
	}

	function randColorArray() {
		var r = Math.random() * 256 | 0;
    var g = Math.random() * 256 | 0;
    var b = Math.random() * 256 | 0;
		return [r,g,b,255];
	}

	function randColor() {
		var r = Math.random() * 256 | 0;
    var g = Math.random() * 256 | 0;
    var b = Math.random() * 256 | 0
    return 'rgba(' + r + "," + g + "," + b + "," + 255.0 + ")";
  }


	function washUpAndWashDown(drawingContext, cWidth, cHeight, stripeWidth, color) {
		var numStripes =  cWidth / stripeWidth;
		washDown(drawingContext, 0,  stripeWidth, 0, cWidth, cHeight, 60, randColor());
		// washDown(drawingContext, stripeWidth, stripeWidth, cHeight, cHeight, - 10, randColor());
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

	function drawBitLayer(imageData, layer, layers, color) {		
			// print top
			for(var x = layers - layer; x < layers + layer - 1; x++) {
				setPixel(imageData, x, layers - layer, color);	
  		};
  		// print right
  		for(var y = layers - layer; y < layers + layer; y++) {
				setPixel(imageData, layers + layer - 1, y, color);	
  		}
  		// print bottom
  		for(var x = layers + layer - 1; x >= layers - layer; x--) {
				setPixel(imageData, x, layers + layer - 1, color);	  			
  		}
  	 	// print left
			for(var y = layers + layer - 1; y >= layers - layer; y--) {
			 	setPixel(imageData, layers - layer, y, color);	  			
  	 	}  		
	}

	function drawSpirals(imageData, canvas2DContext, currentLayer, totalLayers) {
		if(currentLayer > totalLayers) {
			currentLayer = 0;
		}
		drawBitLayer(imageData, currentLayer, totalLayers, randColorArray());
		setTimeout(function(){
					drawSpirals(imageData, canvas2DContext, currentLayer + 1, totalLayers);
		}, 5);
	}

	$(document).ready(function() {
		var canvas = $("#screen").get(0);
  	var canvas2DContext = canvas.getContext("2d");
  	var width = canvas.width;
  	var xLayers = width / 2;
  	var height = canvas.height;
  	var imageData = canvas2DContext.createImageData(width, height);
  	washUpAndWashDown(canvas2DContext, width, height, 11, randColor());
  	// drawSpirals(imageData, canvas2DContext, 0, xLayers);
  	// setInterval(function(){
  		// canvas2DContext.putImageData(imageData, 0, 0);
  	// }, 50);
	});
});