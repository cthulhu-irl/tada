# frozen_string_literal: true

require 'tada/status'

include TADA

RSpec.describe Status do
  describe '::to_i' do
    it 'returns given parameter when it is integer' do
      expect(Status.to_i(1)).to be 1
    end

    it 'raises TypeError when given integer out of 0..2 range' do
      expect { Status.to_i(-1) }.to raise_error TypeError
      expect { Status.to_i(3) }.to raise_error TypeError
    end

    it 'returns 0,1,2 on :todo,:doing,:done symbols' do
      expect(Status.to_i(:todo)).to be 0
      expect(Status.to_i(:doing)).to be 1
      expect(Status.to_i(:done)).to be 2
    end

    it "returns 0,1,2 on '-','x','+' strings" do
      expect(Status.to_i('-')).to be 0
      expect(Status.to_i('x')).to be 1
      expect(Status.to_i('+')).to be 2
    end

    it 'raises TypeError when given unknown symbol/string' do
      expect { Status.to_i('a') }.to raise_error(TypeError)
      expect { Status.to_i('wrong') }.to raise_error(TypeError)

      expect { Status.to_i(:ondo) }.to raise_error(TypeError)
      expect { Status.to_i(:wrong) }.to raise_error(TypeError)
    end

    it 'returns stat.to_i when given Status type parameter stat' do
      expect(Status.to_i(Status.new(2))).to be 2
    end

    it 'raises TypeError when given unexpected parameter type' do
      expect { Status.to_i({ todo: 2 }) }.to raise_error TypeError
    end
  end
end
