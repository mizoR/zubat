# frozen_string_literal: true

module Zubat
  class Generator
    FILE = 'tmp/zubat/index.html'

    def generate(results:)
      erb = Zubat.root.join('templates/chart.html.erb').read

      ylabels = []

      results.each do |result|
        result.stat.each do |ylabel, _|
          ylabels << ylabel unless ylabels.include?(ylabel)
        end
      end

      ylabels.sort!

      datasets = []

      results.each do |result|
        xlabel = result.label

        ylabels.each do |ylabel|
          dataset = datasets.find { |ds| ds[:label] == ylabel }

          unless dataset
            dataset = { label: ylabel, data: [] }

            datasets << dataset
          end

          dataset[:data] << {
            label: xlabel,
            complexity_total: result.stat.complexity_total(ylabel),
            complexity_average: result.stat.complexity_average(ylabel),
            smells_scores: result.stat.smell_scores(ylabel).map { |type, value| { type:, value: } }
          }
        end
      end

      html = ERB.new(erb).result_with_hash(datasets:)

      file = File.expand_path(FILE)

      FileUtils.mkdir_p(File.dirname(file))

      IO.write(file, html)

      file
    end
  end
end
