module Inspectable
  def inspect
    "<#{self}>"
  end
end

module BinaryOp
  def reducible?
    true
  end

  def reduce(env = nil)
    if left.reducible?
      self.class.new(left.reduce(env), right)
    elsif right.reducible?
      self.class.new(left, right.reduce(env))
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

class Variable < Struct.new(:name)
  include Inspectable

  def reducible?
    true
  end

  def reduce(env)
    env[name]
  end

  def to_s
    name.to_s
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

  def reduce(env = nil)
    if left.reducible?
      self.class.new(left.reduce(env), right)
    elsif right.reducible?
      self.class.new(left, right.reduce(env))
    else
      Boolean.new(left.value < right.value)
    end
  end

end

class Machine < Struct.new(:statement, :env)
  def run
    while statement.reducible?
      # puts "#{statement}, #{env}"
      step
    end
    # puts "#{statement}, #{env}"
    statement
  end

  private
  def step
    self.statement, self.env = statement.reduce(env)
  end
end

class DoNothing
  include Inspectable

  def to_s
    'do-nothing'
  end

  def ==(other_statement)
    other_statement.instance_of?(self.class)
  end

  def reducible?
    false
  end
end

class Assign < Struct.new(:name, :expression)
  include Inspectable

  def to_s
    "#{name} = #{expression}"
  end

  def reducible?
    true
  end

  def reduce(env)
    if expression.reducible?
      [Assign.new(name, expression.reduce(env)), env]
    else
      [DoNothing.new, env.merge({name => expression})]
    end
  end

end

class If < Struct.new(:condition, :consequence, :alternative)
  include Inspectable

  def to_s
    "if (#{condition}) { #{consequence} } else { #{alternative} }"
  end

  def reducible?
    true
  end

  def reduce(env)
    if condition.reducible?
      [If.new(condition.reduce(env), consequence, alternative), env]
    else
      case condition
      when Boolean.new(true)
        [consequence, env]
      when boolean.new(false)
        [alternative, env]
      end
    end
  end
end
