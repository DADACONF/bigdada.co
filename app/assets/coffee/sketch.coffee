# Infrastructure for bridging processing to AngularJS

sketch = angular.module('sketch', [])

sketch.directive 'processing', ['sketchObj', (sketchObj) =>
  scope: true
  link: (scope, iElement, iAttrs) => 
    scope.$sketch = new sketchObj.Sketch(new Processing(iElement[0], scope[iAttrs.processing]))
]

sketch.factory 'sketchObj', () => 
	class Sketch extends Processing
		constructor: (@canvas, @process) ->
			super(@canvas, @process)
	sketchObj = 		
		Sketch: Sketch		

sketch.factory('fills', () =>
  COLOR_RATIO = (2 * Math.PI) / 30.0
  fills = 
		colorSin: (base, period) => 
  	  (time) => 
    	  value = ((period * time) + base) * COLOR_RATIO
      	Math.sin(value) * 255.0
)

sketch.factory('shapes', () =>  
	HORIZONTAL = new PVector(-1.0,0)
	VERTICAL = new PVector(0,1)
	PADDING = 1
	BOUNCE_DECAY = 0.65

	class Fill
    constructor: (@r, @g, @b) -> 

  class Circle
    constructor: (@diameter, @fill, @stroke, @weight, @x, @y, @text, @velocityVector) -> 

    move: (time, sketch) ->
      newX =  @x + (@velocityVector.x * time)
      newY =  @y + (@velocityVector.y * time)
      xLeftbound = 0 + (@diameter / 2) + PADDING
      xRightbound = sketch.width- (@diameter / 2) - PADDING
      yUpperbound = 0 + (@diameter / 2) + PADDING
      yLowerbound = sketch.height - (@diameter / 2) - PADDING
      #move code that changes directions outside of this. 
      switch
        when newY <= yUpperbound or newY >= yLowerbound
          incidence = PVector.angleBetween(@velocityVector, VERTICAL)
          incidence = if @velocityVector.x < 0 then -1 * incidence else incidence
          @velocityVector.rotate(Math.PI + 2 * incidence)
          @velocityVector.mult(BOUNCE_DECAY)
        when newX <= xLeftbound or newX >= xRightbound
          incidence = PVector.angleBetween(@velocityVector, HORIZONTAL)
          incidence = if @velocityVector.y > 0 then -1 * incidence else incidence
          @velocityVector.rotate(-1.0 * (Math.PI + 2 * incidence))
          @velocityVector.mult(BOUNCE_DECAY)

      @x = sketch.constrain(newX, xLeftbound, xRightbound)
      @y = sketch.constrain(newY, yUpperbound, yLowerbound)

    boundingRectangle: () ->
    	left: @x - (@diameter / 2)
    	top: @y - (@diameter / 2)
    	width: @diameter 
    	height: @diameter   
    	circle: this

    impulse: (forceVector, time, sketch) ->
      forceDelta = forceVector.get()
      forceDelta.mult(time)
      @velocityVector.add(forceDelta)
      this.move(time, sketch)

    shrink: () =>
      @diameter = .99 * @diameter

  shapes = 
  	Circle: Circle
  	Fill: Fill
)

