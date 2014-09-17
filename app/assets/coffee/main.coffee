dadaApp = angular.module('dada', ['sketch'])

dadaApp.controller 'SketchController', ["$scope", "fills", ($scope, fills) =>
  GRAVITY_VECTOR = new PVector(0, -0.009)
  BOUNCE_DECAY = 0.65  
  PADDING =  5
  HORIZONTAL = new PVector(-1.0,0)
  VERTICAL = new PVector(0,1)
  WIDTH = 480
  HEIGHT = 720
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
      xRightbound = WIDTH - (@radius / 2) - PADDING
      yUpperbound = 0 + (@radius / 2) + PADDING
      yLowerbound = HEIGHT - (@radius / 2) - PADDING

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

  text = "BIGDADA"

  circles = for i in [0..6]
    fill = new Fill(0, 0, 0)
    y = 600
    x = WIDTH / 2.0
    # x = ((120 * i) + 60)
    new Circle(90, fill, 1, 2, x, y, text.slice(i, i+1), new PVector((Math.random() - 0.5)*2, Math.random()))
  

  redSin = fills.colorSin(200, .34)
  greenSin = fills.colorSin(200, .14)
  blueSin = fills.colorSin(200, .22)

  drawCircle = (sketch, circle, frame) =>
    red = redSin(frame)
    green = greenSin(frame)
    blue = blueSin(frame)
    circle.impulse(GRAVITY_VECTOR, 10, sketch)
    sketch.strokeWeight(circle.weight)
    sketch.stroke(circle.stroke)
    sketch.fill(red, green, blue)
    sketch.ellipse(circle.x, circle.y, circle.radius, circle.radius)
    sketch.fill(255 - blue, 255 - green, 255.0 - red)
    sketch.textSize(64)
    sketch.text(circle.text, circle.x - 20, circle.y + 20)

  $scope.sketch = (sketch) => 
    lastFrame = 0

    sketch.setup = () =>
      sketch.size(WIDTH, HEIGHT)
      sketch.frameRate(30)
    
    sketch.draw = () =>
      frameDelta = sketch.frameCount - lastFrame  
      sketch.background(210)
      drawCircle(sketch, circle, sketch.frameCount) for circle in circles 
]