# frozen_string_literal: true

require "bundler/gem_tasks"
require "fileutils"
require "rake/testtask"
require "syntax_tree/rake_tasks"
require "yard"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

task default: :test

YARD::Rake::YardocTask.new(:yard) do |t|
  filepath = File.join("lib", "humidifier", "magic.rb")

  t.stats_options = ["--list-undoc"]
  t.before =
    lambda do
      require "humidifier"
      require_relative "yard/dynamic"
      Dynamic.generate(filepath)
    end
  t.after = -> { FileUtils.rm(filepath) }
end

configure = ->(task) do
  task.source_files =
    FileList[%w[Gemfile Rakefile *.gemspec lib/**/*.rb test/**/*.rb]]
end

SyntaxTree::Rake::CheckTask.new(&configure)
SyntaxTree::Rake::WriteTask.new(&configure)
