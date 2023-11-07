# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Zubat::RubyCode do
  describe '#valid?' do
    it do
      expect(described_class.new(code: 'puts "hello world"').valid?).to be(true)

      # missing closing quote
      expect(described_class.new(code: 'puts "hello world').valid?).to be(false)
    end
  end
end
