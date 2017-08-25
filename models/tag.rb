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
end
