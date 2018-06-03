require_relative("../db/sql_runner")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  # --------------------
  # MVP
  # --------------------

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    star = SqlRunner.run(sql, values).first
    @id = star['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.* FROM films INNER JOIN tickets ON films.id = tickets.film_id WHERE customer_id = $1"
    values = [@id]
    film_data = SqlRunner.run(sql, values)
    film_data.map{|film| Film.new(film)}
  end

  # --------------------
  # BASIC EXTENSIONS
  # --------------------

  def remaining_budget()
    films = self.films()
    film_prices = films.map{|film| film.price.to_i}
    combined_fees = film_prices.sum
    return @funds - combined_fees
  end

  def tickets()
    sql = "SELECT * FROM tickets WHERE customer_id = $1"
    values = [@id]
    ticket_data = SqlRunner.run(sql, values)
    ticket_data.map{|ticket| Ticket.new(ticket)}
  end

  def ticket_count()
    self.tickets.count
    # - OR -
    # sql = "SELECT COUNT(*) FROM tickets WHERE customer_id = $1"
    # values = [@id]
    # num = SqlRunner.run(sql, values)[0]['count'].to_i
    # which is better?
  end

  # --------------------
  # CLASS METHODS
  # --------------------

  def self.all()
    sql = "SELECT * FROM customers"
    customer_data = SqlRunner.run(sql)
    return Customer.map_items(customer_data)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map{|customer| Customer.new(customer)}
    return result
  end

end
