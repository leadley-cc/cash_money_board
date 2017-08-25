require_relative "model"

class Tag
  include Model

  @table = "tags"
  @columns = ["name"]

  def initialize(params)
    set_instance_variables(params)
  end
end
