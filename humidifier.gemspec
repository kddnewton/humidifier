# frozen_string_literal: true

require_relative "lib/humidifier/version"

version = Humidifier::VERSION
repository = "https://github.com/kddnewton/humidifier"

Gem::Specification.new do |spec|
  spec.name          = "humidifier"
  spec.version       = version
  spec.authors       = ["Kevin Newton"]
  spec.email         = ["kddnewton@gmail.com"]

  spec.summary       = "CloudFormation made easy"
  spec.description   = "Programmatically generate and manage AWS " \
                       "CloudFormation templates, stacks, and change sets."
  spec.homepage      = repository
  spec.license       = "MIT"

  spec.metadata      = {
    "bug_tracker_uri" => "#{repository}/issues",
    "changelog_uri" => "#{repository}/blob/v#{version}/CHANGELOG.md",
    "source_code_uri" => repository,
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(bin|docs|example|test|yard)/})
    end
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-cloudformation", "~> 1.25"
  spec.add_dependency "aws-sdk-s3", "~> 1.48"
  spec.add_dependency "fast_underscore", "~> 0.3"
  spec.add_dependency "nokogiri", "~> 1.10"
  spec.add_dependency "thor", "~> 1.0"
  spec.add_dependency "thor-hollaback", "~> 0.2"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.13"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.24"
  spec.add_development_dependency "simplecov", "~> 0.17"
  spec.add_development_dependency "yard", "~> 0.9"
end
