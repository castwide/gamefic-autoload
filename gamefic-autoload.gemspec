# frozen_string_literal: true

require_relative 'lib/gamefic/autoload/version'

Gem::Specification.new do |spec|
  spec.name = 'gamefic-autoload'
  spec.version = Gamefic::Autoload::VERSION
  spec.authors = ['Fred Snyder']
  spec.email = ['fsnyder@castwide.com']
  spec.homepage = 'https://gamefic.com'
  spec.license = 'MIT'

  spec.summary = 'Code loading for Gamefic projects'
  # spec.description = "TODO: Write a longer description or delete this line."
  # spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.required_ruby_version = '>= 2.6.0'

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/castwide/gamefic-autoload'
  spec.metadata['changelog_uri'] = 'https://github.com/castwide/gamefic-autoload/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'gamefic', '~> 4.0'
  spec.add_dependency 'zeitwerk', '~> 2.6'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.22'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
