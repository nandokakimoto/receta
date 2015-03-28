describe "RecipesController", ->
  beforeEach(module("receta"))

  scope       = null
  ctrl        = null
  location    = null
  routeParams = null
  resource    = null
  httpBackend = null

  keywords = 'foo'
  recipes  = [
    { id: 2, name: 'Baked Potatoes' },
    { id: 4, name: 'Potatoes Au Gratin' }
  ]


  setupController = (keywords, results)->
    inject(($location, $routeParams, $rootScope, $resource, $httpBackend, $controller)->
      scope       = $rootScope.$new()
      location    = $location
      resource    = $resource
      routeParams = $routeParams
      routeParams.keywords = keywords
      httpBackend = $httpBackend

      if results
        request = new RegExp("\/recipes.*keywords=#{keywords}")
        httpBackend.expectGET(request).respond(results)

      ctrl = $controller('RecipesController', $scope: scope, $location: location)
    )


  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    describe 'when no keywords present', ->
      beforeEach(setupController())

      it 'defaults to no recipes', ->
        expect(scope.recipes).toEqualData([])

    describe 'with keywords', ->
      beforeEach ->
        setupController(keywords, recipes)
        httpBackend.flush()

      it 'calls the back-end', ->
        expect(scope.recipes).toEqualData(recipes)

  describe 'search()', ->
    beforeEach(setupController())

    it 'redirects to itself with a keyword param', ->
      keywords = 'foo'
      scope.search(keywords)
      expect(location.path()).toBe('/')
      expect(location.search()).toEqualData({keywords: keywords})

  describe 'newRecipe()', ->
    beforeEach(setupController())

    it 'redirects to new recipe URL', ->
      scope.newRecipe()
      expect(location.path()).toBe('/recipes/new')

  describe 'deleteRecipe()', ->
    recipeId = 2

    beforeEach ->
      setupController(keywords, recipes)
      httpBackend.flush()
      httpBackend.expectDELETE("/recipes/#{recipeId}?format=json").respond(204, null)
      httpBackend.expectGET("/recipes?format=json&keywords=foo").respond(200, [recipes[1]])

    it 'send DELETE to backend', ->
      scope.deleteRecipe(recipeId)
      httpBackend.flush()

    it 'reload recipes without deleted recipe', ->
      scope.deleteRecipe(recipeId)
      httpBackend.flush()
      expect(scope.recipes).toEqualData([recipes[1]])


  describe 'editRecipe()', ->
    recipeId = 2

    beforeEach ->
      setupController(keywords, recipes)
      httpBackend.flush()

    it 'should redirect to edit path', ->
      scope.editRecipe(recipeId)
      expect(location.path()).toBe('/recipes/2/edit')

