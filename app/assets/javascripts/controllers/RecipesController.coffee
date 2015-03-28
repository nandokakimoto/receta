controllers = angular.module( 'controllers' )
controllers.controller( 'RecipesController', [ '$scope', '$routeParams', '$location', '$resource',
  ($scope, $routeParams, $location, $resource)->
    Recipe = $resource('/recipes/:recipeId', { recipeId: "@id", format: 'json' },
      {
        delete: { method: 'DELETE' }
      }
    )

    $scope.loadRecipes = () ->
      if $routeParams.keywords
        Recipe.query(keywords: $routeParams.keywords, (results)-> $scope.recipes = results)
      else
        $scope.recipes = []

    $scope.search = (keywords) ->
      $location.path("/").search("keywords", keywords)

    $scope.newRecipe = () ->
      $location.path("/recipes/new")

    $scope.deleteRecipe = (recipeId) ->
      recipe = { id: recipeId }
      Recipe.delete( {}, recipe, ( () -> $scope.loadRecipes()) )

    $scope.editRecipe = (recipeId) ->
      $location.path("/recipes/#{recipeId}/edit")


    $scope.loadRecipes()
])
