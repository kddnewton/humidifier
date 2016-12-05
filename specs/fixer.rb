class Fixer
  attr_reader :filepath, :parsed

  def initialize(filepath)
    @filepath = filepath
    @parsed   = JSON.parse(File.read(filepath))
  end

  def write
    self.class.fixes.each { |fix| send(fix) }
    File.write(filepath, JSON.pretty_generate(parsed))
  end

  class << self
    attr_reader :fixes

    def fix(_reason, &block)
      fix_name = :"fix_#{fixes.length}"
      define_method(fix_name, &block)
      @fixes << fix_name
    end
  end
  @fixes = []

  fix 'AWS::ElasticLoadBalancing::LoadBalancer.Policies references invalid ItemType "json"' do
    parsed['PropertyTypes']['AWS::ElasticLoadBalancing::LoadBalancer.Policies']['Properties']['Attributes'].delete('ItemType')
    parsed['PropertyTypes']['AWS::ElasticLoadBalancing::LoadBalancer.Policies']['Properties']['Attributes']['PrimitiveItemType'] = 'Json'
  end

  fix 'AWS::DynamoDB::Table references invalid ItemType "AttributeDefinition"' do
    parsed['ResourceTypes']['AWS::DynamoDB::Table']['Properties']['AttributeDefinitions']['ItemType'] = 'AttributeDefinitions'
  end

  fix 'AWS::CloudFront::Distribution.Origin references missing ItemType "OriginCustomHeader"' do
    parsed['PropertyTypes']['AWS::CloudFront::Distribution.OriginCustomHeader'] = {
      "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-origin-origincustomheader.html",
      "Properties": {
        "HeaderName": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-origin-origincustomheader.html#cfn-cloudfront-origin-origincustomheader-headername",
          "Required": true,
          "PrimitiveType": "String",
          "UpdateType": "Mutable"
        },
        "HeaderValue": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-cloudfront-origin-origincustomheader.html#cfn-cloudfront-origin-origincustomheader-headervalue",
          "PrimitiveType": "String",
          "Required": true,
          "UpdateType": "Mutable"
        }
      }
    }
  end
end
