require "pg"

class SqlRunner
  @@dbname = "cash_money_board"
  @@host = "localhost"

  def SqlRunner.run(sql, values = [])
    begin
      db = PG.connect({ dbname: @@dbname, host: @@host })
      if values.empty?
        pg_result = db.exec(sql)
      else
        db.prepare("query", sql)
        pg_result = db.exec_prepared("query", values)
      end
    ensure
      db.close if db
    end
    return pg_result
  end

  def SqlRunner.delete_all(table)
    run("DELETE FROM #{table}")
  end

  def SqlRunner.all(table)
    run("SELECT * FROM #{table}")
  end

  def SqlRunner.find(table, id)
    sql = "SELECT * FROM #{table} WHERE id = $1"
    run(sql, [id])
  end

  def SqlRunner.select(table, options = {})
    sql = "SELECT * FROM #{table}"
    values = []
    where(sql, values, options) unless options.empty?
    run(sql, values)
  end

  def SqlRunner.count(table, options = {})
    sql = "SELECT COUNT(*) FROM #{table}"
    values = []
    where(sql, values, options) unless options.empty?
    run(sql, values)
  end

  def SqlRunner.save(instance)
    columns = instance.class.columns
    sql = "
      INSERT INTO #{instance.class.table}
      (#{columns.join(", ")})
      VALUES (#{placeholder_str(columns.count)})
      RETURNING id
    "
    values = instance.values_array(with_id = false)
    run(sql, values)
  end

  def SqlRunner.update(instance)
    columns = instance.class.columns
    sql = "
      UPDATE #{instance.class.table}
      SET (#{columns.join(", ")})
      = (#{placeholder_str(columns.count)})
      WHERE id = $#{columns.count + 1}
    "
    values = instance.values_array
    run(sql, values)
  end

  def SqlRunner.delete(instance)
    sql = "DELETE FROM #{instance.class.table} WHERE id = $1"
    run(sql, [instance.id])
  end

  private
  def SqlRunner.placeholder_str(length)
    (2..length).inject("$1") {|str, x| str << ", $#{x}"}
  end

  def SqlRunner.where(sql, values, options)
    sql << " WHERE"
    options.keys.each_with_index do |column, i|
      sql << " #{column} = $#{i + 1}"
      sql << " AND" if i + 1 < options.keys.count
      values << options[column]
    end
  end

  # @where = lambda do |sql, values, options|
  #   sql << " WHERE"
  #   options.keys.each_with_index do |column, i|
  #     sql << " #{column} = $#{i + 1}"
  #     sql << " AND" if i + 1 < options.keys.count
  #     values << options[column]
  #   end
  # end
end
