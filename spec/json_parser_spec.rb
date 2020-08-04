# frozen_string_literal: true

require 'tada'

include TADA
include TADA::Parsers

RSpec.describe JSONParser do
  let(:complex) do
    TODO.new(
      :doing, 'root',
      info: { 'note' => 'root node of todo lists' },
      sublist: [
        TODO.new(
          :done, 'authentication system',
          info: { 'note' => 'use JWT' },
          sublist: [
            TODO.new(:done, 'something')
          ]
        ),
        TODO.new(
          :doing, 'database',
          info: { 'use' => 'postgres' },
          sublist: [
            TODO.new(:doing, 'something else')
          ]
        )
      ]
    )
  end

  let(:complex_raw) do
    JP = JSONParser
    {
      JP::KEY_STATUS => JP::STAT_DOING,
      JP::KEY_TITLE => 'root',
      JP::KEY_INFO => { 'note' => 'root node of todo lists' },
      JP::KEY_SUBLIST => [
        {
          JP::KEY_STATUS => JP::STAT_DONE,
          JP::KEY_TITLE => 'authentication system',
          JP::KEY_INFO => { 'note' => 'use JWT' },
          JP::KEY_SUBLIST => [
            {
              JP::KEY_STATUS => JP::STAT_DONE,
              JP::KEY_TITLE => 'something',
              JP::KEY_INFO => {},
              JP::KEY_SUBLIST => []
            }
          ]
        },
        {
          JP::KEY_STATUS => JP::STAT_DOING,
          JP::KEY_TITLE => 'database',
          JP::KEY_INFO => { 'use' => 'postgres' },
          JP::KEY_SUBLIST => [
            {
              JP::KEY_STATUS => JP::STAT_DOING,
              JP::KEY_TITLE => 'something else',
              JP::KEY_INFO => {},
              JP::KEY_SUBLIST => []
            }
          ]
        }
      ]
    }
  end

  describe '::raw_load' do
    it 'deserializes given todo list recursively' do
      loaded = JSONParser.raw_load([complex_raw])
      expect(loaded == [complex]).to be true
    end
  end

  describe '::raw_dump' do
    it 'serializes given todo list recursively' do
      raw = JSONParser.raw_dump([complex])
      expect(raw == [complex_raw]).to be true
    end
  end

  describe '::load' do
    it 'deserializes given json string into raw then todo list' do
      json = JSON.generate([complex_raw])
      expect(JSONParser.load(json) == [complex]).to be true
    end
  end

  describe '::dump' do
    it 'serializes given todo list into raw then json string' do
      json = JSON.pretty_generate([complex_raw])
      expect(JSONParser.dump([complex])).to eql json
    end
  end
end
