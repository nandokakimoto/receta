controllers = angular.module('controllers')
controllers.controller('RecipeController', ['$scope', '$routeParams', '$resource', '$location', '$window',
  ($scope, $routeParams, $resource, $location, $window)->
    Recipe = $resource('/recipes/:recipeId', { recipeId: "@id", format: 'json' },
      {
        create: { method: 'POST' }
      }
    )

    if $routeParams.recipeId
      Recipe.get({ recipeId: $routeParams.recipeId },
        ( (recipe)-> $scope.recipe = recipe ),
        ( (error)-> $scope.recipe = null )
      )
    else
      $scope.recipe = {}

    $scope.back = () ->
      $window.history.back()

    $scope.save = () ->
      Recipe.create($scope.recipe,
        ( (newRecipe) -> $location.path("/recipes/#{newRecipe.id}") )
      )
])
