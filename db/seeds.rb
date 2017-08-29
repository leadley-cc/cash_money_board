require "pry"

require_relative "../models/transaction"
require_relative "../models/merchant"
require_relative "../models/tag"
require_relative "../models/user"

Transaction.delete_all
Merchant.delete_all
Tag.delete_all
User.delete_all

## USERS

michael = User.new({
  "first_name" => "Michael",
  "last_name" => "Leadley",
  "budget_cap" => 25000
})
michael.save

sandra = User.new({
  "first_name" => "Sandra",
  "last_name" => "Jabłońska",
  "budget_cap" => 30000
})
sandra.save

jim = User.new({
  "first_name" => "Jimothy",
  "last_name" => "Bobble",
  "budget_cap" => 1000
})
jim.save

theo = User.new({
  "first_name" => "Theodore",
  "last_name" => "Hev",
  "budget_cap" => 240000
})
theo.save

gert = User.new({
  "first_name" => "Gertrude",
  "last_name" => "Blenkinsop",
  "budget_cap" => 420
})
gert.save

## TAGS

supermarket = Tag.new({"name" => "Supermarket"})
supermarket.save

food_drink = Tag.new({"name" => "Food & Drink"})
food_drink.save

bills = Tag.new({"name" => "Bills"})
bills.save

entertainment = Tag.new({"name" => "Entertainment"})
entertainment.save

transport = Tag.new({"name" => "Transport"})
transport.save

## MERCHANTS

sains = Merchant.new({
  "name" => "Sainsbury's",
  "tag_id" => supermarket.id
})
sains.save

chanter = Merchant.new({
  "name" => "The Chanter",
  "tag_id" => food_drink.id
})
chanter.save

sneakies = Merchant.new({
  "name" => "Sneaky Pete's",
  "tag_id" => entertainment.id
})
sneakies.save

lidl = Merchant.new({
  "name" => "Lidl",
  "tag_id" => supermarket.id
})
lidl.save

sky = Merchant.new({
  "name" => "Sky",
  "tag_id" => bills.id
})
sky.save

buses = Merchant.new({
  "name" => "Lothian Buses",
  "tag_id" => transport.id
})
buses.save

## TRANSACTIONS

michael.new_transaction({
  "value" => 2385,
  "date_time" => Time.now,
  "merchant_id" => sains.id
})

michael.new_transaction({
  "value" => 1500,
  "date_time" => Time.now,
  "merchant_id" => lidl.id
})

sandra.new_transaction({
  "value" => 1050,
  "date_time" => Time.now,
  "merchant_id" => lidl.id
})

michael.new_transaction({
  "value" => 300,
  "date_time" => Time.now,
  "merchant_id" => chanter.id
})

jim.new_transaction({
  "value" => 235,
  "date_time" => Time.now,
  "merchant_id" => sains.id
})

michael.new_transaction({
  "value" => 500,
  "date_time" => Time.now,
  "merchant_id" => sneakies.id
})

michael.new_transaction({
  "value" => 1120,
  "date_time" => Time.now,
  "merchant_id" => buses.id
})

binding.pry
nil
