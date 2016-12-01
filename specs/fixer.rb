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

  fix 'AWS::EC2::SpotFleet is missing a lot of its nested structures' do
    parsed['PropertyTypes'].merge!({
      "AWS::EC2::SpotFleet.LaunchSpecifications": {
        "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html",
        "Properties": {
          "BlockDeviceMappings": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings",
            "Required": false,
            "ItemType": "BlockDeviceMappings",
            "Type": "List",
            "UpdateType": "Mutable"
          },
          "EbsOptimized": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-ebsoptimized",
            "Required": false,
            "PrimitiveType": "Boolean",
            "UpdateType": "Mutable"
          },
          "IamInstanceProfile": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-iaminstanceprofile",
            "Required": false,
            "Type": "IamInstanceProfile",
            "UpdateType": "Mutable"
          },
          "ImageId": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-imageid",
            "Required": true,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          },
          "InstanceType": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-instancetype",
            "Required": true,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          },
          "KernelId": {
            "Documentation": "hhttp://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-kernelid",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          },
          "KeyName": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-keyname",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          },
          "Monitoring": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-monitoring",
            "Required": false,
            "Type": "Monitoring",
            "UpdateType": "Mutable"
          },
          "NetworkInterfaces": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces",
            "Required": false,
            "ItemType": "NetworkInterfaces",
            "Type": "List",
            "UpdateType": "Mutable"
          },
          "Placement": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-placement",
            "Required": false,
            "PrimitiveType": "Boolean",
            "UpdateType": "Mutable"
          },
          "RamdiskId": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-ramdiskid",
            "Required": false,
            "Type": "Placement",
            "UpdateType": "Mutable"
          },
          "SecurityGroups": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-securitygroups",
            "Required": false,
            "ItemType": "SecurityGroups",
            "Type": "List",
            "UpdateType": "Mutable"
          },
          "SpotPrice": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-spotprice",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          },
          "SubnetId": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-subnetid",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          },
          "UserData": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-userdata",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          },
          "WeightedCapacity": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-weightedcapacity",
            "Required": false,
            "PrimitiveType": "Integer",
            "UpdateType": "Mutable"
          }
        }
      },
      "AWS::EC2::SpotFleet.BlockDeviceMappings": {
        "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings.html",
        "Properties": {
          "DeviceName": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-devicename",
            "Required": true,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          },
          "Ebs": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs",
            "Required": false,
            "Type": "Ebs",
            "UpdateType": "Mutable"
          },
          "NoDevice": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-nodevice",
            "Required": false,
            "PrimitiveType": "Boolean",
            "UpdateType": "Mutable"
          },
          "VirtualName": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-virtualname",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          }
        }
      },
      "AWS::EC2::SpotFleet.Ebs": {
        "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs.html",
        "Properties": {
          "DeleteOnTermination": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs-deleteontermination",
            "Required": false,
            "PrimitiveType": "Boolean",
            "UpdateType": "Mutable"
          },
          "Encrypted": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs-encrypted",
            "Required": false,
            "PrimitiveType": "Boolean",
            "UpdateType": "Mutable"
          },
          "Iops": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs-iops",
            "Required": false,
            "PrimitiveType": "Integer",
            "UpdateType": "Mutable"
          },
          "SnapshotId": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs-snapshotid",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          },
          "VolumeSize": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs-volumesize",
            "Required": false,
            "PrimitiveType": "Integer",
            "UpdateType": "Mutable"
          },
          "VolumeType": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-blockdevicemappings-ebs-volumetype",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          }
        }
      },
      "AWS::EC2::SpotFleet.SecurityGroups": {
        "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-securitygroups.html",
        "Properties": {
          "DeleteOnTermination": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-securitygroups.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-securitygroups-groupid",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          }
        }
      },
      "AWS::EC2::SpotFleet.Placement": {
        "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-placement.html",
        "Properties": {
          "AvailabilityZone": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-placement.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-placement-availabilityzone",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          },
          "GroupName": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-placement.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-placement-groupname",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          }
        }
      },
      "AWS::EC2::SpotFleet.NetworkInterfaces": {
        "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces.html",
        "Properties": {
          "AssociatePublicIpAddress": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-associatepublicipaddress",
            "Required": false,
            "PrimitiveType": "Boolean",
            "UpdateType": "Mutable"
          },
          "DeleteOnTermination": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-deleteontermination",
            "Required": false,
            "PrimitiveType": "Boolean",
            "UpdateType": "Mutable"
          },
          "Description": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-description",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          },
          "DeviceIndex": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-deviceindex",
            "Required": true,
            "PrimitiveType": "Integer",
            "UpdateType": "Mutable"
          },
          "Groups": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-groups",
            "Required": false,
            "Type": "List",
            "PrimitiveItemType": "String",
            "UpdateType": "Mutable"
          },
          "NetworkInterfaceId": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-networkinterfaceid",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          },
          "PrivateIpAddresses": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-privateipaddresses",
            "Required": false,
            "Type": "List",
            "ItemType": "PrivateIpAddresses",
            "UpdateType": "Mutable"
          },
          "SecondaryPrivateIpAddressCount": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-secondaryprivateipaddresscount",
            "Required": false,
            "PrimitiveType": "Integer",
            "UpdateType": "Mutable"
          },
          "SubnetId": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-subnetid",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          }
        }
      },
      "AWS::EC2::SpotFleet.IamInstanceProfile": {
        "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-iaminstanceprofile.html",
        "Properties": {
          "Arn": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-iaminstanceprofile.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-iaminstanceprofile-arn",
            "Required": false,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          }
        }
      },
      "AWS::EC2::SpotFleet.Monitoring": {
        "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-monitoring.html",
        "Properties": {
          "Arn": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-monitoring.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-monitoring-enabled",
            "Required": false,
            "PrimitiveType": "Boolean",
            "UpdateType": "Mutable"
          }
        }
      },
      "AWS::EC2::SpotFleet.PrivateIpAddresses": {
        "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-privateipaddresses.html",
        "Properties": {
          "Primary": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-privateipaddresses.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-privateipaddresses-primary",
            "Required": false,
            "PrimitiveType": "Boolean",
            "UpdateType": "Mutable"
          },
          "PrivateIpAddress": {
            "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-privateipaddresses.html#cfn-ec2-spotfleet-spotfleetrequestconfigdata-launchspecifications-networkinterfaces-privateipaddresses-privateipaddress",
            "Required": true,
            "PrimitiveType": "String",
            "UpdateType": "Mutable"
          }
        }
      }
    })
  end
end
