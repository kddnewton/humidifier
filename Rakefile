# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'fileutils'
require 'rake/testtask'
require 'yard'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = false
end

YARD::Rake::YardocTask.new(:yard) do |t|
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
  require 'json'
  require 'net/http'
  require 'nokogiri'
  SpecDownload.new.replace
end

task default: :test

# Downloads specs from the AWS resource specification, compares it to the
# previous spec, and overwrites the existing one.
class SpecDownload
  # Tracks the changes between spec versions.
  class SpecChanges
    def initialize(previous, current)
      @added = []
      @removed = []
      @modified = {}
      compare(previous, current)
    end

    def flush
      puts 'Removed: '
      @removed.each { |removal| puts "- #{removal}" }

      puts "\nAdded: "
      @added.each { |addition| puts "- #{addition}" }

      puts "\nModified: "
      @modified.each do |key, change|
        puts "- #{key} #{JSON.pretty_generate(change)}"
      end
    end

    private

    def compare(previous, current)
      previous.each do |entity, config|
        if !current.key?(entity)
          @removed << entity
        elsif config != current[entity]
          @modified[entity] = { old: previous[entity], new: current[entity] }
        end
      end
      @added += (current.keys - previous.keys)
    end
  end

  URL = 'https://docs.aws.amazon.com/AWSCloudFormation/latest' \
        '/UserGuide/cfn-resource-specification.html'

  filename = 'CloudFormationResourceSpecification.json'
  PATH = File.expand_path(File.join('..', filename), __FILE__)

  def replace
    previous = spec
    download
    SpecChanges.new(previous, spec).flush
  end

  private

  def download
    url = spec_row.at_css('td:nth-child(3) p a').attr('href')
    puts "Downloading from #{url}..."

    response = Net::HTTP.get_response(URI.parse(url)).body
    size = File.write(PATH, JSON.pretty_generate(JSON.parse(response)))
    puts "  wrote #{PATH} (#{(size / 1024.0).round(2)}K)\n\n"
  end

  def spec
    json = JSON.parse(File.read(PATH))
    json['ResourceTypes'].merge(json['PropertyTypes'])
  end

  def spec_page
    Net::HTTP.get_response(URI.parse(URL)).body
  end

  def spec_row
    Nokogiri::HTML(spec_page).css('table tr').detect do |tr|
      name_container = tr.at_css('td:first-child p')
      next unless name_container

      name_container.text.strip == 'US East (N. Virginia)'
    end
  end
end
