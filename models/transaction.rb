require_relative "model"
require_relative "user"
require_relative "merchant"
require_relative "tag"

class Transaction
  include Model

  @table = "transactions"
  @columns = ["value", "date_time", "user_id", "merchant_id"]

  attr_accessor :value, :date_time, :user_id, :merchant_id

  def initialize(params)
    @id = params["id"].to_i if params["id"]
    @value = params["value"].to_i
    @date_time = params["date_time"] # This comes back as a Time object
    @user_id = params["user_id"].to_i
    @merchant_id = params["merchant_id"].to_i
  end

  def user
    User.find(@user_id)
  end

  def merchant
    Merchant.find(@merchant_id)
  end

  def tag
    sql = "
      SELECT tags.* FROM tags
      INNER JOIN merchants ON tags.id = merchants.tag_id
      WHERE merchants.id = $1
    "
    result = SqlRunner.run(sql, [@merchant_id])
    Tag.new(result.first)
  end
end
