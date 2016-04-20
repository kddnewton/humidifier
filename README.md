# Humidifier

[![Build Status](https://travis-ci.com/localytics/humidifier.svg?token=kQUiABmGkzyHdJdMnCnv&branch=master)](https://travis-ci.com/localytics/humidifier)
[![Coverage Status](https://coveralls.io/repos/github/localytics/humidifier/badge.svg?branch=master&t=52zybb)](https://coveralls.io/github/localytics/humidifier?branch=master)
[![Gem Version](http://artifactory-badge.gw.localytics.com/gem/humidifier)](https://localytics.artifactoryonline.com/localytics/webapp/#/artifacts/browse/tree/General/ruby-gems-virtual/gems)

Humidifier is a small ruby gem that allows you to build AWS CloudFormation (CFN) templates programmatically. Every CFN resource is represented as a ruby object that has accessors to read and write properties that can then be uploaded to CFN. Each resource and the stack have `to_cf` methods that allow you to quickly inspect what will be uploaded.

## Development

The specs pulled from the CFN docs live under `/specs`. You can update them by running `bin/get-docs`. This script will scrape the docs by going to the [listings page](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html), finding the list of CFN resources, and then downloading the spec for each resource by going to the individual page.

## Testing

The default rake task runs the tests. Coverage is reported on the command line, and to coveralls.io in CI. Styling is governed by rubocop. To run both tests and rubocop:

    $ bundle exec rake
    $ bundle exec rubocop

Humidifier is tested to work with ruby 2.0 and higher.

## Example

In the following example we build a load balancer object, set the scheme, at it to a stack, and output the CFN template.

```ruby
stack = Humidifier::Stack.new(
  aws_template_format_version: '2010-09-09'
  description: 'Example stack'
)

load_balancer = Humidifier::ElasticLoadBalancing::LoadBalancer.new(
  listeners: [{ 'Port' => 80, 'Protocol' => 'http', 'InstancePort' => 80, 'InstanceProtocol' => 'http' }]
)
load_balancer.scheme = 'internal'

auto_scaling_group = Humidifier::AutoScaling::AutoScalingGroup.new(min_size: '1', max_size: '20')
auto_scaling_group.update(
  availability_zones: ['us-east-1a'],
  load_balancer_names: [Humidifier.ref('LoadBalancer')]
)

stack.add('LoadBalancer', load_balancer)
stack.add('AutoScalingGroup', auto_scaling_group)
puts stack.to_cf
```

The above code will output:

```json
{
  "AwsTemplateFormatVersion": "2010-09-09",
  "Description": "Example stack",
  "Resources": {
    "LoadBalancer": {
      "Type": "AWS::ElasticLoadBalancing::LoadBalancer",
      "Properties": {
        "Listeners": [
          {
            "Port": 80,
            "Protocol": "http",
            "InstancePort": 80,
            "InstanceProtocol": "http"
          }
        ],
        "Scheme": "internal"
      }
    },
    "AutoScalingGroup": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "MinSize": "1",
        "MaxSize": "20",
        "AvailabilityZones": [
          "us-east-1a"
        ],
        "LoadBalancerNames": [
          {
            "Ref": "LoadBalancer"
          }
        ]
      }
    }
  }
}
```

## API Reference

For a list of resources and their properties, see the [API reference](docs/api.md).
