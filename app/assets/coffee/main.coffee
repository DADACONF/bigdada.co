dadaApp = angular.module('dada', ['sketch', 'ngTouch'])

dadaApp.controller 'SketchController', ["$scope", "$window", "$swipe", "fills", "shapes", ($scope, $window, $swipe, fills, shapes) =>
  GRAVITY_VECTOR = new PVector(0, -0.009)
  container = $(".canvas-container")
  canvas = $("#screen")
  screen = 
    width: $(container).width()
    height: $(container).height()

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

  bgTexts = ["BIGDADA", "j.CREW", "DISRUPT", "BRUNCH"]

  circlePadding = 8
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

  textIndex = 0

  setWidthAndHeight = (sketch) =>
    screen.width = $(container).width()
    screen.height = $(container).height()
    canvas.attr('width', screen.width)
    canvas.attr('height', screen.height)
    sketch.size(screen.width, screen.height)    


  drawCircle = (sketch, circle, frame, red, green, blue) =>
    circle.impulse(GRAVITY_VECTOR, 10, sketch)
    sketch.strokeWeight(circle.weight)
    sketch.stroke(circle.stroke)
    sketch.fill(red, green, blue)
    sketch.ellipse(circle.x, circle.y, circle.diameter, circle.diameter)
    sketch.fill(255 - blue, 255 - green, 255.0 - red)
    rectangle = circle.boundingRectangle()
    sketch.externals.context.drawImage(
      sprites[circle.text], 
      rectangle.left + circlePadding, 
      rectangle.top + circlePadding, 
      rectangle.width - (circlePadding * 2), 
      rectangle.height - (circlePadding * 2))
    if(frame - lastFlip > 10)
      circle.shrink()

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
    if(frame - lastFlip > 12)
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
        textR: 0x14
        textG: 0x07
        textB: 0x3A
      else 
        colors  
    sketch.background(colors.backgroundR, colors.backgroundG, colors.backgroundB)  
    sketch.textSize(screen.width / 7)
    sketch.fill(colors.textR, colors.textG, colors.textB)  
    fillText = bgTexts[Math.floor(bgSeed * bgTexts.length)]
    sketch.text(fillText, 10, screen.height * 4 / 6) 

  addCircle = (x, y, direction, magnitude) =>
    xComponent = Math.cos(direction) * magnitude
    yComponent = Math.sin(direction) * magnitude
    newCircle = new shapes.Circle(
      70, 
      new shapes.Fill(0,Math.random(),0), 
      1, 
      2, 
      x, 
      y, 
      text.slice(textIndex, textIndex+1), 
      new PVector(xComponent, yComponent))
    circles.push(newCircle)
    textIndex = (textIndex + 1) % 7

  circleStream = false
  circleX = 0
  circleY = 0

  $swipe.bind(canvas, 
    start: (coords) => 
      circleStream = true  
      circleX = coords.x
      circleY = coords.y
    end:  (coords) => 
      circleStream = false
    move: (coords) =>
      circleX = coords.x
      circleY = coords.y
    cancel: () =>
      circleStream = false  
  )    

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
      textFlip(sketch, frameDelta)
      circles = circles.filter((circle) -> circle.diameter >= 10)
      if circleStream is true
        newGravity = randomGravity()  
        GRAVITY_VECTOR.set(0.009*Math.cos(newGravity), -0.009*Math.sin(newGravity)) 
        circleSeed = Math.random()
        addCircle(circleX, circleY, circleSeed * 2 * Math.PI, circleSeed * 2.4)

      red = redSin(sketch.frameCount)
      green = greenSin(sketch.frameCount)
      blue = blueSin(sketch.frameCount)
      drawCircle(sketch, circle, sketch.frameCount, red, green, blue) for circle in circles
]