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
        expect(Add.new(subject, seven).reduce.to_s).to eq('6 + 7')
      end

      it '#reduce right' do
        expect(Add.new(seven, subject).reduce.to_s).to eq('7 + 6')
      end
    end

    describe Multiply do
      subject { Multiply.new(two, four) }

      its(:to_s) { should eq('2 * 4') }
      its(:inspect) { should eq('<2 * 4>') }
      its(:reducible?) { should be_true }
      its(:reduce) { should eq(eight) }

      it '#reduce left' do
        expect(Multiply.new(subject, seven).reduce.to_s).to eq('8 * 7')
      end

      it '#reduce right' do
        expect(Multiply.new(seven, subject).reduce.to_s).to eq('7 * 8')
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
  end

  describe Machine do
    it 'works' do
      x = Multiply.new(two, four)
      y = Add.new(six, two)
      z = Add.new(x, y)
      expect(Machine.new(z).run).to eq(sixteen)
    end
  end

end
