#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'time'
require 'reek'

module Zubat
  class ReekWrapper
    Smell = Data.define(:smell_type)

    def examine(code)
      smells = Reek::Examiner.new(String.new(code)).smells

      smells.map { |smell| Smell.new(smell_type: smell.smell_type) }
    end
  end
end
