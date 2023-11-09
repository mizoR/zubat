# frozen_string_literal: true

require 'zubat'
require 'optparse'

module Zubat
  module CLI
    class App
      Argv = Data.define(:files, :silent, :root) do
        def self.parse!(argv)
          opt = OptionParser.new

          root = nil
          silent = false

          opt.on('--silent', '-s') { silent = true }
          opt.on('--root=ROOT') { |v| root = v }

          files = opt.parse!(argv).uniq

          abort 'no files to process, aborting.' if argv.empty?

          new(files:, silent:, root:)
        end
      end

      class Progress
        include Enumerable

        def initialize(enum, silent:)
          @enum = enum
          @silent = silent
        end

        def each(&block)
          @enum.each_with_index do |elem, i|
            $stderr.print "\r#{%w[| / - \\][i % 4]} Analyzing... #{100 * i / @enum.size}%" unless @silent

            block.call(elem)
          end

          warn "\r✨ Analized                      \n\n" unless @silent

          @enum
        end
      end

      def start(argv)
        argv = Argv.parse!(argv)

        files = argv.files

        results = Dir.chdir(argv.root || Dir.pwd) do
          commits = Zubat::Commit.find(files:)

          Progress
            .new(commits, silent: argv.silent)
            .map { |commit| Zubat::Analizer.new.analize(files:, commit:) }
        end

        file = Generator.new.generate(results:)

        puts "Generated - #{file}\n"
      end
    end
  end
end
