require_relative "../db/sql_runner"
require_relative "../db/sql_query"

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
      return SqlQuery.new(self.table).delete.run
    end

    def all
      result = SqlQuery.new(self.table).select.run
      return self.map_create(result)
    end

    def find(id)
      result = SqlQuery.new(self.table)
                       .select
                       .where( { "id" => id } )
                       .run
      return nil if result.to_a.empty?
      return self.new(result.first)
    end

    def select(column, value)
      result = SqlQuery.new(self.table)
                       .select
                       .where( { column => value } )
                       .run
      return self.map_create(result)
    end

    def count(column = nil, value = nil)
      options = {}
      options[column] = value if column && value
      return SqlQuery.new(self.table)
                     .count
                     .where( options )
                     .run
                     .first["count"]
    end
  end

  def save
    columns = self.class.columns
    values = values_array(with_id = false)
    result = SqlQuery.new(self.class.table)
                     .insert_into(columns, values)
                     .run
    @id = result[0]["id"]
  end

  def update
    columns = self.class.columns
    SqlQuery.new(self.class.table)
            .update(columns, values_array)
            .run
  end

  def delete
    SqlQuery.new(self.class.table)
            .delete
            .where({ "id" => @id })
            .run
  end

  def print_money(message)
    str = send(message).to_s
    while str.length < 3 do
      str.prepend("0")
    end
    return '£' << str.insert(-3,'.')
  end

  def values_array(with_id = true)
    array = self.class.columns.inject([]) do |array, column|
      array << send(column)
    end
    array << @id if with_id
    return array
  end
end
