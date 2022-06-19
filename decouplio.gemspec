# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'decouplio/version'

Gem::Specification.new do |spec|
  spec.name          = 'decouplio'
  spec.version       = Decouplio::VERSION
  spec.authors       = ['Alex Bal']
  spec.email         = ['differencialx@gmail.com']

  spec.summary       = 'Gem for business logic encapsulation'
  spec.description   = "Decouplio is a zero dependency, thread safe and framework agnostic gem designed to encapsulate application business logic. It's reverse engineered through TDD and inspired by such frameworks and gems like Trailblazer, Interactor."
  spec.homepage      = 'https://github.com/differencialx/decouplio/blob/master/docs'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/differencialx/decouplio/blob/master/docs'
    spec.metadata['changelog_uri'] = 'https://github.com/differencialx/decouplio/blob/master/docs/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '>= 12.3.2'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
end
