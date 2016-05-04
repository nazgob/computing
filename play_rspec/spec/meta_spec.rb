require 'spec_helper'
require_relative '../spec.rb'

describe Foo do
  let(:foo) { Foo.new }

  it 'works' do
    expect(subject.buzz).to eq('buzz')
  end

  it 'buzzes barr' do
    expect(subject.buzzbar).to eq('buzzbar')
  end

  it 'stubs instance method' do
    allow(subject).to receive(:foo).and_return(42)
    expect(subject.foo).to eq(42)
  end

  it 'stubs module method' do
    allow(subject).to receive(:bar).and_return('wat')
    expect(subject.buzzbar).to eq('buzzwat')
  end
end

