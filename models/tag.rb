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
    sql = "
      SELECT transactions.* FROM transactions
      INNER JOIN merchants ON transactions.merchant_id = merchants.id
      WHERE merchants.tag_id = $1
    "
    result = SqlRunner.run(sql, [@id])
    return Transaction.map_create(result)
  end

  def merchant_count
    Merchant.count("tag_id", @id)
  end

  def transaction_count
    sql = "
      SELECT COUNT(*) FROM transactions
      INNER JOIN merchants ON transactions.merchant_id = merchants.id
      WHERE merchants.tag_id = $1
    "
    result = SqlRunner.run(sql, [@id])
    return result.first["count"]
  end
end
