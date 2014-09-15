angular.module('GhetoLifeHack', []).config ($routeProvider, $locationProvider) ->
  $routeProvider.when('/', 
    templateUrl: 'home.html'
    controller: 'HomeCtrl'
  )

  $locationProvider.html5Mode(true)
  return