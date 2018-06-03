require_relative("../db/sql_runner")

class Film
  attr_reader :id
  attr_accessor :title, :price

  # --------------------
  # MVP
  # --------------------

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price']
  end

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values).first
    @id = film['id'].to_i
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id WHERE film_id = $1"
    values = [@id]
    customer_data = SqlRunner.run(sql, values)
    customer_data.map{|customer| Customer.new(customer)}
  end

  # --------------------
  # BASIC EXTENSIONS
  # --------------------

  def customer_count
    self.customers.count
  end

  # --------------------
  # ADVANCED EXTENSIONS
  # --------------------

  def screenings()
    sql = "SELECT * FROM screenings WHERE film_id = $1"
    values = [@id]
    screening_data = SqlRunner.run(sql, values)
    screening_data.map{|screening| Screening.new(screening)}
  end

  def tickets()
    sql = "SELECT * FROM tickets WHERE tickets.film_id = $1"
    values = [@id]
    ticket_data = SqlRunner.run(sql, values)
    ticket_data.map{|ticket| Ticket.new(ticket)}
  end

  def most_popular_time
    times = []
    hash = Hash.new(0)
    self.tickets.each {|ticket| times << ticket.time}
    times.each {|time| hash[time] += 1}
    hash.max_by{|k,v| v}[0]
  end

  # --------------------
  # CLASS METHODS
  # --------------------

  def self.all()
    sql = "SELECT * FROM films"
    film_data = SqlRunner.run(sql)
    return Film.map_items(film_data)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map{|film| Film.new(film)}
    return result
  end

end
