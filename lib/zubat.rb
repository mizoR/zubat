# frozen_string_literal: true

require_relative 'zubat/analizer'
require_relative 'zubat/commit'
require_relative 'zubat/flog_wrapper'
require_relative 'zubat/generator'
require_relative 'zubat/git_command_wrapper'
require_relative 'zubat/reek_wrapper'
require_relative 'zubat/ruby_code'
require_relative 'zubat/version'

module Zubat
  class Error < StandardError; end

  def self.stubbed=(stubbed)
    @stubbed = stubbed
  end

  def self.stubbed?
    !!@stubbed
  end

  def self.root
    Pathname.new("#{__dir__}/..")
  end
end
