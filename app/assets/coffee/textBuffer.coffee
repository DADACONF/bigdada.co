textBufferModule = angular.module('textBufferModule', [])

textBufferModule.directive 'textBuffer', ['textBufferObj', (textBufferObj) => 
	scope: true
	link: (scope, iElement, iAttrs) =>
		canvas = iElement[0]
		console.log("link")
		if(canvas.tagName is not 'canvas')
			throw exception;
		scope.$canvas = iElement[0] 
		scope.$buffer = new textBufferObj.TextBuffer(canvas, "BIGDADA")
]

textBufferModule.factory 'textBufferObj', () =>
	class TextBuffer
		constructor: (@canvas, @text) ->
			console.log("hello!")
			canvas.width = 200
			canvas.height = 200

		init: () ->
			@context.font = "bold 12px sans-serif";
			@context.fillText(@text, 0, 0);
		context: -> @canvas.getContext("2d")
	textBufferObj = 
		textBuffer: TextBuffer	

  