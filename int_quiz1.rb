=begin 

Q1. Ben is right because the attr_reader creates a new method call "balance"
    The body of positive_balance? will call the method and return the balance
    value to be used for comparison.

Q2. Quantity cannot be updated. The attr_reader needs to be revised to attr_accessor.
    Alternatively the instance variable notation can be used to allow the variable
    to be accessed.

Q3. It gives write access to the product name and quantity.

Q4.
=end
class Greeting
  def greet(greeting)
    puts greeting
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

=begin
  
Q5. 
=end
class KrispyKreme
  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end

  def to_s
    print @filling_type ? "#{@filling_type}" : "Plain"
    puts @glazing ? " with #{@glazing}" : nil
  end
end

=begin
  
Q6. No difference. @template and self.template will perform the same with the
    attr_accessor method present. self is not required for reading with the attr
    accessor method.

Q7. def information since it will be called by the Light class anyway.
