#!/usr/bin/env ruby
# frozen_string_literal: true

require 'tempfile'
require 'flog'

module Zubat
  class FlogWrapper
    Flog = Data.define(:average, :total_score)

    def examine(code)
      flog = ::Flog.new

      Tempfile.open do |file|
        file.print(code)

        file.close

        flog.flog(file.path)

        Flog.new(average: flog.average, total_score: flog.total_score)
      end
    end
  end
end
