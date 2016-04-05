# AwsCF

[![Build Status](https://travis-ci.com/localytics/aws_cf.svg?token=kQUiABmGkzyHdJdMnCnv&branch=master)](https://travis-ci.com/localytics/aws_cf)

Build CloudFormation templates programmatically

## Example

```ruby
stack = AwsCF::Stack.new
stack.add('LoadBalancer', AwsCF::ElasticLoadBalancing::LoadBalancer.new(
  scheme: 'internal',
  listeners: [{ 'Port' => 80, 'Protocol' => 'http', 'InstancePort' => 80, 'InstanceProtocol' => 'http' }]
))
puts stack.to_cf
```
