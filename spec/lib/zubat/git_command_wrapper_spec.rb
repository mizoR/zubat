# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Zubat::GitCommandWrapper do
  let(:wrapper) { described_class.new }

  context 'when stubbed' do
    before do
      allow(Zubat).to receive(:stubbed?).and_return(true)
    end

    describe '#log' do
      it do
        expect(wrapper.singleton_class.include?(described_class::Stub)).to be(true)

        logs = wrapper.log(files: ['hello_world.rb'])

        expect(logs.size).to eq(1)

        expect(logs).to be_all be_instance_of(described_class::Log)
      end
    end

    describe '#exists?' do
      it do
        expect(wrapper.singleton_class.include?(described_class::Stub)).to be(true)

        exists = wrapper.exists?(sha: 'abcdefg', file: 'hello_world.rb')

        expect(exists).to be(true)
      end
    end

    describe '#show' do
      it do
        expect(wrapper.singleton_class.include?(described_class::Stub)).to be(true)

        shown = wrapper.show(sha: 'abcdefg', file: 'hello_world.rb')

        expect(shown).to be_instance_of(String).and start_with('class HelloWorld')
      end
    end
  end

  describe '#log' do
    it do
      logs = wrapper.log(files: ['lib/zubat.rb'])

      expect(logs.size).to be >= 1

      expect(logs).to be_all be_instance_of(described_class::Log)
    end
  end

  describe '#exists?' do
    it do
      exists = wrapper.exists?(sha: '09b3414', file: 'lib/zubat.rb')

      expect(exists).to be(true)
    end
  end

  describe '#show' do
    it do
      shown = wrapper.show(sha: '09b3414', file: 'lib/zubat.rb')

      expect(shown).to be_instance_of(String)
    end
  end
end
