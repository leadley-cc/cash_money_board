require "pry"

require_relative "../models/tag"
require_relative "../models/merchant"
require_relative "../models/transaction"

Transaction.delete_all
Merchant.delete_all
Tag.delete_all
User.delete_all

michael = User.new({
  "first_name" => "Michael",
  "last_name" => "Leadley",
  "budget_cap" => 20000
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

supermarket = Tag.new({"name" => "Supermarket"})
supermarket.save

tesco = Merchant.new({
  "name" => "Tesco",
  "tag_id" => supermarket.id
})
tesco.save

sains = Merchant.new({
  "name" => "Sainsbury's",
  "tag_id" => supermarket.id
})
sains.save

michael.new_transaction({
  "value" => 2500,
  "date_time" => Time.now,
  "merchant_id" => sains.id
})

michael.new_transaction({
  "value" => 1500,
  "date_time" => Time.now,
  "merchant_id" => tesco.id
})

michael.new_transaction({
  "value" => 500,
  "date_time" => Time.now,
  "merchant_id" => sains.id
})

binding.pry
nil
