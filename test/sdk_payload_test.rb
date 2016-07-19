require 'test_helper'

class SdkPayloadTest < Minitest::Test
  StackDouble = Struct.new(:identifier, :name, :to_cf)

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
    {
      create_change_set_params: { stack_name: 'identifier', template_body: 'to_cf' },
      create_params: { stack_name: 'name', template_body: 'to_cf' },
      delete_params: { stack_name: 'identifier' },
      update_params: { stack_name: 'identifier', template_body: 'to_cf' },
      validate_params: { template_body: 'to_cf' }
    }.each do |method, expected|
      assert_equal expected.merge(foo: 'bar'), build.public_send(method), "Not equal for method: #{method}"
    end
  end

  def test_template_param_small
    assert_equal ({ template_body: 'to_cf' }), build.send(:template_param)
  end

  def test_template_param_large
    template_body = 'a' * (Humidifier::SdkPayload::MAX_TEMPLATE_BODY_SIZE + 1)
    Humidifier::AwsShim.stub(:upload, 'foobar') do
      assert_equal ({ template_url: 'foobar' }), build(template_body).send(:template_param)
    end
  end

  def test_template_param_extra_large
    template_body = 'a' * (Humidifier::SdkPayload::MAX_TEMPLATE_URL_SIZE + 1)
    assert_raises RuntimeError do
      build(template_body).send(:template_param)
    end
  end

  private

  def build(template_body = 'to_cf')
    Humidifier::SdkPayload.new(StackDouble.new('identifier', 'name', template_body), foo: 'bar')
  end
end
