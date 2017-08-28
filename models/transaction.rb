require "time"
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
    @user_id = params["user_id"].to_i
    @merchant_id = params["merchant_id"].to_i
    @date_time = params["date_time"]
    process_date_time
  end

  def print_date
    @date_time.strftime("%a %d %b %y")
  end

  def print_time
    @date_time.strftime("%k:%M:%S")
  end

  def print_value
    '£' << @value.to_s.insert(-3,'.')
  end

  def html_date_time
    @date_time.strftime("%FT%k:%M")
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

  private
  def process_date_time
    return nil unless @date_time.is_a?(String)
    if @date_time.empty?
      @date_time = Time.now
    else
      @date_time = Time.parse(@date_time)
    end
  end
end
