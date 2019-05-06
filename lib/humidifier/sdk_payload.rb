# frozen_string_literal: true

module Humidifier
  # The payload sent to the shim methods, representing the stack and the options
  class SdkPayload
    # The maximum size a template body can be before it has to be put somewhere
    # and referenced through a URL
    MAX_TEMPLATE_BODY_SIZE = 51_200

    # The maximum size a template body can be inside of an S3 bucket
    MAX_TEMPLATE_URL_SIZE = 460_800

    # The maximum amount of time that Humidifier should wait for a stack to
    # complete a CRUD operation
    MAX_WAIT = 600

    # Thrown when a template is too large to use the template_url option
    class TemplateTooLargeError < StandardError
      def initialize(bytesize)
        message =
          "Cannot use a template > #{MAX_TEMPLATE_URL_SIZE} bytes " \
          "(currently #{bytesize} bytes), consider using nested stacks " \
          '(http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide' \
          '/aws-properties-stack.html)'
        super(message)
      end
    end

    # The stack on which operations are going to be performed.
    attr_reader :stack

    # Options that should be passed through to CloudFormation when the desired
    # operation is being performed. Particularly useful for the `capabilities`
    # option for acknowledging IAM resource changes.
    attr_reader :options

    # The maximum amount of time that `humidifier` should wait for the stack to
    # resolve to the desired state. If your stacks are particularly large, you
    # may need to set this to wait longer than the default `MAX_WAIT`.
    attr_accessor :max_wait

    # Force the stack to upload to S3 regardless of the size of the stack.
    attr_accessor :force_upload

    extend Forwardable
    def_delegators :stack, :id=, :identifier, :name

    def initialize(stack, options)
      @stack = stack
      @options = options
      @max_wait = options.delete(:max_wait) || MAX_WAIT
      @force_upload = options.delete(:force_upload)
    end

    # True if the stack and options are the same as the other (used for testing)
    def ==(other)
      stack == other.stack && options == other.options
    end

    # Merge in options
    def merge(new_options)
      @options = new_options.merge(options)
    end

    # The body of the template
    def template_body
      @template_body ||= stack.to_cf
    end

    ###
    # Param sets
    ###

    # Param set for the #create_change_set SDK method
    def create_change_set_params
      { stack_name: stack.identifier }.merge(template_param).merge(options)
    end

    # Param set for the #create_stack SDK method
    def create_params
      { stack_name: stack.name }.merge(template_param).merge(options)
    end

    # Param set for the #delete_stack SDK method
    def delete_params
      { stack_name: stack.identifier }.merge(options)
    end

    # Param set for the #update_stack SDK method
    def update_params
      { stack_name: stack.identifier }.merge(template_param).merge(options)
    end

    # Param set for the #validate_template SDK method
    def validate_params
      template_param.merge(options)
    end

    private

    def bytesize
      template_body.bytesize.tap do |size|
        raise TemplateTooLargeError, size if size > MAX_TEMPLATE_URL_SIZE
      end
    end

    def should_upload?
      return force_upload unless force_upload.nil?

      Humidifier.config.force_upload || bytesize > MAX_TEMPLATE_BODY_SIZE
    end

    def template_param
      @template_param ||=
        if should_upload?
          { template_url: stack.upload(self) }
        else
          { template_body: template_body }
        end
    end
  end
end
