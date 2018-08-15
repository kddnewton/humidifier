# frozen_string_literal: true

require 'test_helper'

class IntegrationTest < Minitest::Test
  def test_to_cf
    resources = { 'Distribution' => distribution, 'SpotFleet' => spot_fleet }
    stack = Humidifier::Stack.new(name: 'Test-Stack', resources: resources)

    expected = JSON.parse(File.read('test/integration_test.json'))
    assert_equal expected, JSON.parse(stack.to_cf)
  end

  private

  # rubocop:disable Metrics/MethodLength
  # http://docs.aws.amazon.com
  #   /AWSCloudFormation/latest/UserGuide/quickref-cloudfront.html
  def distribution
    Humidifier::CloudFront::Distribution.new(
      distribution_config: {
        origins: [{
          domain_name: 'mybucket.s3.amazonaws.com',
          id: 'myS3Origin',
          s3_origin_config: {
            origin_access_identity: 'oai/cloudfront/E127EXAMPLE51Z'
          }
        }],
        enabled: true,
        comment: 'Some comment',
        default_root_object: 'index.html',
        logging: {
          include_cookies: false,
          bucket: 'mylogs.s3.amazonaws.com',
          prefix: 'myprefix'
        },
        aliases: %w[mysite.example.com yoursite.example.com],
        default_cache_behavior: {
          allowed_methods: %w[DELETE GET HEAD OPTIONS PATCH POST PUT],
          target_origin_id: 'myS3Origin',
          forwarded_values: {
            query_string: false,
            cookies: { forward: 'none' }
          },
          trusted_signers: %w[1234567890EX 1234567891EX],
          viewer_protocol_policy: 'allow-all'
        },
        price_class: 'PriceClass_200',
        restrictions: {
          geo_restriction: {
            restriction_type: 'whitelist',
            locations: %w[AQ CV]
          }
        },
        viewer_certificate: { cloud_front_default_certificate: true }
      }
    )
  end

  def launch_specification
    mapped = ['AWSInstanceType2Arch', Humidifier.ref('InstanceType'), 'Arch']

    image_id = [
      'AWSRegionArch2AMI',
      Humidifier.ref('AWS::Region'),
      Humidifier.fn.find_in_map(mapped)
    ]

    {
      instance_type: Humidifier.ref('InstanceType'),
      image_id: Humidifier.fn.find_in_map(image_id),
      weighted_capacity: 8
    }
  end

  # http://docs.aws.amazon.com
  #   /AWSCloudFormation/latest/UserGuide/aws-resource-ec2-spotfleet.html
  def spot_fleet
    Humidifier::EC2::SpotFleet.new(
      spot_fleet_request_config_data: {
        iam_fleet_role: Humidifier.ref('IAMFleetRole'),
        spot_price: '1000',
        target_capacity: Humidifier.ref('TargetCapacity'),
        launch_specifications: [
          launch_specification.merge(
            ebs_optimized: false,
            subnet_id: Humidifier.ref('Subnet1')
          ),
          launch_specification.merge(
            ebs_optimized: true,
            monitoring: { enabled: true },
            security_groups: [
              { group_id: Humidifier.fn.get_att(%w[SG0 GroupId]) }
            ],
            subnet_id: Humidifier.ref('Subnet0'),
            iam_instance_profile: {
              arn: Humidifier.fn.get_att(%w[RootInstanceProfile Arn])
            }
          )
        ]
      }
    )
  end
  # rubocop:enable Metrics/MethodLength
end
