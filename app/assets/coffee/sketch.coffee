# Infrastructure for bridging processing to AngularJS

sketch = angular.module('sketch', [])

sketch.directive 'processing', () =>
  scope: true
  link: (scope, iElement, iAttrs) => 
    scope.$sketch = new Processing(iElement[0], scope[iAttrs.processing])

sketch.factory('fills', () =>
  COLOR_RATIO = (2 * Math.PI) / 30.0
  fills = 
		colorSin: (base, period) => 
  	  (time) => 
    	  value = ((period * time) + base) * COLOR_RATIO
      	Math.sin(value) * 255.0
)

