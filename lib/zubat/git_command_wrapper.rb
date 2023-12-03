# frozen_string_literal: true

require 'json'
require 'time'
require 'securerandom'

module Zubat
  class GitCommandWrapper
    module Stub
      def remote_origin_url
        "https://github.com/mizoR/zubat.git"
      end

      def log(files:)
        logs = files.map do
          Log.new(sha: SecureRandom.hex(3), time: Time.at(rand(1_900_000_000..1_900_999_999)))
        end

        logs.sort_by!(&:time)

        logs.reverse!

        logs
      end

      def exists?(sha:, file:) # rubocop:disable Lint/UnusedMethodArgument
        true
      end

      def show(sha:, file:) # rubocop:disable Lint/UnusedMethodArgument
        <<~SCRIPT
          class HelloWorld
            def show
              puts "Hello World"
            end
          end
        SCRIPT
      end

      def diff(sha:, file:) # rubocop:disable Lint/UnusedMethodArgument
        <<~SCRIPT
          diff --git a/hello_world.rb b/hello_world.rb
            class HelloWorld
              def show
          +      puts "Hello World"
              end
            end
        SCRIPT
      end
    end

    Log = Data.define(:sha, :time)

    def self.new
      instance = super
      instance.extend(Stub) if Zubat.stubbed?
      instance
    end

    def remote_origin_url
      `git config --get remote.origin.url`.chomp
    end

    def log(files:)
      logs = `git log --oneline --pretty=format:'{ "sha": "%h", "time": "%ad" }' -- #{files.join(' ')}`.split("\n")

      logs.map! do |log|
        args = JSON.parse(log, symbolize_names: true)

        Log.new(sha: args[:sha], time: Time.parse(args[:time]))
      end

      logs.sort_by!(&:time)

      logs.reverse!

      logs
    end

    def exists?(sha:, file:)
      !`git ls-tree -r #{sha} -- #{file} 2>/dev/null`.empty?
    end

    def show(sha:, file:)
      `git show #{sha}:#{file}`
    end

    def diff(sha:, file:)
      `git show #{sha} -- #{file}`
    end
  end
end
