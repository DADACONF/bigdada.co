dadaApp = angular.module('dada', []);

dadaApp.directive 'processing', () =>
  scope: true
  link: (scope, iElement, iAttrs) => 
    scope.$sketch = new Processing(iElement[0], scope[iAttrs.processing])


dadaApp.controller 'SketchController', ($scope) =>
  class Fill
    constructor: (@r, @g, @b) ->

  class Circle 
    constructor: (@radius, @fill, @stroke, @weight, @x, @y) ->

  blackFill = () => new Fill(255, 255, 255)
  whiteFill = () => new Fill(0, 0, 0)

  circles = for i in [0..7]
    fill = if(i % 2 is 0) then blackFill() else whiteFill()
    y = if i > 3 then 100 else 200
    x = 50 + (100 * (i % 4))
    new Circle(80, fill, 1, 2, x, y)  

  drawCircle = (sketch, circle) =>
    sketch.strokeWeight(circle.weight)
    sketch.stroke(circle.stroke)
    sketch.fill(circle.fill.r, circle.fill.g, circle.fill.b)
    sketch.ellipse(circle.x, circle.y, circle.radius, circle.radius)

  $scope.sketch = (sketch) => 
    console.log "Hello World!"

    sketch.setup = () =>
      sketch.size(500, 400)
      sketch.frameRate(60)
    
    sketch.draw = () =>
      sketch.background(255)
      drawCircle(sketch, circle) for circle in circles 
      fill = new Fill(255, 0, 0)
      console.log("fucl")
      circle =  new Circle(80, fill, 255, 5, 50, 50)
      # drawCircle(sketch, circles[0])  
