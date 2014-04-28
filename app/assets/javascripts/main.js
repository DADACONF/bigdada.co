require.config();

require([], function() {
	function setPixel(imageData, x, y, r, g, b, a) {	
		var index = (x + y * imageData.width) * 4;
		imageData.data[index + 0] = r;
		imageData.data[index + 1] = g;
		imageData.data[index + 2] = b;
		imageData.data[index + 3] = a;
	}

	function drawLayer(imageData, layer, layers, thickness) {
			// print top
			for(var x = layers - layer; x < layers + layer - 1; x++) {
				setPixel(imageData, x, layers - layer, 200, 200, 200, 255);	
  		};
  		// print right
  		for(var y = layers - layer; y < layers + layer; y++) {
				setPixel(imageData, layers + layer - 1, y, 200, 200, 200, 255);	
  		}
  		// print bottom
  		for(var x = layers + layer - 1; x >= layers - layer; x--) {
				setPixel(imageData, x, layers + layer - 1, 200, 200, 200, 255);	  			
  		}
  	 	// print left
			for(var y = layers + layer - 1; y >= layers - layer; y--) {
			 	setPixel(imageData, layers - layer, y, 200, 200, 200, 255);	  			
  	 	}  		
	}

	function drawSpirals(imageData, canvas2DContext, currentLayer, totalLayers) {
		if(currentLayer <= totalLayers) {
			//Draw and make a recursive call
			drawLayer(imageData, currentLayer, totalLayers);
			//canvas2DContext.putImageData(imageData, 0, 0);
			var thickness = 1;
			setTimeout(function(){
					drawSpirals(imageData, 
											canvas2DContext, 
											currentLayer + thickness, 
											totalLayers, 
											thickness);
			}, 50);
		} 
	}


	$(document).ready(function() {
		var canvas = $("#screen").get(0);
  	var canvas2DContext = canvas.getContext("2d");
  	var width = canvas.width;
  	var xLayers = width / 2;
  	var height = canvas.height;
  	var imageData = canvas2DContext.createImageData(width, height);

  	drawSpirals(imageData, canvas2DContext, 0, xLayers);
  	setInterval(function(){
  		canvas2DContext.putImageData(imageData, 0, 0);
  	}, 1);
	});
});