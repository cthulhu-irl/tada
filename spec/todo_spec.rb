# frozen_string_literal: true

require 'tada'

include TADA

RSpec.describe TODO do
  describe '#initialize' do
    it 'raises TypeError when given wrong types' do
      # wrong type parameters
      expect { TODO.new({}, '') }.to raise_error TypeError
      expect { TODO.new(1, {}) }.to raise_error TypeError
      expect { TODO.new(1, '', info: []) }.to raise_error TypeError
      expect { TODO.new(1, '', sublist: {}) }.to raise_error TypeError
      # correct type parameters
      expect { TODO.new(1, '') }.not_to raise_error
    end

    it 'accepts other forms of status as Status class accepts' do
      expect(TODO.new('-', 'title').status.to_i).to eql 0
      expect(TODO.new(0, 'title').status.to_i).to eql 0
      expect(TODO.new(:todo, 'title').status.to_i).to eql 0
      expect(TODO.new(Status.new(0), '').status.to_i).to eql 0
    end

    it "doesn't check info's keys and values types" do
      expect(TODO.new(1, '', info: { x: 1 }).info).to eql({ x: 1 })
    end

    it "doesn't check sublist's cells types" do
      expect(TODO.new(1, '', sublist: [1]).sublist).to eql([1])
    end
  end

  describe '#match?' do
    it 'matches by given numeric ref and index' do
      todo = TODO.new(1, '')

      expect(todo.match?(1, 1)).to be true
      expect(todo.match?(1, 2)).to be false
      expect(todo.match?(-1, 1)).to be false
    end

    it 'matches by given range and index' do
    end

    it 'behaves recursively when given ref as TADA::Ref' do
    end

    it 'matches by given ref if all key/value pairs exist in info too' do
    end
  end

  describe 'crud and #move' do
  end

  describe '' do
    it 'returns empty array when given no parameter' do
    end

    it 'returns one retrieve per given argument' do
    end
  end
end
