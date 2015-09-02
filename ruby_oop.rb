=begin

Chapter 1----------

Q1. An object is created in ruby by creating an instance of a class.
An example would be:
arr = Array.new
This is a new instance of the array class.

Q2. A module is a collection of methods that can be passed to another object.
If you wanted multiiple classes to contain the same methods you could use a module
to share the methods with each.

module SomeModule
end

class MyClass
  include SomeModule
end

Chapter 2 ----------

Q1.

=

class MyCar

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def speed_up
    self.speed += 10
  end

  def brake
    self.speed -= 10
  end

  def shut_off
    self.speed = 0
  end

  def spray_paint(new_color)
    self.color = new_color
  end

  attr_accessor :color, :model, :speed
  attr_reader :year
end

# Chapter 3 ----------

class MyCar

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def speed_up
    self.speed += 10
  end

  def brake
    self.speed -= 10
  end

  def shut_off
    self.speed = 0
  end

  def spray_paint(new_color)
    self.color = new_color
  end

  def self.gas_mileage(km, litres)
    @gas_mileage = km / litres
  end

  def to_s
    puts "My car was made in #{self.year}, it's color is #{self.color} and it's a #{self.model}."
  end

  attr_accessor :color, :model, :speed
  attr_reader :year
end

betty = MyCar.new(2000, "blue", "honda")
puts betty

=begin
  
Q3. The class does not have writing priviledges as it was only given the attr_reader instead of
the attr_accessor or attr_writer.


Chapter 4 ----------

Q1. 
=end
=begin

module Tailgateable
  def tailgate
    puts "You lowered the tailgate"
  end
end

class Vehicle

  @@number_of_vehicles = 0

  def self.print_total_vehicles
    puts "There have been #{@@number_of_vehicles} vehicles created."
  end

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
    @@number_of_vehicles += 1
  end

  def speed_up
    self.speed += 10
  end

  def brake
    self.speed -= 10
  end

  def shut_off
    self.speed = 0
  end

  def spray_paint(new_color)
    self.color = new_color
  end

  def gas_mileage(km, litres)
    @gas_mileage = km / litres
  end

  attr_accessor :color, :model, :speed
  attr_reader :year

  private

  def age
    Time.now.year - self.year
  end

end

class MyCar < Vehicle

  def initialize(car_type, year, color, model)
    @car_type = car_type
    super(year, color, model)
  end

  def to_s
    puts "My #{self.car_type} car was made in #{self.year}, it is #{age} years old, it's color is #{self.color} and it's a #{self.model}."
  end

  attr_reader :car_type
end

class MyTruck < Vehicle
 
 include Tailgateable
 def initialize(truck_type, year, color, model)
    @truck_type = truck_type
    super(year, color, model)
  end

  def to_s
    puts "My #{self.truck_type} truck was made in #{self.year}, it is #{age} years old, it's color is #{self.color} and it's a #{self.model}."
  end

  attr_reader :truck_type
end

betty = MyCar.new("sedan", 2010, "black", "acura")
brute = MyTruck.new("pickup", 1998, "red", "dodge ram")

puts betty
puts brute

Vehicle.print_total_vehicles
brute.tailgate

puts MyCar.ancestors
puts MyTruck.ancestors

=end
=begin
  
Q7.
=end
=begin
class Student

  attr_reader :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_then?(other_name)
    puts grade > other_name.grade
  end

  protected
  attr_reader :grade

end

bill = Student.new("Bill", 80)
fred = Student.new("Fred", 70)

puts bill.name
bill.better_grade_then?(fred)


Q8. The method being called is private. It could be moved outside of the private section of the class. 