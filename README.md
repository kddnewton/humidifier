# Humidifier

[![Build Status](https://travis-ci.com/localytics/humidifier.svg?token=kQUiABmGkzyHdJdMnCnv&branch=master)](https://travis-ci.com/localytics/humidifier)
[![Coverage Status](https://coveralls.io/repos/github/localytics/humidifier/badge.svg?branch=master&t=52zybb)](https://coveralls.io/github/localytics/humidifier?branch=master)
[![Gem Version](http://artifactory-badge.gw.localytics.com/humidifier)](https://localytics.artifactoryonline.com/localytics/webapp/#/artifacts/browse/tree/General/ruby-gems-virtual/gems)

Build CloudFormation templates programmatically

## Example

```ruby
stack = Humidifier::Stack.new
stack.add('LoadBalancer', Humidifier::ElasticLoadBalancing::LoadBalancer.new(
  scheme: 'internal',
  listeners: [{ 'Port' => 80, 'Protocol' => 'http', 'InstancePort' => 80, 'InstanceProtocol' => 'http' }]
))
puts stack.to_cf
```
