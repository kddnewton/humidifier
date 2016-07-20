module Humidifier

  # a container for user params
  class Configuration

    UPLOAD_MESSAGE = <<-MSG.freeze
The %{identifier} stack's body is too large to be use the template_body option, and therefore must use the
template_url option instead. You can configure Humidifier to do this automatically by setting up the s3 config
on the top-level Humidifier object like so:

    Humidifier.configure do |config|
      config.s3_bucket = 'my.s3.bucket'
      config.s3_prefix = 'my-prefix/' # optional
    end
MSG

    attr_accessor :s3_bucket, :s3_prefix

    def initialize(opts = {})
      self.s3_bucket = opts[:s3_bucket]
      self.s3_prefix = opts[:s3_prefix]
    end

    # raise an error unless the s3_bucket field is set
    def ensure_upload_configured!(payload)
      raise UPLOAD_MESSAGE.gsub('%{identifier}', payload.identifier) if s3_bucket.nil?
    end
  end
end
