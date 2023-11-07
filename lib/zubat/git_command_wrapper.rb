# frozen_string_literal: true

require 'json'
require 'time'
require 'securerandom'

module Zubat
  class GitCommandWrapper
    module Stub
      def log(files:)
        logs = files.map do
          Log.new(sha: SecureRandom.hex(3), time: Time.at(rand(1_900_000_000..1_900_999_999)), author: 'bot')
        end

        logs.sort_by!(&:time)

        logs
      end

      def exists?(sha:, file:)
        true
      end

      def show(sha:, file:)
        <<~SCRIPT
          class HelloWorld
            def show
              puts "Hello World"
            end
          end
        SCRIPT
      end
    end

    Log = Data.define(:sha, :time, :author)

    def self.new
      instance = super
      instance.extend(Stub) if Zubat.stubbed?
      instance
    end

    def log(files:)
      logs = `git log --oneline --pretty=format:'{ "sha": "%h", "time": "%ad", "author": "%aN" }' -- #{files.join(' ')}`.split("\n")

      logs.map do |log|
        args = JSON.parse(log, symbolize_names: true)

        Log.new(sha: args[:sha], time: Time.parse(args[:time]), author: args[:author])
      end
    end

    def exists?(sha:, file:)
      !`git ls-tree -r #{sha} -- #{file} 2>/dev/null`.empty?
    end

    def show(sha:, file:)
      `git show #{sha}:#{file}`
    end
  end
end
