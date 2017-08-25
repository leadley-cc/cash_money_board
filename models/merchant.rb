require_relative "model"
require_relative "tag"

class Merchant
  include Model

  @table = "merchants"
  @columns = ["name", "tag_id"]

  def initialize(params)
    set_instance_variables(params)
  end

  def tag
    Tag.find(@tag_id)
  end
end
