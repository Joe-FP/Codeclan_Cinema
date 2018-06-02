require_relative("../db/sql_runner")

class Screening

  attr_reader :id
  attr_accessor :time, :film_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @time = options['time']
    @film_id = options['film_id'].to_i
  end

  def save()
    sql = "INSERT INTO screenings (time, film_id) VALUES ($1, $2) RETURNING id"
    values = [@time, @film_id]
    screening = SqlRunner.run(sql, values)[0];
    @id = screening['id'].to_i
  end

  def update()
    sql = "UPDATE screenings SET (time, film_id) = ($1, $2) WHERE id = $3"
    values = [@time, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE * FROM screenings where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    data = SqlRunner.run(sql)
    return data.map{|screening| Screening.new(screening)}
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

end
