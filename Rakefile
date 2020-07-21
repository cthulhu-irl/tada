# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'yard'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end

YARD::Rake::YardocTask.new(:doc) do |t|
  t.stats_options = ['--list-undoc']
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.rspec_opts = ['--format documentation']
end

desc 'generate test coverage information in html by simplecov'
task :coverage do
end
