require 'spec_helper.rb'
require 'rails_helper.rb'

feature "Looking up for recipes", js: true do

  before do
    Recipe.create!(name: 'Baked Potato w/ Cheese')
    Recipe.create!(name: 'Garlic Mashed Potatoes')
    Recipe.create!(name: 'Potatoes Au Gratin')
    Recipe.create!(name: 'Baked Brussel Sprouts', instructions: 'Dummy description')
  end

  scenario "finding recipes" do
    visit '/'
    fill_in "keywords", with: "baked"
    click_on "Search"

    expect(page).to have_content("Baked Potato")
    expect(page).to have_content("Baked Brussel Sprouts")
  end

  scenario "delete recipe" do
    visit "/"
    fill_in "keywords", with: "Baked Brussel Sprouts"

    click_on "Search"
    click_on "Delete"

    expect(page).not_to have_content "Baked Brussel Sprouts"
  end

  scenario "edit recipe" do
    visit "/"
    fill_in "keywords", with: "Baked Brussel Sprouts"

    click_on "Search"
    click_on "Edit"

    expect(page).to have_field "name", "Baked Brussel Sprouts"
    expect(page).to have_field "instructions", "Dummy description"
  end


end
