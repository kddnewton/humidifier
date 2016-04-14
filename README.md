# Humidifier

[![Build Status](https://travis-ci.com/localytics/humidifier.svg?token=kQUiABmGkzyHdJdMnCnv&branch=master)](https://travis-ci.com/localytics/humidifier)
[![Coverage Status](https://coveralls.io/repos/github/localytics/humidifier/badge.svg?branch=master&t=52zybb)](https://coveralls.io/github/localytics/humidifier?branch=master)
[![Gem Version](http://artifactory-badge.gw.localytics.com/humidifier)](https://localytics.artifactoryonline.com/localytics/webapp/#/artifacts/browse/tree/General/ruby-gems-virtual/gems)

Humidifier is a small ruby gem that allows you to build AWS CloudFormation (CFN) templates programmatically. Every CFN resource is represented as a ruby object that has accessors to read and write properties that can then be uploaded to CFN. Each resource and the stack have `to_cf` methods that allow you to quickly inspect what will be uploaded.

## Example

In the following example we build a load balancer object, set the scheme, at it to a stack, and output the CFN template.

```ruby
stack = Humidifier::Stack.new
load_balancer = Humidifier::ElasticLoadBalancing::LoadBalancer.new(
  listeners: [{ 'Port' => 80, 'Protocol' => 'http', 'InstancePort' => 80, 'InstanceProtocol' => 'http' }]
)
load_balancer.scheme = 'internal'

stack.add('LoadBalancer', load_balancer)
puts stack.to_cf
```

## Development

The specs pulled from the CFN docs live under `/specs`. You can update them by running `bin/get-docs`. This script will scrape the docs by going to the [listings page](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html), finding the list of CFN resources, and then downloading the spec for each resource by going to the individual page.

## Testing

The default rake task runs the tests. Coverage is reported on the command line, and to coveralls.io in CI. Styling is governed by rubocop. To run both tests and rubocop:

    $ bundle exec rake
    $ bundle exec rubocop

## API Reference

For a list of resources and their properties, see the [API reference](docs/api.md).
