# frozen_string_literal: true

require 'tada/ref'

include TADA

RSpec.describe Ref do
  it 'flattens arguments' do
    expect(
      Ref.new([[12, [12..24]], {}], { 'a' => /a/ }).to_a
    ).to eql [12, 12..24, {}, { 'a' => /a/ }]
  end

  it 'raises TypeError when invalid type' do
    expect { Ref.new(12.1) }.to raise_error TypeError
    expect { Ref.new({ a: /a/ }) }.to raise_error TypeError
  end

  it '#singular?' do
    expect(Ref.new(12).singular?).to be true
    expect(Ref.new({ 'a' => /a/ }).singular?).to be true
    expect(Ref.new(1..2, 12).singular?).to be false
    expect(Ref.new([1, 2, 3]).singular?).to be false
  end

  it '#first' do
    expect(Ref.new(12).first).to be 12
    expect(Ref.new(1, 2, 3, 4).first).to be 1
    expect(Ref.new.first).to be nil
  end

  it '#rest' do
    expect(Ref.new.rest).to eql []
    expect(Ref.new(1).rest).to eql []
    expect(Ref.new(1, 2, 3).rest).to eql [2, 3]
  end
end
