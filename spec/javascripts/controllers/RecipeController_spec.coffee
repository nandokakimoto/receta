describe "RecipeController", ->
  beforeEach(module("receta"))

  routeParams = null
  scope       = null
  resource    = null
  httpBackend = null
  ctrl        = null

  fakeRecipe =
    id: 109
    name: "Baked Potatoes"
    instructions: "Pierce potato with fork, nuke for 20 minutes"

  setupController = () ->
    inject(($routeParams, $rootScope, $resource, $httpBackend, $window, $controller)->

      scope       = $rootScope.$new()
      resource    = $resource
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.recipeId = fakeRecipe.id

      ctrl = $controller('RecipeController', $scope: scope, $window: window)
    )

  beforeEach(setupController())

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->

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

