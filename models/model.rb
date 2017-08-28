require_relative "../db/sql_runner"

module Model
  # @table and @columns are required for including Model
  # @id is assumed and shouldn't be included

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

    def find(id)
      sql = "SELECT * FROM #{self.table} WHERE id = $1"
      result = SqlRunner.run(sql, [id])
      return nil if result.to_a.empty?
      return self.new(result.first)
    end

    def select(column, value)
      sql = "SELECT * FROM #{self.table} WHERE #{column} = $1"
      result = SqlRunner.run(sql, [value])
      return nil if result.to_a.empty?
      return self.map_create(result)
    end

    def count(column = nil, value = nil)
      sql = "SELECT COUNT(*) FROM #{self.table}"
      values = []
      if column && value
        sql << " WHERE #{column} = $1"
        values << value
      end
      result = SqlRunner.run(sql, values)
      return result.first["count"]
    end
  end

  def save
    @id.nil? ? save_query : update_query
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
