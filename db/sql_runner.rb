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
end
