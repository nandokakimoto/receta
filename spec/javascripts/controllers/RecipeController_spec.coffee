describe "RecipeController", ->
  beforeEach(module("receta"))

  routeParams = null
  scope       = null
  resource    = null
  httpBackend = null
  ctrl        = null
  location    = null

  fakeRecipe =
    id: 109
    name: "Baked Potatoes"
    instructions: "Pierce potato with fork, nuke for 20 minutes"

  setupController = (recipeId) ->
    inject(($routeParams, $rootScope, $resource, $httpBackend, $location, $window, $controller)->

      scope       = $rootScope.$new()
      resource    = $resource
      httpBackend = $httpBackend
      location    = $location
      routeParams = $routeParams
      routeParams.recipeId = recipeId

      ctrl = $controller('RecipeController', $scope: scope, $location: location, $window: window)
    )

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->

    beforeEach(setupController(fakeRecipe.id))

    describe 'recipe is found', ->

      it 'should loads recipe', ->
        httpBackend.expectGET("/recipes/#{fakeRecipe.id}?format=json").respond(204, fakeRecipe)
        httpBackend.flush()
        expect(scope.recipe).toEqualData(fakeRecipe)

    describe 'recipe is not found', ->

      it 'should lods null recipe', ->
        httpBackend.expectGET("/recipes/#{fakeRecipe.id}?format=json").respond(404)
        httpBackend.flush()
        expect(scope.recipe).toBe(null)

  describe 'create recipe', ->

    beforeEach(setupController())

    it 'should POST new recipe to backend', ->
      httpBackend.expectPOST("/recipes?format=json").respond(201, fakeRecipe)
      scope.recipe.name = fakeRecipe.name
      scope.recipe.instructions = fakeRecipe.instructions
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/recipes/#{fakeRecipe.id}")

