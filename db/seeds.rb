# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Recipe.create!(name: 'Baked Potato w/ Cheese',
               instructions: 'A comforting cheesy potato bake is the perfect accompaniment to a hearty meat dish in winter')

Recipe.create!(name: 'Garlic Mashed Potatoes',
               instructions: 'Obviously, it has all been said before, but these taters are creamy and delicious!')

Recipe.create!(name: 'Potatoes Au Gratin',
               instructions: 'Preheat oven to 350°. In a large saucepan, melt butter over low heat.')

Recipe.create!(name: 'Baked Brussel Sprouts',
               instructions: 'Preheat oven to 400°F. Toss Brussels sprouts with oil, salt and pepper')
