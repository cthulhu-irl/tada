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

    it "checks info's keys and values types" do
      expect do
        TODO.new(1, '', info: { x: 1 }).info
      end.to raise_error TypeError

      expect do
        TODO.new(1, '', info: { 'x' => 'y' }).info
      end.not_to raise_error
    end

    it "checks sublist's cells types" do
      expect do
        TODO.new(1, '', sublist: [1, 'str']).sublist
      end.to raise_error TypeError

      expect do
        TODO.new(1, '', sublist: [TODO.new(0, '')]).sublist
      end.not_to raise_error
    end
  end

  describe '#match?' do
    let(:todo) { TODO.new(:doing, 'my fancy title') }
    let(:info_todo) do
      TODO.new(
        :todo,
        'project 1',
        info: {
          'note 1' => 'description 1',
          'note 2' => 'description 2',
          'warning' => 'some warning'
        }
      )
    end

    it "checks given ref's type" do
      expect { todo.match?([]) }.to raise_error TypeError

      expect { todo.match?(1) }.not_to raise_error
      expect { todo.match?(1..2) }.not_to raise_error
      expect { todo.match?({}) }.not_to raise_error
      expect { todo.match?(Ref.new(1)) }.not_to raise_error
    end

    it 'matches by given numeric ref and index' do
      expect(todo.match?(1, 1)).to be true
      expect(todo.match?(1, 2)).to be false
      expect(todo.match?(-1, 1)).to be false
    end

    it 'matches by given range and index' do
      expect(todo.match?(0..42)).to be true
      expect(todo.match?(1..42)).to be false

      expect(todo.match?(0..2, 1)).to be true
      expect(todo.match?(0..2, -1)).to be false
      expect(todo.match?(0..2, 3)).to be false
    end

    it 'behaves recursively when given ref as TADA::Ref' do
      expect(todo.match?(Ref.new(0..12))).to be true
      expect(todo.match?(Ref.new(12))).to be false
    end

    it 'matches by given ref if all key/value pairs exist in info too' do
      expect(info_todo.match?({ 'note 1' => /1/ })).to be true
      expect(info_todo.match?({ 'warning' => /some/ })).to be true

      mismatch_regex = { 'note 1' => /1/, 'note 2' => /123/ }
      expect(info_todo.match?(mismatch_regex)).to be false

      mismatch_key = { 'note 1' => /1/, 'note 3' => /1/ }
      expect(info_todo.match?(mismatch_key)).to be false
    end

    it 'matches by title when given String or Regexp' do
      expect(todo.match?('fancy')).to be true
      expect(todo.match?(/^my/)).to be true

      expect(todo.match?('yohoo')).to be false
      expect(todo.match?(/fancy$/)).to be false
    end

    it 'matches by status when given Status or Symbol' do
      expect(todo.match?(:doing)).to be true
      expect(todo.match?(Status.new(:doing))).to be true

      expect(todo.match?(:todo)).to be false
      expect(todo.match?(:done)).to be false
      expect(todo.match?(Status.new(:todo))).to be false
      expect(todo.match?(Status.new(:done))).to be false
    end
  end

  describe 'crud and #move' do
  end

  describe '#at and variants' do
    it 'returns empty array when given no parameter' do
    end

    it 'returns one retrieve per given argument' do
    end
  end
end
