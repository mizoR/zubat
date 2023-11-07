# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Zubat::Commit do
  before do
    allow(Zubat).to receive(:stubbed?).and_return(true)
  end

  describe '.find' do
    it do
      commits = described_class.find(files: ['hello_world.rb'])

      expect(commits).to be_any.and be_all be_instance_of(described_class)
    end
  end
end
