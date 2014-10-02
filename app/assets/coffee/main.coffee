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

  tree = GiantQuadtree.create(WIDTH, HEIGHT)


  drawCircle = (sketch, circle, frame, tree) =>
    red = redSin(frame)
    green = greenSin(frame)
    blue = blueSin(frame)
    circle.impulse(GRAVITY_VECTOR, 10, sketch)

    sketch.strokeWeight(circle.weight)
    sketch.stroke(circle.stroke)
    sketch.fill(red, green, blue)
    sketch.ellipse(circle.x, circle.y, circle.diameter, circle.diameter)
    sketch.fill(255 - blue, 255 - green, 255.0 - red)
    sketch.textSize(64)
    sketch.text(circle.text, circle.x - 20, circle.y + 20)
    tree.insert(circle.boundingRectangle())

  findCollisions = (circle, tree) =>
    rect = circle.boundingRectangle()
    left = rect.left
    top = rect.top
    width = rect.width 
    height = rect.height 
    collisions = tree.get(left, top, width, height)
    for collision in collisions
      if(collision.circle isnt circle)
        console.log("collision!")
        #TODO reflection! 


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
      sketch.background(235)
      tree.reset()
      drawCircle(sketch, circle, sketch.frameCount, tree) for circle in circles
      findCollisions(circle, tree) for circle in circles
]