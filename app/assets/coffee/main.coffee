dadaApp = angular.module('dada', []);

dadaApp.directive 'processing', () =>
  scope: true
  link: (scope, iElement, iAttrs) => 
    scope.$sketch = new Processing(iElement[0], scope[iAttrs.processing])


dadaApp.controller 'SketchController', ($scope) =>
  $scope.sketch = (sketch) => 
    console.log "Hello World!"

    sketch.setup = () =>
      sketch.size(400, 300)
      sketch.frameRate(60)
    
    sketch.draw = () =>
      sketch.background(255)
      sketch.strokeWeight(5)
      sketch.stroke(255)
      sketch.fill(255, 0, 0)
      sketch.ellipse(200, 150, 40, 40)