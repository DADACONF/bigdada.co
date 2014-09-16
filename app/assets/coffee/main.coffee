dadaApp = angular.module('dada', []);

dadaApp.directive 'processing', () =>
  scope: true
  link: (scope, iElement, iAttrs) => 
    scope.$sketch = new Processing(iElement[0], scope[iAttrs.processing])


dadaApp.controller 'SketchController', ["$scope", ($scope) =>
  COLOR_RATIO = (2 * Math.PI) / 30.0
  GRAVITY_VECTOR = new PVector(0, -0.005)  
  PADDING =  5
  class Fill
    constructor: (@r, @g, @b) -> 

  class Force
    constructor: (@theta, @acceleration) ->

  class Circle 
    constructor: (@radius, @fill, @stroke, @weight, @x, @y, @text, @velocityVector) -> 

    move: (time, sketch) ->
      @x = sketch.constrain(@x + (@velocityVector.x * time), 0 + (@radius / 2) + PADDING, 960 - (@radius / 2) - PADDING)
      @y = sketch.constrain(@y + (@velocityVector.y * time), 0 + (@radius / 2) + PADDING, 720 - (@radius / 2) - PADDING)

    impulse: (forceVector, time, sketch) ->
      forceDelta = forceVector.get()
      forceDelta.mult(time)
      @velocityVector.add(forceDelta)
      this.move(time, sketch)

  text = "BIGDADA"

  circles = for i in [0..6]
    fill = new Fill(0, 0, 0)
    y = 640
    x = (120 * (i) + 60)
    new Circle(115, fill, 1, 2, x, y, text.slice(i, i+1), new PVector(0,0))  
  


  colorSin = (base, period) => 
    (time) => 
      value = ((period * time) + base) * COLOR_RATIO
      Math.sin(value) * 255.0

  redSin = colorSin(200, .34)
  greenSin = colorSin(200, .14)
  blueSin = colorSin(200, .22)

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
      sketch.size(960, 720)
      sketch.frameRate(30)
    
    sketch.draw = () =>
      frameDelta = sketch.frameCount - lastFrame  
      sketch.background(210)
      drawCircle(sketch, circle, sketch.frameCount) for circle in circles 
]