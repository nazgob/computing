module Inspectable
  def inspect
    "<#{self}>"
  end
end

module BinaryOp
  def reducible?
    true
  end

  def reduce
    if left.reducible?
      self.class.new(left.reduce, right)
    elsif right.reducible?
      self.class.new(left, right.reduce)
    else
      Number.new(operator(left.value, right.value))
    end
  end
end

class Number < Struct.new(:value)
  include Inspectable

  def reducible?
    false
  end

  def to_s
    value.to_s
  end

end

class Boolean < Struct.new(:value)
  include Inspectable

  def reducible?
    false
  end

  def to_s
    value.to_s
  end

end

class Add < Struct.new(:left, :right)
  include Inspectable
  include BinaryOp

  def to_s
    "#{left} + #{right}"
  end

  private
  def operator(left, right)
    left + right
  end

end

class Multiply < Struct.new(:left, :right)
  include Inspectable
  include BinaryOp

  def to_s
    "#{left} * #{right}"
  end

  private
  def operator(left, right)
    left * right
  end
end

class LessThen < Struct.new(:left, :right)
  include Inspectable

  def to_s
    "#{left} < #{right}"
  end

  def reducible?
    true
  end

  def reduce
    if left.reducible?
      self.class.new(left.reduce, right)
    elsif right.reducible?
      self.class.new(left, right.reduce)
    else
      Boolean.new(left.value < right.value)
    end
  end

end

class Machine < Struct.new(:expression)
  def run
    while expression.reducible?
      # puts expression
      step
    end
    expression
  end

  private
  def step
    self.expression = expression.reduce
  end

end
