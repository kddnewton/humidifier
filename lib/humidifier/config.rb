# frozen_string_literal: true

module Humidifier
  # A container for user params
  class Config
    # If true, always upload the CloudFormation template to the configured S3
    # destination. A useful option if you're going to be deploying multiple
    # copies of a template or you just generally want a backup.
    attr_accessor :force_upload

    # The S3 bucket to which to deploy CloudFormation templates when
    # `always_upload` is set to true or the template is too big for a string
    # literal.
    attr_accessor :s3_bucket

    # An optional prefix for the JSON file names.
    attr_accessor :s3_prefix

    def initialize(opts = {})
      @force_upload = opts[:force_upload]
      @s3_bucket    = opts[:s3_bucket]
      @s3_prefix    = opts[:s3_prefix]
    end

    # raise an error unless the s3_bucket field is set
    def ensure_upload_configured!(identifier)
      return if s3_bucket

      upload_message = <<-MSG
The %<identifier>s stack's body is too large to be use the template_body option,
and therefore must use the template_url option instead. You can configure
Humidifier to do this automatically by setting up the s3 config on the top-level
Humidifier object like so:

    Humidifier.configure do |config|
      config.s3_bucket = 'my.s3.bucket'
      config.s3_prefix = 'my-prefix/' # optional
    end
MSG

      raise upload_message.gsub('%<identifier>s', identifier)
    end
  end
end
