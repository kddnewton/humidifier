module Humidifier
  # a container for user params
  class Configuration
    # The message that gets displayed when the stack body is too large to use
    # the template_body option
    UPLOAD_MESSAGE = <<-MSG.freeze
The %<identifier>s stack's body is too large to be use the template_body option,
and therefore must use the template_url option instead. You can configure
Humidifier to do this automatically by setting up the s3 config on the top-level
Humidifier object like so:

    Humidifier.configure do |config|
      config.s3_bucket = 'my.s3.bucket'
      config.s3_prefix = 'my-prefix/' # optional
    end
MSG

    attr_accessor :s3_bucket, :s3_prefix, :sdk_version

    def initialize(opts = {})
      self.s3_bucket   = opts[:s3_bucket]
      self.s3_prefix   = opts[:s3_prefix]
      self.sdk_version = opts[:sdk_version]
    end

    # raise an error unless the s3_bucket field is set
    def ensure_upload_configured!(payload)
      return if s3_bucket
      raise UPLOAD_MESSAGE.gsub('%<identifier>s', payload.identifier)
    end

    # true if the sdk_version option is set to 1 or '1'
    def sdk_version_1?
      sdk_version.to_s == '1'
    end

    # true if the sdk_version option is set to 2 or '2'
    def sdk_version_2?
      sdk_version.to_s == '2'
    end

    # true if the sdk_version option is set to 3 or '3'
    def sdk_version_3?
      sdk_version.to_s == '3'
    end
  end
end
