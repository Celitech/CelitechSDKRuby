# frozen_string_literal: true

require_relative 'lib/celitech/version'

Gem::Specification.new do |spec|
  spec.name    = 'celitech'
  spec.version = Celitech::VERSION
  spec.authors = ['CELITECH']
  spec.email   = ['support@celitech.com']

  spec.summary = <<~'GEMSPEC_STRING'
Welcome to the CELITECH API documentation!

Useful links: [Homepage](https://www.celitech.com) | [Support email](mailto:support@celitech.com) | [Blog](https://www.celitech.com/blog/)

GEMSPEC_STRING
  spec.homepage = 'https://github.com/Celitech/celitech'
  spec.license = 'MIT'

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.required_ruby_version = '>= 3.3'

  spec.files         = Dir['lib/**/*', 'README.md', 'LICENSE']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rubocop', '~> 1.85.1'
  spec.add_development_dependency 'rubocop-ast', '~> 1.49.1'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.39.1'
  spec.add_development_dependency 'rubocop-performance', '~> 1.26.1'
end
