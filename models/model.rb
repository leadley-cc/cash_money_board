require_relative "../db/sql_runner"

module Model
  # @table and @columns are required for including Model
  # Any column named in @columns is given an attr_accessor
  # The id SERIAL PRIMARY KEY column is implicitly dealt with

  def self.included(included)
    included.class_eval do
      class << self
        attr_reader :table, :columns
      end
      attr_reader :id
      included.extend SelfMethods
    end
  end

  module SelfMethods
    def delete_all
      SqlRunner.run("DELETE FROM #{self.table}")
    end

    def all
      result = SqlRunner.run("SELECT * FROM #{self.table}")
      return self.map_create(result)
    end

    def map_create(hashes)
      return hashes.map {|hash| self.new(hash)}
    end
  end

  def set_instance_variables(options)
    self.class.columns.each do |column|
      instance_variable_set("@#{column}", options[column])
      self.class.class_eval { attr_accessor column }
    end
    instance_variable_set("@id", options["id"]) unless @id
  end

  def save
    @id ? update_query : save_query
  end

  def delete
    sql = "DELETE FROM #{self.class.table} WHERE id = $1"
    SqlRunner.run(sql, [@id])
  end

  private
  def sql_columns_str
    self.class.columns.join(", ")
  end

  def sql_placeholder_str(length)
    str = "$1"
    (2..length).each {|x| str << ", $#{x}"}
    return str
  end

  def sql_values_array(with_id = true)
    array = []
    self.class.columns.each do |column|
      array << send(column)
    end
    array << @id if with_id
    return array
  end

  def save_query
    puts "Saving!"
    columns_no = self.class.columns.count
    sql = "
      INSERT INTO #{self.class.table}
      (#{sql_columns_str})
      VALUES (#{sql_placeholder_str(columns_no)})
      RETURNING id
    "
    values = sql_values_array(with_id = false)
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"]
  end

  def update_query
    puts "Updating!"
    columns_no = self.class.columns.count
    sql = "
      UPDATE #{self.class.table}
      SET (#{sql_columns_str})
      = (#{sql_placeholder_str(columns_no)})
      WHERE id = $#{columns_no + 1}
    "
    SqlRunner.run(sql, sql_values_array)
  end
end
