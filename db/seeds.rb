require "pry"

require_relative "../models/tag"
require_relative "../models/merchant"
require_relative "../models/transaction"

Transaction.delete_all
Merchant.delete_all
Tag.delete_all

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

tran1 = Transaction.new({
  "value" => 2500,
  "date_time" => Time.now,
  "merchant_id" => sains.id
})
tran1.save

binding.pry
nil
