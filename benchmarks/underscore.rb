#!/usr/bin/env ruby

require 'bundler/setup'
require 'humidifier'
require 'benchmark/ips'

STRINGS = Array.new(1000) { (('A'..'Z').to_a + ('0'..'9').to_a).shuffle.take(20).join }

def old_underscore(str)
  str.gsub(/([A-Z]+)([0-9]|[A-Z]|\z)/) { "#{$1.capitalize}#{$2}" }.gsub(/(.)([A-Z])/, '\1_\2').downcase if str
end

Benchmark.ips do |x|
  x.report('old') do
    STRINGS.each { |str| old_underscore(str) }
  end
  x.report('new') do
    STRINGS.each { |str| Humidifier::Utils.underscore(str) }
  end
  x.compare!
end
