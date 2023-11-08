# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Zubat::Analizer do
  before do
    allow(Zubat).to receive(:stubbed?).and_return(true)
  end

  describe '.find' do
    it do
      files = ['hello_world.rb']

      commit = Zubat::Commit.find(files:).first

      result = described_class.new.analize(files:, commit:)

      expect(result.label).to be_instance_of(String)

      expect(result.label.size).to be > 0

      expect(result.stat).to eq(
        described_class::Stat.new(
          stat: {
            'hello_world.rb' => {
              average: 1,
              total_score: 1,
              smells: { 'IrresponsibleModule' => 1 }
            }
          }
        )
      )
    end
  end
end
