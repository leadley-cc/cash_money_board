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
    def map_create(hashes)
      return hashes.map {|hash| self.new(hash)}
    end

    def delete_all
      SqlRunner.delete_all(self.table)
    end

    def all
      self.map_create(SqlRunner.all(self.table))
    end

    def find(id)
      result = SqlRunner.find(self.table, [id]).to_a
      return nil if result.empty?
      return self.new(result.first)
    end

    def select(column, value)
      result = SqlRunner.select(self.table, {column => value}).to_a
      return nil if result.empty?
      # This should actually be fine without the line above as long as we check empty? rather than nil? where the result is used.
      return self.map_create(result)
    end

    def count(column = nil, value = nil)
      options = {}
      options[column] = value if column && value
      return SqlRunner.count(self.table, options).first["count"]
    end
  end

  def save
    result = SqlRunner.save(self)
    @id = result[0]["id"]
  end

  def update
    SqlRunner.update(self)
  end

  def delete
    SqlRunner.delete(self)
  end

  def print_money(message)
    str = send(message).to_s
    while str.length < 3 do
      str.prepend("0")
    end
    return '£' << str.insert(-3,'.')
  end

  def values_array(with_id = true)
    # array = []
    # columns.each do |column|
    #   array << send(column)
    # end
    array = self.class.columns.inject([]) do |array, column|
      array << send(column)
    end
    array << @id if with_id
    return array
  end
end
