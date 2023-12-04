# frozen_string_literal: true

module Zubat
  class Analizer
    AnalizedResult = Data.define(:label, :commit, :stat)

    # @param stat [Hash<String, Hash<String, Integer>>]
    Stat = Data.define(:stat) do
      # @return [Float]
      def complexity_average(file)
        stat.fetch(file, {}).fetch(:average, nil)
      end

      # @return [Float]
      def complexity_total(file)
        stat.fetch(file, {}).fetch(:total_score, nil)
      end

      def smell_scores(file)
        stat.fetch(file, {}).fetch(:smells, {})
      end

      def smell_score(file, label)
        stat.fetch(file).fetch(:smells).fetch(label, 0)
      end

      def diff(file)
        stat.fetch(file, {}).fetch(:diff, nil)
      end

      def each(*, **, &block)
        stat.each(*, **, &block)
      end
    end

    def analize(files:, commit:)
      stat = {}

      files.each do |file|
        diff = commit.diff(file:)

        next if diff.empty?

        stat[file] = {}

        stat[file].merge!(diff:)

        code = commit.show(file:)

        next unless RubyCode.new(code:).valid?

        FlogWrapper.new.examine(code).then do |examined|
          stat[file][:average] = examined.average
          stat[file][:total_score] = examined.total_score
        end

        stat[file][:smells] = ReekWrapper.new.examine(code).map(&:smell_type).tally
      end

      stat = Stat.new(stat:)

      AnalizedResult.new(label: "#{commit.time.iso8601} (#{commit.sha})",
                         commit:,
                         stat:)
    end
  end
end
