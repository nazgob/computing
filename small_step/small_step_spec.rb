require 'rspec'
require './small_step'

describe Number do
  subject { Number.new(42) }

  its(:to_s) { should eq('42') }
  its(:inspect) { should eq('<42>') }
end

describe 'binary' do
  let(:left) { Number.new(3) }
  let(:right) { Number.new(4) }

  describe Add do
    subject { Add.new(left, right) }

    its(:to_s) { should eq('3 + 4') }
    its(:inspect) { should eq('<3 + 4>') }
  end

  describe Multiply do
    subject { Multiply.new(left, right) }

    its(:to_s) { should eq('3 * 4') }
    its(:inspect) { should eq('<3 * 4>') }
  end
end
