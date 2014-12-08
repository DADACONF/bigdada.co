dadaApp = angular.module('dada', ['sketch'])

dadaApp.controller 'SketchController', ["$scope", "$window", "fills", "shapes", ($scope, $window, fills, shapes) =>
  GRAVITY_VECTOR = new PVector(0, -0.009)
  container = $(".canvas-container")
  canvas = $("#screen")
  screen = 
    width: $(container).width()
    height: $(container).height() - 10

  text = "BIGDADA"

  circles = for i in [0..6]
    fill = new shapes.Fill(0, 0, 0)
    y = screen.height * .75
    x = (((screen.width / 7.0) * i) + (screen.width / 15.0))
    new shapes.Circle(70, fill, 1, 2, x, y, text.slice(i, i+1), new PVector(0, Math.random()))
  
  redSin = fills.colorSin(200, .34)
  greenSin = fills.colorSin(200, .14)
  blueSin = fills.colorSin(200, .22)

  bgRedSin = fills.colorSin(50, .35)
  bgBlueSin = fills.colorSin(120, .35)

  tree = GiantQuadtree.create(screen.width, screen.height)

  textIndex = 0

  setWidthAndHeight = (sketch) =>
    screen.width = $(container).width()
    screen.height = $(container).height() - 10
    canvas.attr('width', screen.width)
    canvas.attr('height', screen.height)
    sketch.size(screen.width, screen.height)    


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
    sketch.textSize(circle.diameter * .8)
    sketch.text(circle.text, circle.x - (circle.diameter / 4), circle.y + (circle.diameter / 3))
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
        # console.log("collision!")
        circle.shrink()
        collision.circle.shrink()
        #TODO reflection! 

  randomGravity = () ->
    seed = Math.random() * 2
    if seed < 1
      0
    else if seed < 2 and seed > 1
      Math.PI / 2
    else if seed < 3 and seed > 2
      Math.PI 
    else 
      3 * (Math.PI / 2)

  $scope.dada = ($event) =>
    newGravity = randomGravity()
    GRAVITY_VECTOR.set(0.009*Math.cos(newGravity), -0.009*Math.sin(newGravity)) 
    clickX = $event.offsetX
    clickY = $event.offsetY
    newCircle = new shapes.Circle(
      70, 
      new shapes.Fill(0,Math.random(),0), 
      1, 
      2, 
      clickX, 
      clickY, 
      text.slice(textIndex, textIndex+1), 
      new PVector(0, 0))
    circles.push(newCircle)
    textIndex = (textIndex + 1) % 7

  lastFlip = 0
  bgSeed = Math.random()
  textFlip = (sketch, frame) => 
    bgSeed = 
      if(frame - lastFlip > 4)
        lastFlip = frame
        Math.random()
      else bgSeed  

    r = (bgSeed * 50) + 205
    g = bgSeed * 210
    b = bgSeed * 90  
    sketch.background(bgRedSin(frame), g + 40, bgBlueSin(frame))  
    sketch.textSize(screen.height / 6) # 1/3 or canvas height
    sketch.fill(255 - r, g * 2/3, 255)
    sketch.text("BIG DADA", screen.width / 22, screen.height * 4 / 6) 

  # the function that is called to bootstrap the sketch process form the processing directive
  $scope.circleAnimation = (sketch) => 
    lastFrame = 0

    sketch.setup = () =>  
      setWidthAndHeight(sketch)
      $($window).resize(() => 
        setWidthAndHeight(sketch)
      )
      sketch.frameRate(30)
    
    sketch.draw = () =>
      frameDelta = sketch.frameCount - lastFrame  
      # Draw background first
      tree.reset()
      textFlip(sketch, frameDelta)
      circles = circles.filter((circle) -> circle.diameter >= 5)
      drawCircle(sketch, circle, sketch.frameCount, tree) for circle in circles
      findCollisions(circle, tree) for circle in circles
]