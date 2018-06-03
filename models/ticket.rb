require_relative("../db/sql_runner")

class Ticket

  attr_reader :id, :customer_id, :film_id, :screening_id

  # --------------------
  # MVP
  # --------------------

  def initialize(options)
    @screening_id = options['screening_id'].to_i
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
  end

  def save()
    # Get the screening related to this ticket, which is about to be saved.
    sql = "SELECT * FROM screenings WHERE screenings.id = $1"
    values = [@screening_id]
    screening_data = SqlRunner.run(sql,values)[0]
    screening = Screening.new(screening_data)
    # Ensure that the tickets_sold for this screening doesn't exceed the maximum.
    # If max tickets have been sold, return without saving.
    return if screening.tickets_sold >= screening.max_tickets
    sql = "INSERT INTO tickets (customer_id, film_id, screening_id) VALUES ($1, $2, $3) RETURNING id"
    values = [@customer_id, @film_id, @screening_id]
    ticket = SqlRunner.run(sql, values)[0];
    @id = ticket['id'].to_i
  end

  def update()
    sql = "UPDATE tickets SET (customer_id, film_id, screening_id) = ($1, $2, $3) WHERE id = $4"
    values = [@customer_id, @film_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  # --------------------
  # ADVANCED EXTENSIONS
  # --------------------

  def time
    sql = "SELECT screenings.time FROM screenings WHERE screenings.id = $1"
    values = [@screening_id]
    time = SqlRunner.run(sql,values)[0]['time']
  end

  # --------------------
  # CLASS METHODS
  # --------------------

  def self.all()
    sql = "SELECT * FROM tickets"
    data = SqlRunner.run(sql)
    return data.map{|ticket| Ticket.new(ticket)}
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

end
