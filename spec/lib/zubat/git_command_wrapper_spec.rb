# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Zubat::GitCommandWrapper do
  let(:wrapper) { described_class.new }

  context 'when stubbed' do
    before do
      allow(Zubat).to receive(:stubbed?).and_return(true)
    end

    describe '#log' do
      it 'returns logs' do
        expect(wrapper.singleton_class.include?(described_class::Stub)).to be(true)

        expect(wrapper.log(files: ['hello_world.rb'])).to be_any.and be_all be_instance_of(described_class::Log)
      end
    end

    describe '#exists?' do
      it 'exists' do
        expect(wrapper.singleton_class.include?(described_class::Stub)).to be(true)

        expect(wrapper.exists?(sha: 'abcdefg', file: 'hello_world.rb')).to be(true)
      end
    end

    describe '#show' do
      it 'shows source code' do
        expect(wrapper.singleton_class.include?(described_class::Stub)).to be(true)

        expect(wrapper.show(sha: 'abcdefg',
                            file: 'hello_world.rb')).to be_instance_of(String).and start_with('class HelloWorld')
      end
    end
  end

  describe '#log' do
    it 'logs' do
      expect(wrapper.log(files: ['lib/zubat.rb'])).to be_any.and be_all be_instance_of(described_class::Log)
    end
  end

  describe '#exists?' do
    it 'exists' do
      expect(wrapper.exists?(sha: '09b3414', file: 'lib/zubat.rb')).to be(true)
    end
  end

  describe '#show' do
    it 'shows source code' do
      expect(wrapper.show(sha: '09b3414', file: 'lib/zubat.rb')).to be_instance_of(String)
    end
  end
end
