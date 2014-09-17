dadaApp = angular.module('dada', ['sketch'])

dadaApp.controller 'SketchController', ["$scope", "fills", "shapes", ($scope, fills, shapes) =>
  GRAVITY_VECTOR = new PVector(0, -0.009)
  WIDTH = 600
  HEIGHT = 720
  text = "BIGDADA"

  circles = for i in [0..6]
    fill = new shapes.Fill(0, 0, 0)
    y = 600
    x = (((WIDTH / 7.0) * i) + (WIDTH / 15.0))
    new shapes.Circle(70, fill, 1, 2, x, y, text.slice(i, i+1), new PVector(0, Math.random()))
  
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

  $scope.flip = () =>
    GRAVITY_VECTOR.rotate((Math.PI / 2))  

  $scope.sketch = (sketch) => 
    lastFrame = 0

    sketch.setup = () =>
      sketch.size(WIDTH, HEIGHT)
      sketch.frameRate(30)
    
    sketch.draw = () =>
      frameDelta = sketch.frameCount - lastFrame  
      # Draw background first
      # Draw angles
      sketch.background(235)
      lines =  8
      for i in [0..lines]
        deltaX = sketch.width / lines
        deltaY = sketch.height / 40.0
        startX = deltaX * i
        for j in [0..40]
          sketch.stroke(50, 50, 50)
          sketch.line(startX, sketch.height - j * (deltaY), startX + (deltaX * j), sketch.height - j * (deltaY + 1))

      drawCircle(sketch, circle, sketch.frameCount) for circle in circles 
]