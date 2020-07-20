# frozen_string_literal: true

require 'rubocop/rake_task'
require 'yard'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end

YARD::Rake::YardocTask.new(:doc) do |t|
  t.stats_options = ['--list-undoc']
end

desc 'unit test'
task :test do
end

desc 'generate test coverage information in html by simplecov'
task :coverage do
end
