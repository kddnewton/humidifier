# Development

To get started, ensure you have ruby installed, version 2.0 or later. From there, install the `bundler` gem: `gem install bundler` and then `bundle install` in the root of the repository.

## Testing

The default rake task runs the tests. Coverage is reported on the command line, and to coveralls.io in CI. Styling is governed by rubocop. To run both tests and rubocop:

    $ bundle exec rake
    $ bundle exec rubocop

## Specs

The specs pulled from the CFN docs live under `/specs`. You can update them by running `bin/get-specs`. This script will scrape the docs by going to the [listings page](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html), finding the list of CFN resources, and then downloading the spec for each resource by going to the individual page.

## Extension

The `underscore` string utility method does a lot of the heavy lifting of changing AWS property names over to ruby method names. As such, it's been extracted to a native extension to increase speed and efficiency. To compile it locally run `rake compile`.

## Docs

To build the docs, run `bin/build-docs`. This will write out a `magic.rb` file that handles the dynamically-generated classes through YARD directives. Once the docs are built, push to the `gh-pages` git subtree which will automatically update the github pages site (`git subtree push --prefix doc origin gh-pages`).
