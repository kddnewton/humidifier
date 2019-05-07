=begin
  def test_validation_error
    create_payload = Object.new
    def create_payload.create_params
      raise SdkSupport::AwsDouble::CloudFormation::Errors::ValidationError,
            'test-error'
    end

    with_both_sdks do |sdk|
      _, stderr = capture_io { refute sdk.create(create_payload) }
      assert_equal 'test-error', stderr.split.first
    end
  end

  def test_deploy_exists
    with_both_sdks do |sdk|
      SdkSupport.expect(:exists?, [], true)

      arguments = [{ stack_name: 'name', template_body: 'body' }]
      SdkSupport.expect(:update_stack, arguments)

      sdk.deploy(payload(identifier: 'name', to_cf: 'body'))
      SdkSupport.verify
    end
  end

  def test_deploy_does_not_exist
    with_both_sdks do |sdk|
      deploy_payload = payload(name: 'name', to_cf: 'body')
      SdkSupport.expect(:exists?, [], false)

      arguments = [{ stack_name: 'name', template_body: 'body' }]
      SdkSupport.expect(:create_stack, arguments, stub(stack_id: 'test-id'))

      sdk.deploy(deploy_payload)
      assert_equal 'test-id', deploy_payload.stack.id
      SdkSupport.verify
    end
  end

  def test_upload_configured
    fake_sdk = Class.new(Humidifier::AwsAdapters::Base) do
      def upload_object(_bucket, key)
        key
      end
    end

    with_config(s3_bucket: 'test.s3.bucket', s3_prefix: 'prefix/') do
      assert_equal 'prefix/name.json',
                   fake_sdk.new.upload(payload(identifier: 'name'))
    end
  end

  def test_valid?
    with_both_sdks do |sdk|
      SdkSupport.expect(:validate_template, [{ template_body: 'body' }])
      sdk.valid?(payload(to_cf: 'body'))
      SdkSupport.verify
    end
  end
=end
