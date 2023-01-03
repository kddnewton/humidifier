# frozen_string_literal: true

module Humidifier
  # Represents a directory on the filesystem containing YAML files that
  # correspond to resources belonging to a stack. Contains all of the logic for
  # interfacing with humidifier to deploy stacks, validate them, display them.
  class Directory
    # Represents an exported resource in a stack for use in cross-stack
    # references.
    Export =
      Struct.new(:name, :attribute) do
        def value
          if attribute.is_a?(String)
            Humidifier.fn.get_att([name, attribute])
          else
            Humidifier.ref(name)
          end
        end
      end

    attr_reader :name, :pattern, :prefix, :exports, :stack_name

    def initialize(name, pattern: nil, prefix: nil)
      @name = name
      @pattern = pattern
      @prefix = prefix
      @exports = []
      @stack_name = "#{prefix || Humidifier.config.stack_prefix}#{name}"
    end

    def create_change_set
      return unless valid?

      stack.create_change_set(
        capabilities: %w[CAPABILITY_IAM CAPABILITY_NAMED_IAM]
      )
    end

    def deploy(wait = false, parameter_values = {})
      return unless valid?

      stack.public_send(
        wait ? :deploy_and_wait : :deploy,
        capabilities: %w[CAPABILITY_IAM CAPABILITY_NAMED_IAM],
        parameters: parameter_values
      )
    end

    def to_cf
      stack.to_cf
    end

    def upload
      stack.upload if valid?
    end

    def valid?
      stack.valid?
    end

    private

    def stack
      Stack.new(
        name: stack_name,
        description: "Resources for #{stack_name}",
        resources: resources,
        outputs: outputs,
        parameters: parameters
      )
    end

    def outputs
      exports.each_with_object({}) do |export, exported|
        exported[export.name] = Output.new(
          value: export.value,
          export_name: export.name
        )
      end
    end

    def parameters
      @parameters ||=
        begin
          parameter_filepath =
            Humidifier
              .config
              .files_for(name)
              .detect do |filepath|
                File.basename(filepath, ".yml") == "parameters"
              end

          parameter_filepath ? parameters_from(parameter_filepath) : {}
        end
    end

    def parameters_from(filepath)
      loaded = YAML.load_file(filepath)
      return {} unless loaded

      loaded.each_with_object({}) do |(name, opts), params|
        opts = opts.to_h { |key, value| [key.to_sym, value] }
        params[name] = Parameter.new(opts)
      end
    end

    def parse(filepath, type)
      mapping = Humidifier.config.mapping_for(type)
      return {} if mapping.nil?

      loaded = YAML.load_file(filepath)
      return {} unless loaded

      loaded.each_with_object({}) do |(name, attributes), resources|
        next if pattern && name !~ pattern

        attribute = attributes.delete("export")
        exports << Export.new(name, attribute) if attribute

        resources[name] = mapping.resource_for(name, attributes)
      end
    end

    def resources
      filepaths = Humidifier.config.files_for(name)

      filepaths.each_with_object({}) do |filepath, resources|
        basename = File.basename(filepath, ".yml")

        # Explicitly skip past parameters so we can pull them out later
        next if basename == "parameters"

        resources.merge!(parse(filepath, basename))
      end
    end
  end
end
