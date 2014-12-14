dadaApp = angular.module('dada', ['sketch'])

dadaApp.controller 'SketchController', ["$scope", "$window", "fills", "shapes", ($scope, $window, fills, shapes) =>
  GRAVITY_VECTOR = new PVector(0, -0.009)
  container = $(".canvas-container")
  canvas = $("#screen")
  # bufferCanvas = $("#textBuffer")[0]
  # textBuffer = TextBuffer.createBuffer(bufferCanvas)
  # textBuffer.init()
  screen = 
    width: $(container).width()
    height: $(container).height() - 10

  text = "BIGDADA"
  aSprite = new Image()
  aSprite.src ="sprites/a.png"
  bSprite = new Image()
  bSprite.src ="sprites/b.png"
  iSprite = new Image()
  iSprite.src ="sprites/i.png"
  gSprite = new Image()
  gSprite.src ="sprites/g.png"
  dSprite = new Image()
  dSprite.src ="sprites/d.png"
  
  sprites =
    "B": bSprite
    "I": iSprite
    "G": gSprite
    "D": dSprite
    "A": aSprite  

  bgTexts = ["BIGDADA", "j.CREW", "DISRUPT", "BRVNCH"]

  circles = for i in [0..6]
    fill = new shapes.Fill(0, 0, 0)
    y = screen.height * .75
    x = (((screen.width / 11.0) * (i + 2)) + (screen.width / 15.0))
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


  drawCircle = (sketch, circle, frame, tree, red, green, blue) =>
    circle.impulse(GRAVITY_VECTOR, 10, sketch)
    sketch.strokeWeight(circle.weight)
    sketch.stroke(circle.stroke)
    sketch.fill(red, green, blue)
    sketch.ellipse(circle.x, circle.y, circle.diameter, circle.diameter)
    sketch.fill(255 - blue, 255 - green, 255.0 - red)
    rectangle = circle.boundingRectangle()
    sketch.externals.context.drawImage(
      sprites[circle.text], 
      rectangle.left, 
      rectangle.top, 
      rectangle.left + rectangle.width, 
      rectangle.top + rectangle.height)
    # sketch.textSize(circle.diameter * .8)
    # sketch.text(circle.text, circle.x - (circle.diameter / 4), circle.y + (circle.diameter / 3))
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
        circle.shrink()
        collision.circle.shrink()

  randomGravity = () ->
    seed = Math.random() * 4
    if seed < 1
      0
    else if seed < 2 and seed > 1
      Math.PI / 2
    else if seed < 3 and seed > 2
      Math.PI 
    else 
      3 * (Math.PI / 2)

  lastFlip = 0
  bgSeed = Math.random()
  colors = null

  textFlip = (sketch, frame) => 
    if(frame - lastFlip > 8)
      lastFlip = frame
      bgSeed = Math.random()
      colors = null
    colors = 
      if colors is null
        lastFlip = frame
        bgSeed = Math.random()
        backgroundR: bgRedSin(frame)
        backgroundG:  Math.floor(bgSeed * 210) + 40
        backgroundB:  bgBlueSin(frame)
        textR: 66
        textG: 4
        textB: 2
      else 
        colors  
    sketch.background(colors.backgroundR, colors.backgroundG, colors.backgroundB)  
    sketch.textSize(screen.height / 7)
    sketch.fill(colors.textR, colors.textG, colors.textB)  
    fillText = bgTexts[Math.floor(bgSeed * bgTexts.length)]
    sketch.text(fillText, screen.width / 22, screen.height * 4 / 6) 
     

  addCircle = (x, y) =>
    newCircle = new shapes.Circle(
      70, 
      new shapes.Fill(0,Math.random(),0), 
      1, 
      2, 
      x, 
      y, 
      text.slice(textIndex, textIndex+1), 
      new PVector(0, 0.0))
    circles.push(newCircle)
    textIndex = (textIndex + 1) % 7

  $scope.dada = ($event) =>
    newGravity = randomGravity()
    GRAVITY_VECTOR.set(0.009*Math.cos(newGravity), -0.009*Math.sin(newGravity)) 
    clickX = $event.offsetX
    clickY = $event.offsetY
    addCircle(clickX, clickY)

  # the function that is called to bootstrap the sketch process form the processing directive
  $scope.circleAnimation = (sketch) => 
    lastFrame = 0

    sketch.setup = () =>  
      setWidthAndHeight(sketch)
      $($window).resize(() => 
        setWidthAndHeight(sketch)
      )
      sketch.frameRate(30)
      sketch.noStroke()
    
    sketch.draw = () =>
      frameDelta = sketch.frameCount - lastFrame  
      tree.reset()
      textFlip(sketch, frameDelta)
      circles = circles.filter((circle) -> circle.diameter >= 10)
      red = redSin(sketch.frameCount)
      green = greenSin(sketch.frameCount)
      blue = blueSin(sketch.frameCount)
      drawCircle(sketch, circle, sketch.frameCount, tree, red, green, blue) for circle in circles
      findCollisions(circle, tree) for circle in circles

]