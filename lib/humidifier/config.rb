# frozen_string_literal: true

module Humidifier
  # A container for user params
  class Config
    # If true, always upload the CloudFormation template to the configured S3
    # destination. A useful option if you're going to be deploying multiple
    # copies of a template or you just generally want a backup.
    attr_accessor :force_upload

    # The S3 bucket to which to deploy CloudFormation templates when
    # `always_upload` is set to true or the template is too big for a string
    # literal.
    attr_accessor :s3_bucket

    # An optional prefix for the JSON file names.
    attr_accessor :s3_prefix

    # The path to the various directories containing the YAML files representing
    # stacks. If blank, it's assumed to be the current working direction from
    # which the CLI is executing.
    attr_reader :stack_path

    # An optional prefix for the stack names before they get uploaded to AWS.
    attr_accessor :stack_prefix

    def initialize(opts = {})
      @mappings = {}
      @stack_path = '.'
    end

    def files_for(name)
      Dir["#{stack_path}/#{name}/*.yml"]
    end

    # `#map` is a declaration of a link between a file name and a mapper
    # configuration. It is used to declare the manner in which a set of
    # attributes read from a resource file is converted into instantiations of
    # that type.
    #
    # For more information about the mapping DSL and how attributes get
    # converted into props, see the `Humidifier::Config::Mapper` class.
    #
    # == Basic mapping
    #
    # For the most basic of mappings, you can just map a file name to a
    # resource, which effectively means that each attribute you provide must
    # map directly to an AWS attribute for that resource, and that no additional
    # attributes will be provided. For example, the following code indicates
    # that files named `routes.yml` will contain `AWS::EC2::Route` resources,
    # and that every attribute read will directly correspond to one from AWS:
    #
    #     Humidifier.configure do |config|
    #       config.map :routes, to: 'EC2::Route'
    #     end
    #
    # == Using the DSL
    #
    # For mappings for which you want to use the `Humidifier::Config::Mapper`
    # DSL, you can pass a block which will get used to create a new mapper
    # class. This is useful for shorter mapper declarations. For example, in the
    # following code we map files named `instance_profiles.yml` to
    # `AWS::IAM::InstanceProfile` resources. In that mapping we default the
    # `path` prop to "/" and we allow the `roles` prop to just pass a list of
    # roles as an array, which we then convert into CloudFormation references.
    #
    #     Humidifier.configure do |config|
    #       config.map :instance_profiles, to: 'IAM::InstanceProfile' do
    #         defaults do |_|
    #           { path: '/' }
    #         end
    #
    #         attribute :roles do |names|
    #           { roles: names.map { |name| Humidifier.ref(name) } }
    #         end
    #       end
    #     end
    #
    # == Reusing mappers
    #
    # Finally, if you want to pull the mapper out for reuse, testing, or just
    # separation of code, you can pass the `:using` key with a mapper as a
    # value. This will cause the given file type to be mapped using whatever
    # class you provided. For example, the following code creates a mapper that
    # automatically tags the resource with the logical name from the stack. It
    # then configures network ACLs to use that so that all network ACL resource
    # declarations automatically have a tag on them with their name.
    #
    #     class NameToTag < Humidifier::Config::Mapper
    #       defaults do |logical_name|
    #         { tags: [{ key: 'Name', value: logical_name }] }
    #       end
    #     end
    #
    #     Humidifier.configure do |config|
    #       config.map :network_acls, to: 'EC2::NetworkAcl', using: NameToTag
    #     end
    #
    def map(type, opts = {}, &block)
      mappings[type.to_sym] = Mapping.new(opts, &block)
    end

    def mapping_for(type)
      mappings[type.to_sym]
    end

    def stack_path=(stack_path)
      unless File.exist?(stack_path)
        raise Error, "Invalid filepath: #{stack_path}"
      end

      @stack_path = stack_path
    end

    def stacks
      Dir["#{stack_path}/*"].each_with_object([]) do |name, names|
        names << File.basename(name) if File.directory?(name)
      end
    end

    private

    attr_reader :mappings
  end
end
