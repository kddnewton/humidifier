module Humidifier
  module AwsAdapters
    class Base

      MAX_WAIT = 180

      def create(payload)
        try_valid do
          params = { stack_name: payload.name, template_body: payload.to_cf }.merge(payload.options)
          response = client.create_stack(params)
          stack.id = response.stack_id
          response
        end
      end

      def delete(payload)
        client.delete_stack({ stack_name: payload.identifier }.merge(payload.options))
        true
      end

      def deploy(payload)
        exists?(payload) ? update(payload) : create(payload)
      end

      def update(payload)
        try_valid do
          params = { stack_name: payload.identifier, template_body: payload.to_cf }.merge(payload.options)
          client.update_stack(params)
        end
      end

      def valid?(payload)
        try_valid { client.validate_template({ template_body: payload.to_cf }.merge(payload.options)) }
      end

      %i[create delete deploy update].each do |method|
        define_method(:"#{method}_and_wait") do |payload|
          perform_and_wait(method, payload)
        end
      end

      private

      def client
        @client ||= base_module::CloudFormation::Client.new(region: AwsShim::REGION)
      end

      def try_valid
        yield || true
      rescue base_module::CloudFormation::Errors::ValidationError => error
        $stderr.puts error.message
        $stderr.puts error.backtrace
        false
      end
    end
  end
end
