require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  render_views

  describe "index" do
    before do
      Recipe.create!(name: 'Baked Potato w/ Cheese')
      Recipe.create!(name: 'Garlic Mashed Potatoes')
      Recipe.create!(name: 'Potatoes Au Gratin')
      Recipe.create!(name: 'Baked Brussel Sprouts')

      xhr :get, :index, format: :json, keywords: keywords
    end

    subject(:results) { JSON.parse(response.body) }

    def extract_name
      ->(object) { object["name"] }
    end

    context "when the search finds results" do
      let(:keywords) { 'baked' }

      it 'should 200' do
        expect(response.status).to eq(200)
      end

      it 'should return two results' do
        expect(results.size).to eq(2)
      end

      it "should include 'Baked Potato w/ Cheese'" do
        expect(results.map(&extract_name)).to include('Baked Potato w/ Cheese')
      end

      it "should include 'Baked Brussel Sprouts'" do
        expect(results.map(&extract_name)).to include('Baked Brussel Sprouts')
      end
    end

    context "when the search doesn't find results" do
      let(:keywords) { 'foo' }

      it 'should return no results' do
        expect(results.size).to eq(0)
      end
    end

  end

  describe "show" do
    before do
      xhr :get, :show, format: :json, id: recipe_id
    end

    subject(:result) { JSON.parse(response.body) }

    context "when the recipe exists" do
      let(:recipe) { Recipe.create! name: 'Baked Potato w/ Cheese', instructions: "Nuke for 20 minutes; top with cheese" }
      let(:recipe_id) { recipe.id }

      it { expect(response.status).to eq(200) }
      it { expect(result["id"]).to eq(recipe.id) }
      it { expect(result["name"]).to eq(recipe.name) }
      it { expect(result["instructions"]).to eq(recipe.instructions) }
    end

    context "when the search doesn't find results" do
      let(:recipe_id) { 901 }

      it { expect(response.status).to eq(404) }
    end

  end

  describe "create" do
    before do
      xhr :post, :create, format: :json, recipe: { name: "Toast", instructions: "Add bread to toaster, push lever" }
    end

    subject(:result) { JSON.parse(response.body) }

    it { expect(response.status).to eq(201) }
    it { expect(result["name"]).to eq("Toast") }
    it { expect(result["instructions"]).to eq("Add bread to toaster, push lever") }

  end

  describe "update" do
    let(:recipe) { Recipe.create! name: "Toast", instructions: "Add bread to toaster, push lever" }

    before do
      xhr :put, :update, format: :json, id: recipe.id, recipe: { name: "Baked Potato", instructions: "Nuke for 20 minutes" }
      recipe.reload
    end

    it { expect(response.status).to eq(204) }
    it { expect(recipe.name).to eq("Baked Potato") }
    it { expect(recipe.instructions).to eq("Nuke for 20 minutes") }
  end

  describe "delete" do
    let(:recipe) { Recipe.create! name: "Toast", instructions: "Add bread to toaster, push lever" }

    before do
      xhr :delete, :destroy, format: :json, id: recipe.id
    end

    it { expect(response.status).to eq(204) }
    it { expect(Recipe.find_by(id: recipe.id)).to be_nil }
  end

end
