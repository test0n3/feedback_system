# frozen_string_literal: true

require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  # NOTE: this block runs immediately at Rakefile load time (RSpec::Core::RakeTask
  # yields eagerly for configuration), so RACK_ENV is forced to 'test' for every
  # rake task by default — not just :spec. :console explicitly overrides this below.
  ENV['RACK_ENV'] = 'test'
  t.rspec_opts = '--format documentation'
  t.pattern = 'spec/**/*_spec.rb'
end

require './app'

desc 'Execute available test for project: spec, brakeman, bundle-audit'
task default: %i[rubocop spec brakeman audit]

desc 'Look for style guide offenses in your code'
task :rubocop do
  sh 'bundle exec rubocop -f github'
end

desc 'Open an irb session preloaded with the environment'
task :console do
  ENV['RACK_ENV'] = 'development'
  load File.expand_path('config/application.rb', __dir__)
  require 'rubygems'
  require 'pry'

  Pry.start
end

desc 'Execute security scanner, Brakeman'
task :brakeman do
  sh 'bundle exec brakeman --force-scan -q -f json -o brakeman.json'
end

desc 'Execute static analysis on Gemfile.lock, bundle-audit'
task :audit do
  sh 'bundle exec bundle-audit check --update'
end
