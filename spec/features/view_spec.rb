require 'spec_helper.rb'
require 'rails_helper.rb'

feature "Displaying a recipe", js: true do

  before do
    @recipe1 = Recipe.create!(name: 'Baked Potato with Cheese',
                              instructions: "nuke for 20 minutes")

    @recipe2 = Recipe.create!(name: 'Baked Brussel Sprouts',
                              instructions: 'Slather in oil, and roast on high heat for 20 minutes')
  end

  scenario "display recipe" do
    visit '/'
    fill_in "keywords", with: "baked"
    click_on "Search"

    click_on "Baked Brussel Sprouts"

    expect(page).to have_content "Baked Brussel Sprouts"
    expect(page).to have_content "Slather in oil"

    click_on "Back"

    expect(page).to have_content "Baked Potato with Cheese"
    expect(page).to have_content "Baked Brussel Sprouts"
  end

  scenario "create new recipe" do
    visit "/"
    click_on "New Recipe…"

    fill_in "name", with: "Frozen Pizza"
    fill_in "instructions", with: "Put it in the oven for 15 minutes"

    click_on "Save"

    expect(page).to have_content "Frozen Pizza"
    expect(page).to have_content "Put it in the oven for 15 minutes"
  end

  scenario "edit recipe" do
    visit '/'
    fill_in "keywords", with: "Baked Brussel Sprouts"
    click_on "Search"

    click_on "Edit"

    fill_in "name", with: "New name"
    fill_in "instructions", with: "New instructions"

    click_on "Save"

    expect(page).to have_content "New name"
    expect(page).to have_content "New instructions"

    @recipe2.reload
    expect(@recipe2.name).to eq("New name")
  end

end
