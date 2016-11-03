# Humidifier

[![Build Status](https://travis-ci.org/localytics/humidifier.svg?branch=master)](https://travis-ci.org/localytics/humidifier)
[![Coverage Status](https://coveralls.io/repos/github/localytics/humidifier/badge.svg?branch=master&t=52zybb)](https://coveralls.io/github/localytics/humidifier?branch=master)
[![Gem Version](https://img.shields.io/gem/v/humidifier.svg?maxAge=3600)](https://rubygems.org/gems/humidifier)

Humidifier allows you to build AWS CloudFormation (CFN) templates programmatically. CFN stacks and resources are represented as Ruby objects with accessors for all their supported properties. Stacks and resources have `to_cf` methods that allow you to quickly inspect what will be uploaded.

For the full docs, go to [https://localytics.github.io/humidifier/](http://localytics.github.io/humidifier/). For local development instructions, see the [Development](https://localytics.github.io/humidifier/#label-Development) section.

Humidifier is tested with Ruby 2.0.0 and higher.

## Getting started

Stacks are represented by the `Humidifier::Stack` class. You can set any of the top-level JSON attributes through the initializer. Resources are represented by an exact mapping from `AWS` resource names to `Humidifier` resources names (e.g. `AWS::EC2::Instance` becomes `Humidifier::EC2::Instance`). Resources have accessors for each JSON attribute. Each attribute can also be set through the `initialize`, `update`, and `update_attribute` methods.

### Example usage

```ruby
stack = Humidifier::Stack.new(name: 'Example-Stack', aws_template_format_version: '2010-09-09')

load_balancer = Humidifier::ElasticLoadBalancing::LoadBalancer.new(
  listeners: [{ LoadBalancerPort: 80, Protocol: 'http', InstancePort: 80, InstanceProtocol: 'http' }]
)
load_balancer.scheme = 'internal'

auto_scaling_group = Humidifier::AutoScaling::AutoScalingGroup.new(min_size: '1', max_size: '20')
auto_scaling_group.update(
  availability_zones: ['us-east-1a'],
  load_balancer_names: [Humidifier.ref('LoadBalancer')]
)

stack.add('LoadBalancer', load_balancer)
stack.add('AutoScalingGroup', auto_scaling_group)
stack.deploy_and_wait
```

### Interfacing with AWS

Once stacks have the appropriate resources, you can query AWS to handle all stack CRUD operations. The operations themselves are intuitively named (i.e. `create`, `update`, `delete`). There are also convenience methods for validating a stack body (`valid?`), checking the existence of a stack (`exists?`), and creating or updating based on existence (`deploy`). The `create`, `update`, `delete`, and `deploy` methods all have `_and_wait` corollaries that will cause the main ruby thread to sleep until the operation is complete.

#### SDK version

Humidifier assumes you have an `aws-sdk` gem installed when you call these operations. It detects the version of the gem you have installed and uses the appropriate API depending on what is available. If Humidifier cannot find any way to use the AWS SDK, it will warn you on every API call and simply return false.

You can also manually specify the version of the SDK that you want to use, in the case that you have both gems in your load path. In that case, you would specify it on the Humidifier configuration object:

```ruby
Humidifier.configure do |config|
  config.sdk_version = 1
end
```

#### CloudFormation functions

You can use CFN intrinsic functions and references using `Humidifier.fn.[name]` and `Humidifier.ref`. Those will build appropriate structures that know how to be dumped to CFN syntax appropriately.

#### Change Sets

Instead of immediately pushing your changes to CloudFormation, Humidifier also supports change sets. Change sets are a powerful feature that allow you to see the changes that will be made before you make them. To read more about change sets see the [announcement article](https://aws.amazon.com/blogs/aws/new-change-sets-for-aws-cloudformation/). To use them in Humidifier, `Stack` has the `create_change_set` and `deploy_change_set` methods. The `create_change_set` method will create a change set on the stack. The `deploy_change_set` method will create a change set if the stack currently exists, and otherwise will create the stack.

### Introspection

To see the template body, you can check the `to_cf` method on stacks, resources, fns, and refs. All of them will output a hash of what will be uploaded (except the stack, which will output a string representation).

Humidifier itself contains a registry of all possible resources that it supports. You can access it with `Humidifier.registry` which is a hash of AWS resource name pointing to the class.

Resources have an `aws_name` method to see how AWS references them. They also contain a `props` method that contains a hash of the name that Humidifier uses to reference the prop pointing to the appropriate prop object.

### Large templates

When templates are especially large (larger than 51,200 bytes), they cannot be uploaded directly through the AWS SDK. You can configure Humidifier to seamlessly upload the templates to S3 and reference them using an S3 URL instead by:

```ruby
Humidifier.configure do |config|
  config.s3_bucket = 'my.s3.bucket'
  config.s3_prefix = 'my-prefix/' # optional
end
```

## Development

To get started, ensure you have ruby installed, version 2.0 or later. From there, install the `bundler` gem: `gem install bundler` and then `bundle install` in the root of the repository.

### Testing

The default rake task runs the tests. Coverage is reported on the command line, and to coveralls.io in CI. Styling is governed by rubocop. The docs are generated with yard. To run all three of these, run:

    $ bundle exec rake
    $ bundle exec rubocop
    $ bundle exec rake yard

### Specs

The specs pulled from the CFN docs live under `/specs`. You can update them by running `bin/get-specs`. This script will scrape the docs by going to the [listings page](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html), finding the list of CFN resources, and then downloading the spec for each resource by going to the individual page.

### Extension

The `underscore` string utility method does a lot of the heavy lifting of changing AWS property names over to ruby method names. As such, it's been extracted to a native extension to increase speed and efficiency. To compile it locally run `rake compile`.

### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/localytics/humidifier.

### License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
