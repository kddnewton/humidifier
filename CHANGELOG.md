# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [4.1.1] - 2021-11-17

### Changed

- Require MFA for releasing.

## [4.1.0] - 2020-04-19

### Added

- You can now run `humidifier upgrade`, which will download the latest specs from AWS, so that you won't need to upgrade this gem in order to do that.
- This gem will now ship with a default CLI that you can execute. If you execute that CLI and you have a custom one it will automatically switch to executing that one instead.

## [4.0.2] - 2019-12-11

### Changed

- Bump to CFN spec 10.0.0.

## [4.0.1] - 2019-11-14

### Changed

- Bump to CFN spec 8.0.0.

## [4.0.0] - 2019-09-17

### Changed

- Bump to CFN spec 6.1.0.

## [3.5.0] - 2019-07-25

### Changed

- Bump to CFN spec 4.3.0.

## [3.4.0] - 2019-06-18

### Changed

- Bump to CFN spec 3.4.0.

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

[unreleased]: https://github.com/kddnewton/humidifier/compare/v4.1.1...HEAD
[4.1.1]: https://github.com/kddnewton/humidifier/compare/v4.1.0...v4.1.1
[4.1.0]: https://github.com/kddnewton/humidifier/compare/v4.0.2...v4.1.0
[4.0.2]: https://github.com/kddnewton/humidifier/compare/v4.0.1...v4.0.2
[4.0.1]: https://github.com/kddnewton/humidifier/compare/v4.0.0...v4.0.1
[4.0.0]: https://github.com/kddnewton/humidifier/compare/v3.5.0...v4.0.0
[3.5.0]: https://github.com/kddnewton/humidifier/compare/v3.4.0...v3.5.0
[3.4.0]: https://github.com/kddnewton/humidifier/compare/v3.3.0...v3.4.0
[3.3.0]: https://github.com/kddnewton/humidifier/compare/v3.2.0...v3.3.0
[3.2.0]: https://github.com/kddnewton/humidifier/compare/v3.1.0...v3.2.0
[3.1.0]: https://github.com/kddnewton/humidifier/compare/v3.0.1...v3.1.0
[3.0.1]: https://github.com/kddnewton/humidifier/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/kddnewton/humidifier/compare/v2.15.0...v3.0.0
[2.15.0]: https://github.com/kddnewton/humidifier/compare/f05157...v2.15.0
