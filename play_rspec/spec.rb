module Bazz
  def buzz
    'buzz'.freeze
  end

  def bar
    'bar'.freeze
  end

  def buzzbar
    buzz + bar
  end
end

class Foo
  include Bazz

  def foo
    'foo'.freeze
  end
end

