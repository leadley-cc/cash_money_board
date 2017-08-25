require_relative "model"

class User
  include Model

  @table = "users"
  @columns = ["first_name", "last_name", "budget_cap"]

  attr_accessor :first_name, :last_name, :budget_cap

  def initialize(params)
    @id = params["id"].to_i if params["id"]
    @first_name = params["first_name"]
    @last_name = params["last_name"]
    @budget_cap = params["budget_cap"].to_i
  end

  def new_transaction(params)
    params["user_id"] = @id
    Transaction.new(params).save
  end

  def transactions
    # TODO: return array of user's transactions
    Transaction.select("user_id", @id)
  end
end
