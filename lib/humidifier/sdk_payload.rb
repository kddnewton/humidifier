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

    attr_reader :stack, :options, :max_wait

    extend Forwardable
    def_delegators :stack, :id=, :identifier, :name

    def initialize(stack, options)
      @stack = stack
      @options = options
      @max_wait = options.delete(:max_wait) || MAX_WAIT
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

    def template_param
      @template_param ||=
        if bytesize > MAX_TEMPLATE_BODY_SIZE
          { template_url: AwsShim.upload(self) }
        else
          { template_body: template_body }
        end
    end
  end
end
