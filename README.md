# Humidifier

[![Build Status](https://travis-ci.org/localytics/humidifier.svg?branch=master)](https://travis-ci.org/localytics/humidifier)
[![Gem Version](https://img.shields.io/gem/v/humidifier.svg?maxAge=3600)](https://rubygems.org/gems/humidifier)

Humidifier allows you to build AWS CloudFormation (CFN) templates programmatically. CFN stacks and resources are represented as Ruby objects with accessors for all their supported properties. Stacks and resources have `to_cf` methods that allow you to quickly inspect what will be uploaded.

For the full docs, go to [https://localytics.github.io/humidifier/](http://localytics.github.io/humidifier/). For local development instructions, see the [Development](https://localytics.github.io/humidifier/#label-Development) section.

This project follows semantic versioning linked to AWS' CloudFormation resource specification version since `1.2.1`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'humidifier'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install humidifier

## Getting started

Stacks are represented by the `Humidifier::Stack` class. You can set any of the top-level JSON attributes (such as `name` and `description`) through the initializer.

Resources are represented by an exact mapping from `AWS` resource names to `Humidifier` resources names (e.g. `AWS::EC2::Instance` becomes `Humidifier::EC2::Instance`). Resources have accessors for each JSON attribute. Each attribute can also be set through the `initialize`, `update`, and `update_attribute` methods.

### Example usage

The below example will create a stack with two resources, a loader balancer and an auto scaling group. It then deploys the new stack and pauses execution until the stack is finished being created.

```ruby
stack = Humidifier::Stack.new(name: 'Example-Stack')

stack.add(
  'LoaderBalancer',
  Humidifier::ElasticLoadBalancing::LoadBalancer.new(
    scheme: 'internal',
    listeners: [
      {
        load_balancer_port: 80,
        protocol: 'http',
        instance_port: 80,
        instance_protocol: 'http'
      }
    ]
  )
)

stack.add(
  'AutoScalingGroup',
  Humidifier::AutoScaling::AutoScalingGroup.new(
    min_size: '1',
    max_size: '20',
    availability_zones: ['us-east-1a'],
    load_balancer_names: [Humidifier.ref('LoadBalancer')]
  )
)

stack.deploy_and_wait
```

### Interfacing with AWS

Once stacks have the appropriate resources, you can query AWS to handle all stack CRUD operations. The operations themselves are intuitively named (i.e. `#create`, `#update`, `#delete`). There are also convenience methods for validating a stack body (`#valid?`), checking the existence of a stack (`#exists?`), and creating or updating based on existence (`#deploy`).

There are additionally four functions on `Humidifier::Stack` that support waiting for execution in AWS to finish. They all have non-blocking corollaries, and are named after them. They are: `#create_and_wait`, `#update_and_wait`, `#delete_and_wait`, and `#deploy_and_wait`.

#### CloudFormation functions

You can use CFN intrinsic functions and references using `Humidifier.fn.[name]` and `Humidifier.ref`. Those will build appropriate structures that know how to be dumped to CFN syntax appropriately.

#### Change Sets

Instead of immediately pushing your changes to CloudFormation, Humidifier also supports change sets. Change sets are a powerful feature that allow you to see the changes that will be made before you make them. To read more about change sets see the [announcement article](https://aws.amazon.com/blogs/aws/new-change-sets-for-aws-cloudformation/). To use them in Humidifier, `Humidifier::Stack` has the `#create_change_set` and `#deploy_change_set` methods. The `#create_change_set` method will create a change set on the stack. The `#deploy_change_set` method will create a change set if the stack currently exists, and otherwise will create the stack.

### Introspection

To see the template body, you can check the `#to_cf` method on stacks, resources, fns, and refs. All of them will output a hash of what will be uploaded (except the stack, which will output a string representation).

Humidifier itself contains a registry of all possible resources that it supports. You can access it with `Humidifier::registry` which is a hash of AWS resource name pointing to the class.

Resources have an `::aws_name` method to see how AWS references them. They also contain a `::props` method that contains a hash of the name that Humidifier uses to reference the prop pointing to the appropriate prop object.

### Large templates

When templates are especially large (larger than 51,200 bytes), they cannot be uploaded directly through the AWS SDK. You can configure `Humidifier` to seamlessly upload the templates to S3 and reference them using an S3 URL instead by:

```ruby
Humidifier.configure do |config|
  config.s3_bucket = 'my.s3.bucket'
  config.s3_prefix = 'my-prefix/' # optional
end
```

### Forcing uploading

You can force a stack to upload its template to S3 regardless of the size of the template. This is a useful option if you're going to be deploying multiple
copies of a template or if you want a backup. You can set this option on a per-stack basis:

```ruby
stack.deploy(force_upload: true)
```

or globally, by setting the configuration option:

```ruby
Humidifier.configure do |config|
  config.force_upload = true
end
```

## Development

To get started, ensure you have ruby installed, version 2.4 or later. From there, install the `bundler` gem: `gem install bundler` and then `bundle install` in the root of the repository.

### Testing

The default rake task runs the tests. Styling is governed by rubocop. The docs are generated with yard. To run all three of these, run:

    $ bundle exec rake
    $ bundle exec rubocop
    $ bundle exec rake yard

### Specs

The specs pulled from the CFN docs is saved to `CloudFormationResourceSpecification.json`. You can update it by running `bundle exec rake specs`. This script will pull down the latest [resource specification](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-resource-specification.html) to be used with Humidifier.

### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/localytics/humidifier.

### License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
