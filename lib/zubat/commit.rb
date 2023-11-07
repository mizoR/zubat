# frozen_string_literal: true

module Zubat
  class Commit
    attr_reader :time, :sha

    def self.find(files:)
      logs = GitCommandWrapper.new.log(files:)

      commits = logs.map { |log| Zubat::Commit.new(sha: log.sha, time: log.time) }

      commits.reverse!

      commits
    end

    def initialize(sha:, time:)
      @sha = sha
      @time = time
    end

    def exists?(file:)
      GitCommandWrapper.new.exists?(sha: @sha, file:)
    end

    def show(file:)
      GitCommandWrapper.new.show(sha: @sha, file:)
    end
  end
end
