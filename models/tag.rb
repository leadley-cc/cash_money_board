require_relative "model"

class Tag
  include Model

  @table = "tags"
  @columns = ["name"]

  attr_accessor :name

  def initialize(params)
    @id = params["id"].to_i if params["id"]
    @name = params["name"]
  end

  def merchants
    Merchant.select("tag_id", @id)
  end

  def transactions
    result = SqlQuery.new("transactions")
                     .select
                     .inner_join("merchants", reverse = true)
                     .where({ "merchants.tag_id" => @id })
                     .run
    return Transaction.map_create(result)
  end

  def merchant_count
    Merchant.count("tag_id", @id)
  end

  def transaction_count
    result = SqlQuery.new("transactions")
                     .count
                     .inner_join("merchants", reverse = true)
                     .where({ "merchants.tag_id" => @id })
                     .run
    return result.first["count"]
  end

  def spent
    trans = transactions
    return 0 unless trans
    trans.inject(0) {|sum, transaction| sum + transaction.value}
  end
end
