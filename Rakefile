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

  t.stats_options = ['--list-undoc']
  t.before = lambda do
    require 'humidifier'
    require_relative 'yard/dynamic'
    Dynamic.generate(filepath)
  end
  t.after = -> { FileUtils.rm(filepath) }
end

desc 'Download the latest specs from AWS'
task :specs do
  require 'net/http'
  require 'nokogiri'

  url = URI.parse('http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-resource-specification.html')
  row =
    Nokogiri::HTML(Net::HTTP.get_response(url).body).css('table[summary="Resource Specification"] tr').detect do |tr|
      name_container = tr.at_css('td:first-child p')
      (name_container && name_container.text.strip) == 'US East (N. Virginia)'
    end

  href = row.at_css('td:nth-child(2) p a').attr('href')
  print "Downloading from #{href}..."

  response = Net::HTTP.get_response(URI.parse(href)).body
  size = File.write(File.expand_path(File.join('..', 'lib', 'specs.json'), __FILE__), response)
  puts " wrote lib/specs.json (#{(size / 1024.0).round}K)"
end

task default: :test
