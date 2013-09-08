require 'spec_helper'
require_relative '../small_step'

describe 'SmallStep' do
  let(:two) { Number.new(2) }
  let(:four) { Number.new(4) }
  let(:six) { Number.new(6) }
  let(:seven) { Number.new(7) }
  let(:eight) { Number.new(8) }
  let(:sixteen) { Number.new(16) }
  let(:yes) { Boolean.new(true) }
  let(:empty_env) { Hash.new }

  describe Number do
    subject { Number.new(42) }

    its(:to_s) { should eq('42') }
    its(:inspect) { should eq('<42>') }
    its(:reducible?) { should be_false }
  end

  describe Boolean do
    subject { Boolean.new(true) }

    its(:to_s) { should eq('true') }
    its(:inspect) { should eq('<true>') }
    its(:reducible?) { should be_false }
  end

  describe 'binary' do
    describe Add do
      subject { Add.new(two, four) }

      its(:to_s) { should eq('2 + 4') }
      its(:inspect) { should eq('<2 + 4>') }
      its(:reducible?) { should be_true }
      its(:reduce) { should eq(six) }

      it '#reduce left' do
        operation = Add.new(subject, seven)
        expect(operation.reduce.to_s).to eq('6 + 7')
        expect(operation.reduce.reduce.to_s).to eq('13')
      end

      it '#reduce right' do
        operation = Add.new(seven, subject)
        expect(operation.reduce.to_s).to eq('7 + 6')
        expect(operation.reduce.reduce.to_s).to eq('13')
      end
    end

    describe Multiply do
      subject { Multiply.new(two, four) }

      its(:to_s) { should eq('2 * 4') }
      its(:inspect) { should eq('<2 * 4>') }
      its(:reducible?) { should be_true }
      its(:reduce) { should eq(eight) }

      it '#reduce left' do
        operation = Multiply.new(subject, seven)
        expect(operation.reduce.to_s).to eq('8 * 7')
        expect(operation.reduce.reduce.to_s).to eq('56')
      end

      it '#reduce right' do
        expect(Multiply.new(seven, subject).reduce.to_s).to eq('7 * 8')
      end

    end

    describe LessThen do
      subject { LessThen.new(two, four) }

      let(:reducible_operation) { Multiply.new(two, four) }
      its(:to_s) { should eq('2 < 4') }
      its(:inspect) { should eq('<2 < 4>') }
      its(:reducible?) { should be_true }
      its(:reduce) { should eq(yes) }

      it '#reduce left' do
        operation = LessThen.new(reducible_operation, seven)
        expect(operation.reduce.to_s).to eq('8 < 7')
        expect(operation.reduce.reduce.to_s).to eq('false')
      end

      it '#reduce right' do
        operation = LessThen.new(seven, reducible_operation)
        expect(operation.reduce.to_s).to eq('7 < 8')
        expect(operation.reduce.reduce.to_s).to eq('true')
      end
    end
  end

  describe Machine do
    it 'reduces complex expressions' do
      x = Multiply.new(two, four)
      y = Add.new(six, two)
      z = Add.new(x, y)

      expect(Machine.new(z, empty_env).run).to eq(sixteen)
    end

    it 'works with variables' do
      x = Variable.new(:x)
      y = Variable.new(:y)
      z = Multiply.new(x, y)
      env = { :x => Number.new(2), :y => Number.new(3) }

      expect(Machine.new(z, env).run.to_s).to eq('6')
    end
  end

end
