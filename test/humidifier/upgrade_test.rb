# frozen_string_literal: true

require 'test_helper'

module Humidifier
  class UpgradeTest < Minitest::Test
    Response = Struct.new(:body)

    def test_upgrade
      File.stub(:write, nil) do
        Net::HTTP.stub(:get_response, method(:response_for)) do
          assert_equal '13.0.0', Upgrade.perform
        end
      end
    end

    private

    def response_for(url)
      body =
        case url.to_s.split('/').last
        when 'cfn-resource-specification.html'
          File.read(File.join(__dir__, 'cfn-resource-specification.html'))
        when 'us-east-1.json'
          JSON.dump('ResourceSpecificationVersion' => '13.0.0')
        end

      Response.new(body)
    end
  end
end
