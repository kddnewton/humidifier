require 'bundler/gem_tasks'
require 'fileutils'
require 'rake/extensiontask'
require 'rake/testtask'
require 'yard'

Rake::ExtensionTask.new('humidifier') do |ext|
  ext.lib_dir = File.join('lib', 'humidifier')
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

Rake::Task[:test].prerequisites << :compile

YARD::Rake::YardocTask.new do |t|
  filepath = File.join('lib', 'humidifier', 'magic.rb')

  t.before = lambda do
    require 'humidifier'
    require_relative 'yard/dynamic'
    Dynamic.generate(filepath)
  end
  t.after = -> { FileUtils.rm(filepath) }
end

task default: :test
