# frozen_string_literal: true

require 'test_helper'

class SdkPayloadTest < Minitest::Test
  StackDouble = Struct.new(:identifier, :name, :to_cf, :upload)

  def test_forwarding
    assert_equal 'identifier', build.identifier
    assert_equal 'name', build.name
  end

  def test_options
    assert_equal ({ foo: 'bar' }), build.options
  end

  def test_merge
    payload = build
    payload.merge(bar: 'foo')

    assert_equal 'foo', payload.options[:bar]
  end

  def test_merge_no_overwrite
    payload = build
    payload.merge(foo: 'foo')

    assert_equal 'bar', payload.options[:foo]
  end

  def test_template_body
    assert_equal 'to_cf', build.template_body
  end

  def test_param_sets
    param_sets.each do |method, expected|
      assert_equal expected.merge(foo: 'bar'), build.public_send(method),
                   "Not equal for method: #{method}"
    end
  end

  def test_template_param_small
    assert_equal ({ template_body: 'to_cf' }), build.send(:template_param)
  end

  def test_template_param_small_with_configure_force_upload
    with_config(force_upload: true) do
      payload = build

      payload.stack.stub(:upload, 'foobar') do
        assert_equal ({ template_url: 'foobar' }), payload.send(:template_param)
      end
    end
  end

  def test_template_param_small_with_force_upload
    payload = build(options: { force_upload: true })

    payload.stack.stub(:upload, 'foobar') do
      assert_equal ({ template_url: 'foobar' }), payload.send(:template_param)
    end
  end

  def test_template_param_large
    template_body = 'a' * (Humidifier::SdkPayload::MAX_TEMPLATE_BODY_SIZE + 1)
    payload = build(template_body: template_body)

    payload.stack.stub(:upload, 'foobar') do
      assert_equal ({ template_url: 'foobar' }), payload.send(:template_param)
    end
  end

  def test_template_param_extra_large
    template_body = 'a' * (Humidifier::SdkPayload::MAX_TEMPLATE_URL_SIZE + 1)
    error =
      assert_raises Humidifier::SdkPayload::TemplateTooLargeError do
        build(template_body: template_body).send(:template_param)
      end

    expected = /#{Humidifier::SdkPayload::MAX_TEMPLATE_URL_SIZE + 1} bytes/
    assert_match expected, error.message
  end

  private

  def build(template_body: 'to_cf', options: { foo: 'bar' })
    stack = StackDouble.new('identifier', 'name', template_body)
    Humidifier::SdkPayload.new(stack, options)
  end

  def param_sets
    {
      create_change_set_params: {
        stack_name: 'identifier',
        template_body: 'to_cf'
      },
      create_params: { stack_name: 'name', template_body: 'to_cf' },
      delete_params: { stack_name: 'identifier' },
      update_params: { stack_name: 'identifier', template_body: 'to_cf' },
      validate_params: { template_body: 'to_cf' }
    }
  end
end
