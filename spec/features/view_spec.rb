require 'spec_helper.rb'

feature "Displaying a recipe", js: true do

  before do
    Recipe.create!(name: 'Baked Potato with Cheese',
                   instructions: "nuke for 20 minutes")

    Recipe.create!(name: 'Baked Brussel Sprouts',
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

end
