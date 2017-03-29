# Humidifier defines all of its classes that represent CFN resources
# dynamically, so YARD has a hard time documenting them because it can't find
# them. As such, this script loops through the registry of resources and builds
# a ruby file called "magic.rb" that YARD will find. The file contains only
# comments and takes advantage of the fact that YARD will parse a block of
# comments as code if it has the @!parse directive.
module Dynamic
  DOCS_BASE = 'http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-'

  class << self
    def generate(filepath)
      File.open(filepath, 'w') do |file|
        Humidifier.registry.sort.each do |aws_name, clazz|
          file.write(docs_for(aws_name, clazz))
        end
      end
    end

    private

    def docs_for(aws_name, clazz)
      _, mod_name, class_name = aws_name.split('::')
      methods = clazz.props.sort.flat_map { |name, prop| prop_docs_for(name, prop) }
      methods = methods.map { |line| "#         #{line}" }.join("\n")
      methods = methods.strip.empty? ? '' : "\n#{methods}"

      <<-DOC
# @!parse
#
#   module Humidifier
#     # A container module for the AWS #{mod_name} service
#     # @aws AWS::#{mod_name}
#     module #{mod_name}
#       # A dynamically-defined class that represents an #{aws_name} resource
#       # @aws [#{aws_name}](#{DOCS_BASE}#{mod_name.downcase}-#{class_name.downcase}.html)
#       class #{class_name} < Humidifier::Resource#{methods}
#       end
#     end
#   end

DOC
    end

    def prop_docs_for(name, prop)
      prop_type = prop.class.name.split('::').last.gsub(/Prop\z/, '')

      <<-DOC.split("\n")

# returns the #{prop.key} property
def #{name}
  properties['#{name}']
end

# sets the #{prop.key} property (#{prop_type})
def #{name}=(value)
  update_property('#{name}', value)
end
DOC
    end
  end
end
