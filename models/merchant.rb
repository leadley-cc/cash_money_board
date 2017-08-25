require_relative "model"
require_relative "tag"

class Merchant
  include Model

  @table = "merchants"
  @columns = ["name", "tag_id"]

  attr_accessor :name, :tag_id

  def initialize(params)
    @id = params["id"].to_i if params["id"]
    @name = params["name"]
    @tag_id = params["tag_id"].to_i
  end

  def tag
    Tag.find(@tag_id)
  end
end
