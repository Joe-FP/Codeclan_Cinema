require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/screening')

require('pry-byebug')

Customer.delete_all()
Film.delete_all()
Screening.delete_all()
Ticket.delete_all()

# add customers (3)
customer1 = Customer.new({'name'=>'Customer1', 'funds'=>50})
customer1.save()
customer2 = Customer.new({'name'=>'Customer2', 'funds'=>100})
customer2.save()
customer3 = Customer.new({'name'=>'Customer3', 'funds'=>150})
customer3.save()

# add films (2)
film1 = Film.new({'title'=>'film1', 'price'=>10})
film1.save()
film2 = Film.new({'title'=>'film2', 'price'=>15})
film2.save()

# # add screenings (2 per film)
screening1_film1 = Screening.new({'time'=>'9:00','film_id'=>film1.id})
screening1_film1.save()
screening2_film1 = Screening.new({'time'=>'10:30','film_id'=>film1.id})
screening2_film1.save()
screening1_film2 = Screening.new({'time'=>'9:00','film_id'=>film2.id})
screening1_film2.save()
screening2_film2 = Screening.new({'time'=>'10:30','film_id'=>film2.id})
screening2_film2.save()

# add tickets
ticket1 = Ticket.new({'customer_id'=>customer1.id, 'film_id'=>film1.id, 'screening_id'=>screening1_film1.id})
ticket1.save()
ticket2 = Ticket.new({'customer_id'=>customer2.id, 'film_id'=>film1.id, 'screening_id'=>screening1_film1.id})
ticket2.save()
ticket3 = Ticket.new({'customer_id'=>customer3.id, 'film_id'=>film1.id, 'screening_id'=>screening2_film1.id})
ticket3.save()
ticket4 = Ticket.new({'customer_id'=>customer2.id, 'film_id'=>film2.id, 'screening_id'=>screening2_film2.id})
ticket4.save()
ticket5 = Ticket.new({'customer_id'=>customer3.id, 'film_id'=>film1.id, 'screening_id'=>screening1_film1.id})
ticket5.save()

# -------------------------
# Test some CRUD actions.
# -------------------------

# customer1.delete() # should remove ticket1
# customer2.name = "Joe"
# customer2.update()
#
# film2.delete() # should remove ticket4, screening1_film2, screening2_film2
# film1.title = "film1 new title"
# film1.update()
#
# screening1_film1.delete() #should remove ticket2
# screening2_film1.time = "14:00"
# screening2_film1.update()
#
# ticket5.delete() # only ticket4 is left

binding.pry
nil
