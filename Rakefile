require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

desc "Linting for Ruby"
task lint: :rubocop

task default: %i[lint spec]
