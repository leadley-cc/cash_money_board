require_relative "sql_runner"

class SqlQuery
  def initialize(table, sql = "", values = [])
    @table, @sql, @values = table, sql, values
  end

  def delete
    @sql << "DELETE FROM #{@table}"
    return self
  end

  def select
    @sql << "SELECT * FROM #{@table}"
    return self
  end

  def count
    @sql << "SELECT COUNT(*) FROM #{@table}"
    return self
  end

  def insert_into(columns, values)
    @sql << "
      INSERT INTO #{@table}
      (#{columns.join(", ")})
      VALUES (#{placeholder_str(columns.count)})
      RETURNING id
    "
    @values = values
    return self
  end

  def update(columns, values)
    @sql << "
      UPDATE #{@table}
      SET (#{columns.join(", ")})
      = (#{placeholder_str(columns.count)})
      WHERE id = $#{columns.count + 1}
    "
    @values = values
    return self
  end

  def where(options)
    return self if options.empty?
    @sql << " WHERE"
    options.keys.each_with_index do |column, i|
      @sql << " #{column} = $#{i + 1}"
      @sql << " AND" if i + 1 < options.keys.count
      @values << options[column]
    end
    return self
  end

  def inner_join(join_table, reverse = false)
    @sql << " INNER JOIN #{join_table}"
    if reverse
      @sql << " ON #{@table}.#{join_table[0..-2]}_id = #{join_table}.id"
    else
      @sql << " ON #{@table}.id = #{join_table}.#{@table[0..-2]}_id"
    end
    return self
  end

  def print
    puts @sql
    return self
  end

  def run
    return SqlRunner.run(@sql, @values)
  end

  private
  def placeholder_str(length)
    (2..length).inject("$1") {|str, x| str << ", $#{x}"}
  end
end
