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

          files = opt.parse!(argv)

          abort 'no files to process, aborting.' if files.empty? && argv.empty?

          Dir.chdir(root || Dir.pwd) do
            files = files.uniq
          end

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

        generator = Generator.new

        results = Dir.chdir(argv.root || Dir.pwd) do
          files = argv.files

          analizer = Zubat::Analizer.new

          commits = Zubat::Commit.find(files:)

          progress = Progress.new(commits, silent: argv.silent)

          progress.map { |commit| analizer.analize(files:, commit:) }
        end

        file = generator.generate(results:)

        puts "Generated - #{file}\n"
      end
    end
  end
end
