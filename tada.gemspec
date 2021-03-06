# frozen_string_literal: true

$LOAD_PATH.unshift('lib')

require 'date'

require 'tada/version'

Gem::Specification.new do |s|
  s.name        = 'tada'
  s.version     = TADA::VERSION
  s.date        = Date.today.to_s

  s.summary     = <<-BRIEF_DESC
  Todo Manager for nested todo lists with json and tada output.
  BRIEF_DESC

  s.description = <<-LONG_DESC
  Todo Manager for cli lovers, with nested todo lists, 
  todo info section(s), simple selector utility, 
  and uses json and tada format for saving information...
  LONG_DESC

  s.authors     = ['Mohsen MK']
  s.email       = ['cthulhu-irl@protonmail.com']
  s.homepage    = 'https://github.com/cthulhu-irl/tada'
  s.license     = 'MIT'
  s.metadata    = {
    'source_code_uri' => 'https://github.com/cthulhu-irl/tada'
  }

  s.files       = Dir['lib/*.rb']
  s.files      += Dir['lib/**/*.rb']
  s.files      += Dir['docs/*']
  s.files      += Dir['README.md']

  s.required_ruby_version = '>= 2.7'

  s.add_development_dependency 'rake', '~> 13'
  s.add_development_dependency 'rspec', '~> 3.9'
  s.add_development_dependency 'rubocop', '~> 0.86'
  s.add_development_dependency 'rubocop-rake', '~> 0.5'
  s.add_development_dependency 'simplecov', '~> 0.18'
  s.add_development_dependency 'yard', '~> 0.9'
end
