textBufferModule = angular.module('TextBufferModule', [])

textBufferModule.factory 'TextBuffer', () =>
	HEIGHT=200
	WIDTH=500
	tahoma8bold = new Image()
	tahoma8bold.src = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAoEAAAANAgMAAACr0FyhAAAABlBMVEX///8AAABVwtN+AAACSUlEQVR4Xu3VQYrjQAwF0C+w9m6Q7qOC1P4LSve/yiA7cUK6p2mGmd38hVMKmHpIdhl/If8jAYAQwrpQ/OsE7jFkrzVXwIDt0CRBZFy0p1ABAzP0XX/FpaScnqVl6mMxozcZpUuXU1dl5JiqZswKpaJkYXeWltJHVMiGcAFCKDaCLYRdwi4uoYOfhJBvhWPCzCQMpgrLES7JKVNNzQwql5ASZn2HgiaBQz2wy6b9K7saSh7CHQbsgDyFJEag46NkOUtHOTPH9GTF0ZbUXMwxrbd15mihPoUl4TPXZ6HSQ8NMIaFyCK2FN7952S1v2DY1sQmD1oTtilehNVuv/uSY4DWc2VsdpVmZxCUEc5TC1LMM3ssl8bHSH0KnSrBkmoSHo4WKtdFHwZTMW7Yw8rZ2EdKag0ZtLYxXIQEq4AL4Kay7cL0I6SPIUmPJknjpoZuewp2pU+Yydeo6hbUkFOsQGnQncoSZeQu3XekfE1CL5tQpxCmstaDBpgKbAWMAPIWhXwg1D2G1UKXyEupjyjtSphx/E3YKuZQqPISE+mohzdDCWmI4hAroOeVLeD2HZw8NiPVJOF+FaKHJGL2DxCG0pzBHC3EX2ik0kNYrHFdVkHchN2OtD8NooQSuKYsiB96fw3s8zzdlSp20FvJ4U+ix/CH0jLyfNqFl6pPMauEohZ5zRsVDWKH0UWOBHgV2NYA9lEdnZBES/J0QJAxvaTRfCns7dr4N8ZNU7CG4cgkxwQ3P8/DryDogfyh0/DQvwuubghtiQ7Ug+Sb8BYH3sjwcbInrAAAAAElFTkSuQmCC'
	tahoma8bold.c = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789!@#$%^&*()-=[]\\;\',./_+{}|:"<>?`~'
	tahoma8bold.w = [7,7,6,7,7,4,7,7,3,4,7,3,11,7,7,7,7,5,6,5,7,7,9,7,7,6,8,7,7,8,6,6,8,8,5,6,7,6,10,7,8,7,8,8,7,7,8,7,11,7,7,7,3,7,7,7,7,7,7,7,7,7,7,3,10,9,7,13,9,9,7,5,5,5,9,5,5,6,3,3,3,3,6,7,9,7,7,7,3,6,9,9,6,6,10]
	tahoma8bold.h = 15

	class TextBuffer
		constructor: (@canvas, @text) ->
			canvas.width = WIDTH
			canvas.height = HEIGHT
			@context = canvas.getContext("2d")

		drawText: (size, index) -> 	
				@context.font = "bold " + size + "px sans-serif"
				# @context.fillText(@text, 0, HEIGHT - ((sizes.length - index) * 40))

		init: () ->
			@context.textBaseline = "top"
			@context.drawString('BIG DADA', tahoma8bold,  50, 100)


	createBuffer: (c) -> 
		new TextBuffer(c, "BIGDADA")



  