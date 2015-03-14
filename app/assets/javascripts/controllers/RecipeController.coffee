controllers = angular.module('controllers')
controllers.controller('RecipeController', ['$scope', '$routeParams', '$resource', '$window',
  ($scope, $routeParams, $resource, $window)->
    Recipe = $resource('/recipes/:recipeId', { recipeId: '@id', format: 'json' })
    Recipe.get({ recipeId: $routeParams.recipeId },
      ( (recipe)-> $scope.recipe = recipe ),
      ( (error)-> $scope.recipe = null )
    )

    $scope.back = () ->
      $window.history.back()
])
