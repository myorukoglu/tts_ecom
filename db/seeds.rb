# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
categories = Category.create([{name: "Computers"}, {name: "Smart Phones"}, 
  {name: "Televisions"}, {name: "Game Consoles"}, {name: "Video Games"},
  {name: "Appliances"}, {name: "Other"}])

  if Product.all.length == 0
    Product.create(:name => "Nokia Flip", 
      :price => 99.00, 
      :quantity => 123, 
      :description => "Worst phone on the market",
      :brand => "Nokia",
      :rating => 1, 
      :category_id => 2,
      )
  end
  if ! User.where(:role => "admin") 
    User.create(:name => "jane admin", :email => "a2@a.com", :password => "asdfASDF1", :role => "admin")
  end