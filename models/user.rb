require_relative "model"
require_relative "transaction"

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

  def full_name
    @first_name + " " + @last_name
  end

  def new_transaction(params)
    params["user_id"] = @id
    Transaction.new(params).save
  end

  def transactions
    Transaction.select("user_id", @id)
  end

  def transaction_count
    Transaction.count("user_id", @id)
  end

  def spent
    trans = transactions
    return 0 unless trans
    trans.inject(0) {|sum, transaction| sum + transaction.value}
  end

  def budget_left
    @budget_cap - spent
  end

  # def spent_by_tag(tag_id)
  #   transactions.select {|transaction| transaction.tag.id == tag_id}
  #               .inject {|sum, transaction| sum + transaction.value}
  # end

  def print_money(message)
    '£' << send(message).to_s.insert(-3,'.')
  end

  private
  def spend
    # TODO: Implement a @spent variable and method to add to it
  end
end
