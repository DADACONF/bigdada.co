dadaApp = angular.module('dada', []);

dadaApp.directive 'processing', () =>
  scope: true
  link: (scope, iElement, iAttrs) => 
    scope.$sketch = new Processing(iElement[0], scope[iAttrs.processing])


dadaApp.controller 'SketchController', ($scope) =>
  class Fill
    constructor: (@r, @g, @b) ->

  class Circle 
    constructor: (@radius, @fill, @stroke, @weight, @x, @y, @text) ->

  blackFill = () => new Fill(240, 240, 240)
  whiteFill = () => new Fill(10, 10, 10)
  black = true
  text = "BIG~DADA"
  circles = for i in [0..7]
    fill = switch
      when i < 4 and i % 2 is 0 then whiteFill()
      when i < 4 and i % 2 is 1 then blackFill()
      when i >= 4 and i % 2 is 1 then whiteFill()
      else blackFill()
    y = if i <= 3 then 60 else 180
    x = (120 * (i % 4) + 60)
    new Circle(100, fill, 1, 2, x, y, text.slice(i, i+1))  
  
  COLOR_RATIO = (2 * Math.PI) / 60.0  
    
  colorSin = (base, period) => 
    (time) => 
      value = ((period * time) + base) * COLOR_RATIO
      Math.sin(value) * 255.0

  redSin = colorSin(0, .17)
  greenSin = colorSin(0, .07)
  blueSin = colorSin(0, .11)

  drawCircle = (sketch, circle, frame) =>
    red = redSin(frame)
    green = greenSin(frame)
    blue = blueSin(frame)
    sketch.strokeWeight(circle.weight)
    sketch.stroke(circle.stroke)
    sketch.fill(red, green, blue)
    sketch.ellipse(circle.x, circle.y, circle.radius, circle.radius)
    sketch.fill(255 - blue, 255 - green, 255.0 - red)
    sketch.textSize(36)
    sketch.text(circle.text, circle.x - 9, circle.y + 12)

    
  $scope.sketch = (sketch) => 
    lastFrame = 0

    sketch.setup = () =>
      sketch.size(480, 240)
      sketch.frameRate(30)
    
    sketch.draw = () =>
      # frameDelta = sketch.frameCount - lastFrame  
      console.log("frame: " + sketch.frameCount)
      sketch.background(240)
      drawCircle(sketch, circle, sketch.frameCount) for circle in circles 
