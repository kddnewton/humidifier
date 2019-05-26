# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.3.0] - 2019-05-25

### Changed

- Bump to CFN spec 3.3.0.

## [3.2.0] - 2019-05-08

### Changed

- Added some emoji to the CLI output.

## [3.1.0] - 2019-05-08

### Added

- The CLI functionality from the `humidifier-reservoir` gem directly into `humidifier`.

## [3.0.1] - 2019-05-08

### Changed

- Register dependencies with `add_dependency` so they get picked up by bundler.

## [3.0.0] - 2019-05-07

### Added

- The `fast_underscore` dependency, which actually ended up being more accurate than our previous underscore method.

### Changed

- Updated the specs to `v3.0.0`.
- Bumped the minimum ruby version to `2.4`, which allows us to strip out some of the old code necessary to support the EOL'd versions.
- `Humidifier::Utils::underscored` has been moved and renamed, so it is now `Humidifier::underscore`. The `Humidifier::Utils::underscore` has been moved directly into the `String` class because of `fast_underscore`.
- Because of the removal of support for the other SDK versions, the test suite has been greatly simplified. We can now use the stub responses functionality from the AWS SDK itself.
- The `Humidifier::Configuration` class has been renamed to `Humidifier::Config`.
- The `Humidifier::SdkPayload` class has been removed and the functionality merged directly into the `Humidifier::Stack` class.

### Removed

- Support for the other SDK versions has been dropped. Because of this, `humidifier` now ships with `aws-sdk-cloudformation` and `aws-sdk-s3` as dependencies. This also greatly simplifies the code. All of functionality that used to live in the shims for the various SDK versions has been merged into the `Humidifer::Stack` class.
- Support for the `raw` option when importing resources. From now on, invalid types for properties always error as opposed to allowing some values to be converted. (`#convert` methods on all of the props were therefore also removed.)

## [2.15.0] - 2018-11-28

### Changed
- Update to CloudFormation specs v2.15.0

[Unreleased]: https://github.com/localytics/humidifier/compare/v3.2.0...HEAD
[3.2.0]: https://github.com/localytics/humidifier/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/localytics/humidifier/compare/v3.0.1...v3.1.0
[3.0.1]: https://github.com/localytics/humidifier/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/localytics/humidifier/compare/v2.15.0...v3.0.0
[2.15.0]: https://github.com/localytics/humidifier/compare/v2.6.0...v2.15.0
