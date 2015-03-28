controllers = angular.module('controllers')
controllers.controller('RecipeController', ['$scope', '$routeParams', '$resource', '$location', '$window',
  ($scope, $routeParams, $resource, $location, $window)->
    Recipe = $resource('/recipes/:recipeId', { recipeId: "@id", format: 'json' },
      {
        create: { method: 'POST' }
        update: { method: 'PUT' }
      }
    )

    if $routeParams.recipeId
      Recipe.get({ recipeId: $routeParams.recipeId },
        ( (recipe)-> $scope.recipe = recipe ),
        ( (error)-> $scope.recipe = {} )
      )
    else
      $scope.recipe = {}

    $scope.back = () ->
      $window.history.back()

    $scope.save = () ->
      if $routeParams.recipeId
        Recipe.update($scope.recipe,
          ( (recipe) -> $location.path("/recipes/#{recipe.id}") )
        )
      else
        Recipe.create($scope.recipe,
          ( (recipe) -> $location.path("/recipes/#{recipe.id}") )
        )

])
