require 'json'
require 'pathname'

require 'aws_cf/parser'
require 'aws_cf/props'
require 'aws_cf/resource'
require 'aws_cf/version'

Dir[File.expand_path(File.join('..', '..', 'specs', '*'), __FILE__)].each do |filepath|
  group, resource = Pathname.new(filepath).basename('.cf').to_s.split('-')
  spec = File.readlines(filepath).slice_after { |line| line.include?('Properties') }.to_a[1].slice_before { |line| line.strip == '}' }.to_a[0]
  AwsCF::Resource.register(group, resource, spec.join)
end
