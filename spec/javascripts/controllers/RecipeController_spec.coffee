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

    describe 'form create', ->

      it 'should have empty recipe', ->
        setupController()
        expect(scope.recipe).toEqualData({})

    describe 'for update', ->

      beforeEach(setupController(fakeRecipe.id))

      it 'should loads recipe if found', ->
        httpBackend.expectGET("/recipes/#{fakeRecipe.id}?format=json").respond(204, fakeRecipe)
        httpBackend.flush()
        expect(scope.recipe).toEqualData(fakeRecipe)

      it 'should lods null recipe if not found', ->
        httpBackend.expectGET("/recipes/#{fakeRecipe.id}?format=json").respond(404)
        httpBackend.flush()
        expect(scope.recipe).toEqualData({})

  describe 'create recipe', ->

    beforeEach(setupController())

    it 'should POST new recipe to backend', ->
      httpBackend.expectPOST("/recipes?format=json").respond(201, fakeRecipe)
      scope.recipe.name = fakeRecipe.name
      scope.recipe.instructions = fakeRecipe.instructions
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/recipes/#{fakeRecipe.id}")

  describe 'update recipe', ->

    updatedRecipe = { id: 109, name: 'New name', instructions: 'New instructions' }

    beforeEach ->
      setupController(fakeRecipe.id)
      httpBackend.expectGET("/recipes/#{fakeRecipe.id}?format=json").respond(204, fakeRecipe)
      httpBackend.flush()

    it 'should send PUT to backend', ->
      scope.recipe.name = updatedRecipe.name
      scope.recipe.instructions = updatedRecipe.instructions
      httpBackend.expectPUT("/recipes/#{fakeRecipe.id}?format=json", updatedRecipe).respond(201, updatedRecipe)
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/recipes/#{updatedRecipe.id}")

