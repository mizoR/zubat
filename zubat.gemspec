# frozen_string_literal: true

require_relative 'lib/zubat/version'

Gem::Specification.new do |spec|
  spec.name = 'zubat'
  spec.version = Zubat::VERSION
  spec.authors = ['mizokami']
  spec.email = ['r.mizokami@gmail.com']

  spec.summary = 'zubat'
  spec.description = 'Visualize trends of your code complexity and smells'
  spec.homepage = 'https://github.com/mizoR/zubat'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/mizoR/zubat'
  spec.metadata['changelog_uri'] = 'https://github.com/mizoR/zubat'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'flog', '~> 4.8'
  spec.add_dependency 'reek', '~> 6.1'
end
