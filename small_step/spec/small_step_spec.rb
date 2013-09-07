require 'spec_helper'
require_relative '../small_step'

describe 'SmallStep' do
  let(:two) { Number.new(2) }
  let(:four) { Number.new(4) }
  let(:six) { Number.new(6) }
  let(:seven) { Number.new(7) }
  let(:eight) { Number.new(8) }
  let(:sixteen) { Number.new(16) }

  describe Number do
    subject { Number.new(42) }

    its(:to_s) { should eq('42') }
    its(:inspect) { should eq('<42>') }
  end

  describe 'binary' do
    describe Add do
      subject { Add.new(two, four) }

      its(:to_s) { should eq('2 + 4') }
      its(:inspect) { should eq('<2 + 4>') }
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
      its(:reduce) { should eq(eight) }

      it '#reduce left' do
        expect(Multiply.new(subject, seven).reduce.to_s).to eq('8 * 7')
      end

      it '#reduce right' do
        expect(Multiply.new(seven, subject).reduce.to_s).to eq('7 * 8')
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
