textBufferModule = angular.module('TextBufferModule', [])

# textBufferModule.directive 'textBuffer', ['textBufferObj', (textBufferObj) => 
# 	scope: true
# 	link: (scope, iElement, iAttrs) =>
# 		canvas = iElement[0]
# 		if(canvas.tagName is not 'canvas')
# 			throw exception;
# 		scope.$canvas = iElement[0] 
# 		scope.$buffer = new textBufferObj.textBuffer(canvas, "BIGDADA")
# ]

textBufferModule.factory 'TextBuffer', () =>
	HEIGHT=200
	WIDTH=500
	sizes = [12,18,24,30, 36]
	class TextBuffer
		constructor: (@canvas, @text) ->
			canvas.width = WIDTH
			canvas.height = HEIGHT
			@context = canvas.getContext("2d")

		drawText: (size, index) -> 	
				@context.font = "bold " + size + "px sans-serif"
				@context.fillText(@text, 0, HEIGHT - ((sizes.length - index) * 40))

		init: () ->
			@context.textBaseline = "top"
			for size, index in sizes 
				@drawText(size, index)


	createBuffer: (c) -> 
		new TextBuffer(c, "BIGDADA")



  