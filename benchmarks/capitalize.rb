#!/usr/bin/env ruby

require 'bundler/setup'
require 'humidifier'
require 'benchmark/ips'

STRINGS = Array.new(1000) { (('a'..'z').to_a + ['_']).shuffle.take(20).join }

def old_camelize(str)
  str.to_s.capitalize.gsub(/_([a-z])/) { $1.upcase }.gsub(/aws/i, 'AWS')
end

Benchmark.ips do |x|
  x.report('old') do
    STRINGS.each { |str| old_camelize(str) }
  end
  x.report('new') do
    STRINGS.each { |str| Humidifier::Utils.camelize(str) }
  end
  x.compare!
end
