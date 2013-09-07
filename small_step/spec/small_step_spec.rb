require 'spec_helper'
require_relative '../small_step'

describe Number do
  subject { Number.new(42) }

  its(:to_s) { should eq('42') }
  its(:inspect) { should eq('<42>') }
end

describe 'binary' do
  let(:two) { Number.new(2) }
  let(:four) { Number.new(4) }
  let(:six) { Number.new(6) }
  let(:seven) { Number.new(7) }

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
  end
end
