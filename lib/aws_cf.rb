require 'json'
require 'pathname'

require 'aws_cf/parser'
require 'aws_cf/props'
require 'aws_cf/ref'
require 'aws_cf/resource'
require 'aws_cf/stack'
require 'aws_cf/version'

module AwsCF
  # convenience method for creating references
  def self.ref(reference)
    AwsCF::Ref.new(reference)
  end
end

Dir[File.expand_path(File.join('..', '..', 'specs', '*'), __FILE__)].each do |filepath|
  group, resource = Pathname.new(filepath).basename('.cf').to_s.split('-')
  spec = File.readlines(filepath).slice_after { |line| line.include?('Properties') }.to_a[1].slice_before { |line| line.strip == '}' }.to_a[0]
  AwsCF::Resource.register(group, resource, spec.join)
end
