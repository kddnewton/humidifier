module Humidifier
  module AwsAdapters

    # The adapter for v2 of aws-sdk
    class SDKV2 < Base

      # Create a change set in CFN
      def create_change_set(payload)
        payload.merge(change_set_name: "changeset-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}")
        try_valid { client.create_change_set(payload.create_change_set_params) }
      end

      # Wrap the result from create_stack so it responds to :id in addition to
      # :stack_id
      class ResponseWrapper < SimpleDelegator
        def id
          stack_id
        end
      end

      # Create a change set if the stack exists, otherwise create the stack
      def deploy_change_set(payload)
        exists?(payload) ? create_change_set(payload) : ResponseWrapper.new(create(payload))
      end

      # True if the stack exists in CFN
      def exists?(payload)
        base_module::CloudFormation::Stack.new(name: payload.identifier).exists?
      end

      private

      def base_module
        Aws
      end

      def perform_and_wait(method, payload)
        method = exists?(payload) ? :update : :create if method == :deploy
        response = public_send(method, payload)

        client.wait_until(:"stack_#{method}_complete", stack_name: payload.identifier) do |waiter|
          waiter.max_attempts = payload.max_wait / 5
          waiter.delay = 5
        end

        response
      end

      def upload_object(payload, key)
        base_module.config.update(region: AwsShim::REGION)
        @s3_client ||= base_module::S3::Client.new
        @s3_client.put_object(body: payload.template_body, bucket: Humidifier.config.s3_bucket, key: key)
        base_module::S3::Object.new(Humidifier.config.s3_bucket, key).presigned_url(:get)
      end
    end
  end
end
