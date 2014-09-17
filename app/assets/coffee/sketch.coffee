# Infrastructure for bridging processing to AngularJS

sketch = angular.module('sketch', [])

sketch.directive 'processing', () =>
  scope: true
  link: (scope, iElement, iAttrs) => 
    scope.$sketch = new Processing(iElement[0], scope[iAttrs.processing])

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
	PADDING = 5
	BOUNCE_DECAY = 0.65

	class Fill
    constructor: (@r, @g, @b) -> 
	
	class Force
    constructor: (@theta, @acceleration) ->

  class Circle
    constructor: (@radius, @fill, @stroke, @weight, @x, @y, @text, @velocityVector) -> 

    move: (time, sketch) ->
      newX =  @x + (@velocityVector.x * time)
      newY =  @y + (@velocityVector.y * time)
      xLeftbound = 0 + (@radius / 2) + PADDING
      xRightbound = sketch.width- (@radius / 2) - PADDING
      yUpperbound = 0 + (@radius / 2) + PADDING
      yLowerbound = sketch.height - (@radius / 2) - PADDING

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

    impulse: (forceVector, time, sketch) ->
      forceDelta = forceVector.get()
      forceDelta.mult(time)
      @velocityVector.add(forceDelta)
      this.move(time, sketch)

  shapes = 
  	Force: Force
  	Circle: Circle
  	Fill: Fill
)

