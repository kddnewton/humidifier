# Humidifier

[![Build Status](https://travis-ci.org/localytics/humidifier.svg?branch=master)](https://travis-ci.org/localytics/humidifier)
[![Gem Version](https://img.shields.io/gem/v/humidifier.svg?maxAge=3600)](https://rubygems.org/gems/humidifier)

Humidifier allows you to build AWS CloudFormation (CFN) templates programmatically. CFN stacks and resources are represented as Ruby objects with accessors for all their supported properties. Stacks and resources have `to_cf` methods that allow you to quickly inspect what will be uploaded.

- [Installation](#installation)
- [Getting started](#getting-started)
  - [Example usage](#example-usage)
  - [Interfacing with AWS](#interfacing-with-aws)
    - [CloudFormation functions](#cloudformation-functions)
    - [Change Sets](#change-sets)
  - [Introspection](#introspection)
  - [Large templates](#large-templates)
  - [Forcing uploading](#forcing-uploading)
- [CLI](#cli)
  - [Resource files](#resource-files)
  - [Mappers](#mappers)
  - [Using the CLI](#using-the-cli)
    - [`change [?stack]`](#change-stack)
    - [`deploy [?stack] [*parameters]`](#deploy-stack-parameters)
    - [`display [stack] [?pattern]`](#display-stack-pattern)
    - [`stacks`](#stacks)
    - [`upload [?stack]`](#upload-stack)
    - [`validate [?stack]`](#validate-stack)
  - [Parameters](#parameters)
  - [Shortcuts](#shortcuts)
    - [Automatic id properties](#automatic-id-properties)
    - [Anonymous mappers](#anonymous-mappers)
    - [Cross-stack references](#cross-stack-references)
- [Development](#development)
  - [Testing](#testing)
  - [Specs](#specs)
  - [Contributing](#contributing)
  - [License](#license)

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

You can use CFN intrinsic functions and references using `Humidifier.fn.[name]` and `Humidifier.ref`. They will build appropriate structures that know how to be dumped to CFN syntax.

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

## CLI

`Humidifier` can also be used as a CLI for managing resources through configuration files. To get started, build a ruby script (for example `bin/humidifier`) that executes the `Humidifier::CLI` class, like so:

```ruby
#!/usr/bin/env ruby
require 'humidifier'

Humidifier.configure do |config|
  # optional, defaults to the current working directory, so that all of the
  # directories from the location that you run the CLI are assumed to contain
  # resource specifications
  config.stack_path = 'stacks'

  # optional, a default prefix to use before deploying to AWS
  config.stack_prefix = 'humidifier-'

  # specifies that `users.yml` files contain specifications for `AWS::IAM::User`
  # resources
  config.map :users, to: 'IAM::User'
end

Humidifier::CLI.start(ARGV)
```

### Resource files

Inside of the `stacks` directory configured above, create a subdirectory for each CloudFormation stack that you want to deploy. With the above configuration, we can create YAML files in the form of `users.yml` for each stack, which will specify IAM users to create. The file format looks like the below:

```yaml
EngUser:
  path: /humidifier/
  user_name: EngUser
  groups:
  - Engineering
  - Testing
  - Deployment

AdminUser:
  path: /humidifier/
  user_name: AdminUser
  groups:
  - Management
  - Administration
```

The top-level keys are the logical resource names that will be displayed in the CloudFormation screen. They point to a map of key/value pairs that will be passed on to `humidifier`. Any `humidifier` (and therefore any CloudFormation) attribute may be specified. For more information on CloudFormation templates and which attributes may be specified, see both the [`humidifier` docs](http://localytics.github.io/humidifier) and the [CloudFormation docs](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-guide.html).

### Mappers

Oftentimes, specifying these attributes can become repetitive, e.g., each user should automatically receive the same "path" attribute. Other times, you may want custom logic to execute depending on which AWS environment you're running in. Finally, you may want to reference resources in the same or other stacks.

`Humidifier`'s solution for this is to allow customized "mapper" classes to take the user-provided attributes and transform them into the attributes that CloudFormation expects. Consider the following example for mapping a user:

```ruby
class UserMapper < Humidifier::Config::Mapper
  GROUPS = {
    'eng' => %w[Engineering Testing Deployment],
    'admin' => %w[Management Administration]
  }

  defaults do |logical_name|
    { path: '/humidifier/', user_name: logical_name }
  end

  attribute :group do |group|
    groups = GROUPS[group]
    groups.any? ? { groups: GROUPS[group] } : {}
  end
end

Humidifier.configure do |config|
  config.map :users, to: 'IAM::User', using: UserMapper
end
```

This means that by default, all entries in the `users.yml` files will get a `/humidifier/` path, the `user_name` attribute will be set based on the logical name that was provided for the resource, and you can additionally specify a `group` attribute, even though it is not native to CloudFormation. With this `group` attribute, it will actually map to the `groups` attribute that CloudFormation expects.

With this new mapper in place, we can simplify our YAML file to:

```yaml
EngUser:
  group: eng

AdminUser:
  group: admin
```

### Using the CLI

Now that you've configured your CLI, your resources, and your mappers, you can use the CLI to display, validate, and deploy your infrastructure to CloudFormation. Run your script without any arguments to get the help message and explanations for each command.

Each command has an `--aws-profile` (or `-p`) option for specifying which profile to authenticate against when querying AWS. You should ensure that this profile has the correct permissions for creating whatever resources are going to part of your stack. You can also rely on the `AWS_*` environment variables, or the EC2 instance profile if you're deploying from an instance. For more information, see the [AWS docs](http://docs.aws.amazon.com/sdkforruby/api/) under the "Configuration" section.

Below are the list of commands and some of their options.

#### `change [?stack]`

Creates a change set for either the specified stack or all stacks in the repo. The change set represents the changes between what is currently deployed versus 
the resources represented by the configuration.

#### `deploy [?stack] [*parameters]`

Creates or updates (depending on if the stack already exists) one or all stacks in the repo.

The `deploy` command also allows a `--prefix` command line argument that will override the default prefix (if one is configured) for the stack that is being deployed. This is especially useful when you're deploying multiple copies of the same stack (for instance, multiple autoscaling groups) that have different purposes or semantically mean newer versions of resources.

#### `display [stack] [?pattern]`

Displays the specified stack in JSON format on the command line. If you optionally pass a pattern argument, it will filter the resources down to just ones whose names match the given pattern.

#### `stacks`

Displays the names of all of the stacks that `humidifier` is managing.

#### `upload [?stack]`

Upload one or all stacks in the repo to S3 for reference later. Note that this must be combined with the `humidifier` `s3_bucket` configuration option.

#### `validate [?stack]`

Validate that one or all stacks in the repo are properly configured and using values that CloudFormation understands.

### Parameters

CloudFormation template parameters can be specified by having a special `parameters.yml` file in your stack directory. This file should contain a YAML-encoded object whose keys are the names of the parameters and whose values are the parameter configuration (using the same underscore paradigm as `humidifier` resources for specifying configuration).

You can pass values to the CLI deploy command after the stack name on the command line as in:

```sh
bin/humidifier deploy foobar Param1=Foo Param2=Bar
```

Those parameters will get passed in as values when the stack is deployed.

### Shortcuts

A couple of convenient shortcuts are built into `humidifier` so that writing templates and mappers both can be more concise.

#### Automatic id properties

There are a lot of properties in the AWS CloudFormation resource specification that are simply pointers to other entities within the AWS ecosystem. For example, an `AWS::EC2::VPCGatewayAttachment` entity has a `VpcId` property that represents the ID of the associated `AWS::EC2::VPC`.

Because this pattern is so common, `humidifier` detects all properties ending in `Id` and allows you to specify them without the suffix. If you choose to use this format, `humidifier` will automatically turn that value into a [CloudFormation resource reference](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-ref.html).

#### Anonymous mappers

A lot of the time, mappers that you create will not be overly complicated, especially if you're using automatic id properties. So, the `config.map` method optionally takes a block, and allows you to specify the mapper inline. This is recommended for mappers that aren't too complicated as to warrant their own class (for instance, for testing purposes). An example of this using the `UserMapper` from above is below:

```ruby
Humidifier.configure do |config|
  config.map :users, to: 'IAM::User' do
    GROUPS = {
      'eng' => %w[Engineering Testing Deployment],
      'admin' => %w[Management Administration]
    }

    defaults do |logical_name|
      { path: '/humidifier/', user_name: logical_name }
    end

    attribute :group do |group|
      groups = GROUPS[group]
      groups.any? ? { groups: GROUPS[group] } : {}
    end
  end
end
```

#### Cross-stack references

AWS allows cross-stack references through the [intrinsic `Fn::ImportValue` function](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-importvalue.html). You can take advantage of this with `humidifier` by using the `export: true` option on resources in your stacks. For instance, if in one stack you have a subnet that you need to reference in another, you could (`stacks/vpc/subnets.yml`):

```yaml
ProductionPrivateSubnet2a:
  vpc: ProductionVPC
  cidr_block: 10.0.0.0/19
  availability_zone: us-west-2a
  export: true

ProductionPrivateSubnet2b:
  vpc: ProductionVPC
  cidr_block: 10.0.64.0/19
  availability_zone: us-west-2b
  export: true

ProductionPrivateSubnet2c:
  vpc: ProductionVPC
  cidr_block: 10.0.128.0/19
  availability_zone: us-west-2c
  export: true
```

And then in another stack, you could reference those values (`stacks/rds/db_subnets_groups.yml`):

```yaml
ProductionDBSubnetGroup:
  db_subnet_group_description: Production DB private subnet group
  subnets:
  - ProductionPrivateSubnet2a
  - ProductionPrivateSubnet2b
  - ProductionPrivateSubnet2c
```

Within the configuration, you would specify to use the `Fn::ImportValue` function like so:

```ruby
Humidifier.configure do |config|
  config.stack_path = 'stacks'

  config.map :subnets, to: 'EC2::Subnet'

  config.map :db_subnet_groups, to: 'RDS::DBSubnetGroup' do
    attribute :subnets do |subnet_names|
      subnet_ids =
        subnet_names.map do |subnet_name|
          Humidifier.fn.import_value(subnet_name)
        end

      { subnet_ids: subnet_ids }
    end
  end
end
```

If you specify `export: true` it will by default export a reference to the resource listed in the stack. You can also choose to export a different attribute by specifying the attribute as the value to export. For example, if we were creating instance profiles and wanted to export the `Arn` so that it could be referenced by an instance later, we could:

```yaml
APIRoleInstanceProfile:
  depends_on: APIRole
  roles:
  - APIRole
  export: Arn
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
