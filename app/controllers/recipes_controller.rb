class RecipesController < ApplicationController
  def index
    @recipes = []
    @recipes = Recipe.where('name ilike ?',"%#{params[:keywords]}%") if params[:keywords]
  end
end
