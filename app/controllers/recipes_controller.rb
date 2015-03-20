class RecipesController < ApplicationController
  respond_to :html, :json
  skip_before_filter :verify_authenticity_token

  def index
    @recipes = []
    @recipes = Recipe.where('name ilike ?',"%#{params[:keywords]}%") if params[:keywords]
    respond_with(@recipes)
  end

  def show
    @recipe = Recipe.find params[:id]
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.save
    respond_with(@recipe)
  end

  def update
    @recipe = Recipe.find(params[:id])
    @recipe.update(recipe_params)
    respond_with(@recipe)
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :instructions)
  end
end
