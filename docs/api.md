# API Reference

- AutoScaling
  - [AutoScalingGroup](#awsautoscalingautoscalinggroup)
  - [LaunchConfiguration](#awsautoscalinglaunchconfiguration)
  - [LifecycleHook](#awsautoscalinglifecyclehook)
  - [ScalingPolicy](#awsautoscalingscalingpolicy)
  - [ScheduledAction](#awsautoscalingscheduledaction)
- CloudFormation
  - [CustomResource](#awscloudformationcustomresource)
  - [Stack](#awscloudformationstack)
  - [WaitCondition](#awscloudformationwaitcondition)
  - [WaitConditionHandle](#awscloudformationwaitconditionhandle)
- CloudFront
  - [Distribution](#awscloudfrontdistribution)
- CloudTrail
  - [Trail](#awscloudtrailtrail)
- CloudWatch
  - [Alarm](#awscloudwatchalarm)
- CodeDeploy
  - [Application](#awscodedeployapplication)
  - [DeploymentConfig](#awscodedeploydeploymentconfig)
  - [DeploymentGroup](#awscodedeploydeploymentgroup)
- CodePipeline
  - [CustomActionType](#awscodepipelinecustomactiontype)
  - [Pipeline](#awscodepipelinepipeline)
- Config
  - [ConfigRule](#awsconfigconfigrule)
  - [ConfigurationRecorder](#awsconfigconfigurationrecorder)
  - [DeliveryChannel](#awsconfigdeliverychannel)
- DataPipeline
  - [Pipeline](#awsdatapipelinepipeline)
- DirectoryService
  - [MicrosoftAD](#awsdirectoryservicemicrosoftad)
  - [SimpleAD](#awsdirectoryservicesimplead)
- DynamoDB
  - [Table](#awsdynamodbtable)
- EC2
  - [CustomerGateway](#awsec2customergateway)
  - [DHCPOptions](#awsec2dhcpoptions)
  - [EIP](#awsec2eip)
  - [EIPAssociation](#awsec2eipassociation)
  - [Instance](#awsec2instance)
  - [InternetGateway](#awsec2internetgateway)
  - [NatGateway](#awsec2natgateway)
  - [NetworkAcl](#awsec2networkacl)
  - [NetworkAclEntry](#awsec2networkaclentry)
  - [NetworkInterface](#awsec2networkinterface)
  - [NetworkInterfaceAttachment](#awsec2networkinterfaceattachment)
  - [PlacementGroup](#awsec2placementgroup)
  - [Route](#awsec2route)
  - [RouteTable](#awsec2routetable)
  - [SecurityGroup](#awsec2securitygroup)
  - [SpotFleet](#awsec2spotfleet)
  - [Subnet](#awsec2subnet)
  - [SubnetNetworkAclAssociation](#awsec2subnetnetworkaclassociation)
  - [SubnetRouteTableAssociation](#awsec2subnetroutetableassociation)
  - [VPC](#awsec2vpc)
  - [VPCDHCPOptionsAssociation](#awsec2vpcdhcpoptionsassociation)
  - [VPCEndpoint](#awsec2vpcendpoint)
  - [VPCGatewayAttachment](#awsec2vpcgatewayattachment)
  - [VPCPeeringConnection](#awsec2vpcpeeringconnection)
  - [VPNConnection](#awsec2vpnconnection)
  - [VPNConnectionRoute](#awsec2vpnconnectionroute)
  - [VPNGateway](#awsec2vpngateway)
  - [VPNGatewayRoutePropagation](#awsec2vpngatewayroutepropagation)
  - [Volume](#awsec2volume)
  - [VolumeAttachment](#awsec2volumeattachment)
- ECR
  - [Repository](#awsecrrepository)
- ECS
  - [Service](#awsecsservice)
  - [TaskDefinition](#awsecstaskdefinition)
- EFS
  - [FileSystem](#awsefsfilesystem)
  - [MountTarget](#awsefsmounttarget)
- EMR
  - [Cluster](#awsemrcluster)
  - [InstanceGroupConfig](#awsemrinstancegroupconfig)
  - [Step](#awsemrstep)
- ElastiCache
  - [CacheCluster](#awselasticachecachecluster)
  - [ParameterGroup](#awselasticacheparametergroup)
  - [ReplicationGroup](#awselasticachereplicationgroup)
  - [SecurityGroup](#awselasticachesecuritygroup)
  - [SecurityGroupIngress](#awselasticachesecuritygroupingress)
  - [SubnetGroup](#awselasticachesubnetgroup)
- ElasticBeanstalk
  - [Application](#awselasticbeanstalkapplication)
  - [ApplicationVersion](#awselasticbeanstalkapplicationversion)
  - [ConfigurationTemplate](#awselasticbeanstalkconfigurationtemplate)
  - [Environment](#awselasticbeanstalkenvironment)
- ElasticLoadBalancing
  - [LoadBalancer](#awselasticloadbalancingloadbalancer)
- Elasticsearch
  - [Domain](#awselasticsearchdomain)
- GameLift
  - [Alias](#awsgameliftalias)
  - [Build](#awsgameliftbuild)
  - [Fleet](#awsgameliftfleet)
- IAM
  - [AccessKey](#awsiamaccesskey)
  - [Group](#awsiamgroup)
  - [InstanceProfile](#awsiaminstanceprofile)
  - [ManagedPolicy](#awsiammanagedpolicy)
  - [Policy](#awsiampolicy)
  - [Role](#awsiamrole)
  - [User](#awsiamuser)
  - [UserToGroupAddition](#awsiamusertogroupaddition)
- KMS
  - [Key](#awskmskey)
- Kinesis
  - [Stream](#awskinesisstream)
- Lambda
  - [Alias](#awslambdaalias)
  - [EventSourceMapping](#awslambdaeventsourcemapping)
  - [Function](#awslambdafunction)
  - [Permission](#awslambdapermission)
  - [Version](#awslambdaversion)
- Logs
  - [Destination](#awslogsdestination)
  - [LogGroup](#awslogsloggroup)
  - [LogStream](#awslogslogstream)
  - [MetricFilter](#awslogsmetricfilter)
  - [SubscriptionFilter](#awslogssubscriptionfilter)
- OpsWorks
  - [App](#awsopsworksapp)
  - [ElasticLoadBalancerAttachment](#awsopsworkselasticloadbalancerattachment)
  - [Instance](#awsopsworksinstance)
  - [Layer](#awsopsworkslayer)
  - [Stack](#awsopsworksstack)
- RDS
  - [DBCluster](#awsrdsdbcluster)
  - [DBClusterParameterGroup](#awsrdsdbclusterparametergroup)
  - [DBInstance](#awsrdsdbinstance)
  - [DBParameterGroup](#awsrdsdbparametergroup)
  - [DBSecurityGroup](#awsrdsdbsecuritygroup)
  - [DBSubnetGroup](#awsrdsdbsubnetgroup)
  - [EventSubscription](#awsrdseventsubscription)
  - [OptionGroup](#awsrdsoptiongroup)
- Redshift
  - [Cluster](#awsredshiftcluster)
  - [ClusterParameterGroup](#awsredshiftclusterparametergroup)
  - [ClusterSecurityGroup](#awsredshiftclustersecuritygroup)
  - [ClusterSecurityGroupIngress](#awsredshiftclustersecuritygroupingress)
  - [ClusterSubnetGroup](#awsredshiftclustersubnetgroup)
- Route53
  - [HealthCheck](#awsroute53healthcheck)
  - [HostedZone](#awsroute53hostedzone)
  - [RecordSet](#awsroute53recordset)
  - [RecordSetGroup](#awsroute53recordsetgroup)
- S3
  - [Bucket](#awss3bucket)
  - [BucketPolicy](#awss3bucketpolicy)
- SDB
  - [Domain](#awssdbdomain)
- SNS
  - [Topic](#awssnstopic)
  - [TopicPolicy](#awssnstopicpolicy)
- SQS
  - [Queue](#awssqsqueue)
  - [QueuePolicy](#awssqsqueuepolicy)
- SSM
  - [Document](#awsssmdocument)
- WAF
  - [ByteMatchSet](#awswafbytematchset)
  - [IPSet](#awswafipset)
  - [Rule](#awswafrule)
  - [SqlInjectionMatchSet](#awswafsqlinjectionmatchset)
  - [WebACL](#awswafwebacl)
- WorkSpaces
  - [Workspace](#awsworkspacesworkspace)

### AWS::AutoScaling::AutoScalingGroup

* availability\_zones (AvailabilityZones: Array)
* cooldown (Cooldown: String)
* desired\_capacity (DesiredCapacity: String)
* health\_check\_grace\_period (HealthCheckGracePeriod: Integer)
* health\_check\_type (HealthCheckType: String)
* instance\_id (InstanceId: String)
* launch\_configuration\_name (LaunchConfigurationName: String)
* load\_balancer\_names (LoadBalancerNames: Array)
* max\_size (MaxSize: String)
* metrics\_collection (MetricsCollection: Array)
* min\_size (MinSize: String)
* notification\_configurations (NotificationConfigurations: Array)
* placement\_group (PlacementGroup: String)
* tags (Tags: Array)
* termination\_policies (TerminationPolicies: Array)
* vpc\_zone\_identifier (VPCZoneIdentifier: Array)

### AWS::AutoScaling::LaunchConfiguration

* associate\_public\_ip\_address (AssociatePublicIpAddress: Boolean)
* block\_device\_mappings (BlockDeviceMappings: Array)
* classic\_link\_vpc\_id (ClassicLinkVPCId: String)
* classic\_link\_vpc\_security\_groups (ClassicLinkVPCSecurityGroups: Array)
* ebs\_optimized (EbsOptimized: Boolean)
* iam\_instance\_profile (IamInstanceProfile: String)
* image\_id (ImageId: String)
* instance\_id (InstanceId: String)
* instance\_monitoring (InstanceMonitoring: Boolean)
* instance\_type (InstanceType: String)
* kernel\_id (KernelId: String)
* key\_name (KeyName: String)
* placement\_tenancy (PlacementTenancy: String)
* ram\_disk\_id (RamDiskId: String)
* security\_groups (SecurityGroups: Array)
* spot\_price (SpotPrice: String)
* user\_data (UserData: String)

### AWS::AutoScaling::LifecycleHook

* auto\_scaling\_group\_name (AutoScalingGroupName: String)
* default\_result (DefaultResult: String)
* heartbeat\_timeout (HeartbeatTimeout: Integer)
* lifecycle\_transition (LifecycleTransition: String)
* notification\_metadata (NotificationMetadata: String)
* notification\_target\_arn (NotificationTargetARN: String)
* role\_arn (RoleARN: String)

### AWS::AutoScaling::ScalingPolicy

* adjustment\_type (AdjustmentType: String)
* auto\_scaling\_group\_name (AutoScalingGroupName: String)
* cooldown (Cooldown: String)
* estimated\_instance\_warmup (EstimatedInstanceWarmup: Integer)
* metric\_aggregation\_type (MetricAggregationType: String)
* min\_adjustment\_magnitude (MinAdjustmentMagnitude: Integer)
* policy\_type (PolicyType: String)
* scaling\_adjustment (ScalingAdjustment: Integer)
* step\_adjustments (StepAdjustments: Array)

### AWS::AutoScaling::ScheduledAction

* auto\_scaling\_group\_name (AutoScalingGroupName: String)
* desired\_capacity (DesiredCapacity: Integer)
* end\_time (EndTime: JSON)
* max\_size (MaxSize: Integer)
* min\_size (MinSize: Integer)
* recurrence (Recurrence: String)
* start\_time (StartTime: JSON)

### AWS::CloudFormation::CustomResource

* service\_token (ServiceToken: String)

### AWS::CloudFormation::Stack

* notification\_ar\_ns (NotificationARNs: Array)
* parameters (Parameters: JSON)
* tags (Tags: Array)
* template\_url (TemplateURL: String)
* timeout\_in\_minutes (TimeoutInMinutes: String)

### AWS::CloudFormation::WaitCondition

* count (Count: String)
* handle (Handle: String)
* timeout (Timeout: String)

### AWS::CloudFormation::WaitConditionHandle


### AWS::CloudFront::Distribution

* distribution\_config (DistributionConfig: JSON)

### AWS::CloudTrail::Trail

* cloud\_watch\_logs\_log\_group\_arn (CloudWatchLogsLogGroupArn: String)
* cloud\_watch\_logs\_role\_arn (CloudWatchLogsRoleArn: String)
* enable\_log\_file\_validation (EnableLogFileValidation: Boolean)
* include\_global\_service\_events (IncludeGlobalServiceEvents: Boolean)
* is\_logging (IsLogging: Boolean)
* is\_multi\_region\_trail (IsMultiRegionTrail: Boolean)
* kms\_key\_id (KMSKeyId: String)
* s3\_bucket\_name (S3BucketName: String)
* s3\_key\_prefix (S3KeyPrefix: String)
* sns\_topic\_name (SnsTopicName: String)
* tags (Tags: Array)

### AWS::CloudWatch::Alarm

* actions\_enabled (ActionsEnabled: Boolean)
* alarm\_actions (AlarmActions: Array)
* alarm\_description (AlarmDescription: String)
* alarm\_name (AlarmName: String)
* comparison\_operator (ComparisonOperator: String)
* dimensions (Dimensions: Array)
* evaluation\_periods (EvaluationPeriods: String)
* insufficient\_data\_actions (InsufficientDataActions: Array)
* metric\_name (MetricName: String)
* namespace (Namespace: String)
* ok\_actions (OKActions: Array)
* period (Period: String)
* statistic (Statistic: String)
* threshold (Threshold: String)
* unit (Unit: String)

### AWS::CodeDeploy::Application

* application\_name (ApplicationName: String)

### AWS::CodeDeploy::DeploymentConfig

* deployment\_config\_name (DeploymentConfigName: String)
* minimum\_healthy\_hosts (MinimumHealthyHosts: JSON)

### AWS::CodeDeploy::DeploymentGroup

* application\_name (ApplicationName: String)
* auto\_scaling\_groups (AutoScalingGroups: Array)
* deployment (Deployment: JSON)
* deployment\_config\_name (DeploymentConfigName: String)
* deployment\_group\_name (DeploymentGroupName: String)
* ec2\_tag\_filters (Ec2TagFilters: Array)
* on\_premises\_instance\_tag\_filters (OnPremisesInstanceTagFilters: Array)
* service\_role\_arn (ServiceRoleArn: String)

### AWS::CodePipeline::CustomActionType

* category (Category: String)
* configuration\_properties (ConfigurationProperties: Array)

### AWS::CodePipeline::Pipeline

* artifact\_store (ArtifactStore: JSON)
* disable\_inbound\_stage\_transitions (DisableInboundStageTransitions: Array)
* name (Name: String)
* restart\_execution\_on\_update (RestartExecutionOnUpdate: Boolean)
* role\_arn (RoleArn: String)
* stages (Stages: Array)

### AWS::Config::ConfigRule

* config\_rule\_name (ConfigRuleName: String)
* description (Description: String)
* input\_parameters (InputParameters: JSON)
* maximum\_execution\_frequency (MaximumExecutionFrequency: String)
* scope (Scope: JSON)
* source (Source: JSON)

### AWS::Config::ConfigurationRecorder

* name (Name: String)
* recording\_group (RecordingGroup: JSON)
* role\_arn (RoleARN: String)

### AWS::Config::DeliveryChannel

* config\_snapshot\_delivery\_properties (ConfigSnapshotDeliveryProperties: JSON)

### AWS::DataPipeline::Pipeline

* activate (Activate: Boolean)
* description (Description: String)
* name (Name: String)
* parameter\_objects (ParameterObjects: Array)
* parameter\_values (ParameterValues: Array)
* pipeline\_objects (PipelineObjects: Array)
* pipeline\_tags (PipelineTags: Array)

### AWS::DirectoryService::MicrosoftAD

* create\_alias (CreateAlias: Boolean)
* enable\_sso (EnableSso: Boolean)
* name (Name: String)
* password (Password: String)
* short\_name (ShortName: String)
* vpc\_settings (VpcSettings: JSON)

### AWS::DirectoryService::SimpleAD

* create\_alias (CreateAlias: Boolean)
* description (Description: String)
* enable\_sso (EnableSso: Boolean)
* name (Name: String)
* password (Password: String)
* short\_name (ShortName: String)
* size (Size: String)
* vpc\_settings (VpcSettings: JSON)

### AWS::DynamoDB::Table

* attribute\_definitions (AttributeDefinitions: Array)
* global\_secondary\_indexes (GlobalSecondaryIndexes: Array)
* key\_schema (KeySchema: Array)
* local\_secondary\_indexes (LocalSecondaryIndexes: Array)
* provisioned\_throughput (ProvisionedThroughput: JSON)
* stream\_specification (StreamSpecification: JSON)
* table\_name (TableName: String)

### AWS::EC2::CustomerGateway

* bgp\_asn (BgpAsn: JSON)
* ip\_address (IpAddress: String)
* tags (Tags: Array)
* type (Type: String)

### AWS::EC2::DHCPOptions

* domain\_name (DomainName: String)
* domain\_name\_servers (DomainNameServers: Array)
* netbios\_name\_servers (NetbiosNameServers: Array)
* netbios\_node\_type (NetbiosNodeType: JSON)
* ntp\_servers (NtpServers: Array)
* tags (Tags: Array)

### AWS::EC2::EIP

* domain (Domain: String)
* instance\_id (InstanceId: String)

### AWS::EC2::EIPAssociation

* allocation\_id (AllocationId: String)
* eip (EIP: String)
* instance\_id (InstanceId: String)
* network\_interface\_id (NetworkInterfaceId: String)
* private\_ip\_address (PrivateIpAddress: String)

### AWS::EC2::Instance

* additional\_info (AdditionalInfo: String)
* availability\_zone (AvailabilityZone: String)
* block\_device\_mappings (BlockDeviceMappings: Array)
* disable\_api\_termination (DisableApiTermination: Boolean)
* ebs\_optimized (EbsOptimized: Boolean)
* iam\_instance\_profile (IamInstanceProfile: String)
* image\_id (ImageId: String)
* instance\_initiated\_shutdown\_behavior (InstanceInitiatedShutdownBehavior: String)
* instance\_type (InstanceType: String)
* kernel\_id (KernelId: String)
* key\_name (KeyName: String)
* monitoring (Monitoring: Boolean)
* network\_interfaces (NetworkInterfaces: Array)
* placement\_group\_name (PlacementGroupName: String)
* private\_ip\_address (PrivateIpAddress: String)
* ramdisk\_id (RamdiskId: String)
* security\_group\_ids (SecurityGroupIds: Array)
* security\_groups (SecurityGroups: Array)
* source\_dest\_check (SourceDestCheck: Boolean)
* ssm\_associations (SsmAssociations: Array)
* subnet\_id (SubnetId: String)
* tags (Tags: Array)
* tenancy (Tenancy: String)
* user\_data (UserData: String)
* volumes (Volumes: Array)

### AWS::EC2::InternetGateway

* tags (Tags: Array)

### AWS::EC2::NatGateway

* allocation\_id (AllocationId: String)
* subnet\_id (SubnetId: String)

### AWS::EC2::NetworkAcl

* tags (Tags: Array)
* vpc\_id (VpcId: String)

### AWS::EC2::NetworkAclEntry

* cidr\_block (CidrBlock: String)
* egress (Egress: Boolean)
* icmp (Icmp: JSON)
* network\_acl\_id (NetworkAclId: String)
* port\_range (PortRange: JSON)
* protocol (Protocol: Integer)
* rule\_action (RuleAction: String)
* rule\_number (RuleNumber: Integer)

### AWS::EC2::NetworkInterface

* description (Description: String)
* group\_set (GroupSet: Array)
* private\_ip\_address (PrivateIpAddress: String)
* private\_ip\_addresses (PrivateIpAddresses: Array)
* secondary\_private\_ip\_address\_count (SecondaryPrivateIpAddressCount: Integer)
* source\_dest\_check (SourceDestCheck: Boolean)
* subnet\_id (SubnetId: String)
* tags (Tags: Array)

### AWS::EC2::NetworkInterfaceAttachment

* delete\_on\_termination (DeleteOnTermination: Boolean)
* device\_index (DeviceIndex: String)
* instance\_id (InstanceId: String)
* network\_interface\_id (NetworkInterfaceId: String)

### AWS::EC2::PlacementGroup

* strategy (Strategy: String)

### AWS::EC2::Route

* destination\_cidr\_block (DestinationCidrBlock: String)
* gateway\_id (GatewayId: String)
* instance\_id (InstanceId: String)
* nat\_gateway\_id (NatGatewayId: String)
* network\_interface\_id (NetworkInterfaceId: String)
* route\_table\_id (RouteTableId: String)
* vpc\_peering\_connection\_id (VpcPeeringConnectionId: String)

### AWS::EC2::RouteTable

* tags (Tags: Array)
* vpc\_id (VpcId: String)

### AWS::EC2::SecurityGroup

* group\_description (GroupDescription: String)
* security\_group\_egress (SecurityGroupEgress: Array)
* security\_group\_ingress (SecurityGroupIngress: Array)
* tags (Tags: Array)
* vpc\_id (VpcId: String)

### AWS::EC2::SpotFleet

* spot\_fleet\_request\_config\_data (SpotFleetRequestConfigData: JSON)

### AWS::EC2::Subnet

* availability\_zone (AvailabilityZone: String)
* cidr\_block (CidrBlock: String)
* map\_public\_ip\_on\_launch (MapPublicIpOnLaunch: Boolean)
* tags (Tags: Array)
* vpc\_id (VpcId: JSON)

### AWS::EC2::SubnetNetworkAclAssociation

* network\_acl\_id (NetworkAclId: JSON)
* subnet\_id (SubnetId: JSON)

### AWS::EC2::SubnetRouteTableAssociation

* route\_table\_id (RouteTableId: String)
* subnet\_id (SubnetId: String)

### AWS::EC2::VPC

* cidr\_block (CidrBlock: String)
* enable\_dns\_hostnames (EnableDnsHostnames: Boolean)
* enable\_dns\_support (EnableDnsSupport: Boolean)
* instance\_tenancy (InstanceTenancy: String)
* tags (Tags: Array)

### AWS::EC2::VPCDHCPOptionsAssociation

* dhcp\_options\_id (DhcpOptionsId: String)
* vpc\_id (VpcId: String)

### AWS::EC2::VPCEndpoint

* policy\_document (PolicyDocument: JSON)
* route\_table\_ids (RouteTableIds: Array)
* service\_name (ServiceName: String)
* vpc\_id (VpcId: String)

### AWS::EC2::VPCGatewayAttachment

* internet\_gateway\_id (InternetGatewayId: String)
* vpc\_id (VpcId: String)
* vpn\_gateway\_id (VpnGatewayId: String)

### AWS::EC2::VPCPeeringConnection

* peer\_vpc\_id (PeerVpcId: String)
* tags (Tags: Array)
* vpc\_id (VpcId: String)

### AWS::EC2::VPNConnection

* customer\_gateway\_id (CustomerGatewayId: JSON)
* static\_routes\_only (StaticRoutesOnly: Boolean)
* tags (Tags: Array)
* type (Type: String)
* vpn\_gateway\_id (VpnGatewayId: JSON)

### AWS::EC2::VPNConnectionRoute

* destination\_cidr\_block (DestinationCidrBlock: String)
* vpn\_connection\_id (VpnConnectionId: String)

### AWS::EC2::VPNGateway

* tags (Tags: Array)
* type (Type: String)

### AWS::EC2::VPNGatewayRoutePropagation

* route\_table\_ids (RouteTableIds: Array)
* vpn\_gateway\_id (VpnGatewayId: String)

### AWS::EC2::Volume

* auto\_enable\_io (AutoEnableIO: Boolean)
* availability\_zone (AvailabilityZone: String)
* encrypted (Encrypted: Boolean)
* iops (Iops: JSON)
* kms\_key\_id (KmsKeyId: String)
* size (Size: String)
* snapshot\_id (SnapshotId: String)
* tags (Tags: Array)
* volume\_type (VolumeType: String)

### AWS::EC2::VolumeAttachment

* device (Device: String)
* instance\_id (InstanceId: String)
* volume\_id (VolumeId: String)

### AWS::ECR::Repository

* repository\_name (RepositoryName: String)
* repository\_policy\_text (RepositoryPolicyText: JSON)

### AWS::ECS::Service

* cluster (Cluster: String)
* desired\_count (DesiredCount: Integer)
* load\_balancers (LoadBalancers: Array)
* role (Role: String)
* task\_definition (TaskDefinition: String)

### AWS::ECS::TaskDefinition

* container\_definitions (ContainerDefinitions: Array)
* volumes (Volumes: Array)

### AWS::EFS::FileSystem

* file\_system\_tags (FileSystemTags: Array)

### AWS::EFS::MountTarget

* file\_system\_id (FileSystemId: String)
* ip\_address (IpAddress: String)
* security\_groups (SecurityGroups: Array)
* subnet\_id (SubnetId: String)

### AWS::EMR::Cluster

* additional\_info (AdditionalInfo: JSON)
* applications (Applications: Array)
* configurations (Configurations: Array)
* ebs\_configuration (EbsConfiguration: JSON)
* instances (Instances: JSON)
* job\_flow\_role (JobFlowRole: String)
* log\_uri (LogUri: String)
* name (Name: String)
* release\_label (ReleaseLabel: String)
* service\_role (ServiceRole: String)
* tags (Tags: Array)
* visible\_to\_all\_users (VisibleToAllUsers: Boolean)

### AWS::EMR::InstanceGroupConfig

* bid\_price (BidPrice: String)
* configurations (Configurations: Array)
* ebs\_configuration (EbsConfiguration: JSON)
* instance\_count (InstanceCount: Integer)
* instance\_role (InstanceRole: String)
* instance\_type (InstanceType: String)
* job\_flow\_id (JobFlowId: String)
* market (Market: String)
* name (Name: String)

### AWS::EMR::Step

* action\_on\_failure (ActionOnFailure: String)
* hadoop\_jar\_step (HadoopJarStep: JSON)
* job\_flow\_id (JobFlowId: String)
* name (Name: String)

### AWS::ElastiCache::CacheCluster

* auto\_minor\_version\_upgrade (AutoMinorVersionUpgrade: Boolean)
* az\_mode (AZMode: String)
* cache\_node\_type (CacheNodeType: String)
* cache\_parameter\_group\_name (CacheParameterGroupName: String)
* cache\_security\_group\_names (CacheSecurityGroupNames: Array)
* cache\_subnet\_group\_name (CacheSubnetGroupName: String)
* cluster\_name (ClusterName: String)
* engine (Engine: String)
* engine\_version (EngineVersion: String)
* notification\_topic\_arn (NotificationTopicArn: String)
* num\_cache\_nodes (NumCacheNodes: String)
* port (Port: Integer)
* preferred\_availability\_zone (PreferredAvailabilityZone: String)
* preferred\_availability\_zones (PreferredAvailabilityZones: Array)
* preferred\_maintenance\_window (PreferredMaintenanceWindow: String)
* snapshot\_arns (SnapshotArns: Array)
* snapshot\_name (SnapshotName: String)
* snapshot\_retention\_limit (SnapshotRetentionLimit: Integer)
* snapshot\_window (SnapshotWindow: String)
* tags (Tags: Array)
* vpc\_security\_group\_ids (VpcSecurityGroupIds: Array)

### AWS::ElastiCache::ParameterGroup

* cache\_parameter\_group\_family (CacheParameterGroupFamily: String)
* description (Description: String)
* properties (Properties: JSON)

### AWS::ElastiCache::ReplicationGroup

* auto\_minor\_version\_upgrade (AutoMinorVersionUpgrade: Boolean)
* automatic\_failover\_enabled (AutomaticFailoverEnabled: Boolean)
* cache\_node\_type (CacheNodeType: String)
* cache\_parameter\_group\_name (CacheParameterGroupName: String)
* cache\_security\_group\_names (CacheSecurityGroupNames: Array)
* cache\_subnet\_group\_name (CacheSubnetGroupName: String)
* engine (Engine: String)
* engine\_version (EngineVersion: String)
* notification\_topic\_arn (NotificationTopicArn: String)
* num\_cache\_clusters (NumCacheClusters: Integer)
* port (Port: Integer)
* preferred\_cache\_cluster\_azs (PreferredCacheClusterAZs: Array)
* preferred\_maintenance\_window (PreferredMaintenanceWindow: String)
* replication\_group\_description (ReplicationGroupDescription: String)
* security\_group\_ids (SecurityGroupIds: Array)
* snapshot\_arns (SnapshotArns: Array)
* snapshot\_retention\_limit (SnapshotRetentionLimit: Integer)
* snapshot\_window (SnapshotWindow: String)

### AWS::ElastiCache::SecurityGroup

* description (Description: String)

### AWS::ElastiCache::SecurityGroupIngress

* cache\_security\_group\_name (CacheSecurityGroupName: String)
* ec2\_security\_group\_name (EC2SecurityGroupName: String)
* ec2\_security\_group\_owner\_id (EC2SecurityGroupOwnerId: String)

### AWS::ElastiCache::SubnetGroup

* description (Description: String)
* subnet\_ids (SubnetIds: Array)

### AWS::ElasticBeanstalk::Application

* application\_name (ApplicationName: String)
* description (Description: String)

### AWS::ElasticBeanstalk::ApplicationVersion

* application\_name (ApplicationName: String)
* description (Description: String)
* source\_bundle (SourceBundle: JSON)

### AWS::ElasticBeanstalk::ConfigurationTemplate

* application\_name (ApplicationName: String)
* description (Description: String)
* environment\_id (EnvironmentId: String)
* option\_settings (OptionSettings: Array)
* solution\_stack\_name (SolutionStackName: String)
* source\_configuration (SourceConfiguration: JSON)

### AWS::ElasticBeanstalk::Environment

* application\_name (ApplicationName: String)
* cname\_prefix (CNAMEPrefix: String)
* description (Description: String)
* environment\_name (EnvironmentName: String)
* option\_settings (OptionSettings: Array)
* solution\_stack\_name (SolutionStackName: String)
* tags (Tags: Array)
* template\_name (TemplateName: String)
* tier (Tier: JSON)
* version\_label (VersionLabel: String)

### AWS::ElasticLoadBalancing::LoadBalancer

* access\_logging\_policy (AccessLoggingPolicy: JSON)
* app\_cookie\_stickiness\_policy (AppCookieStickinessPolicy: Array)
* availability\_zones (AvailabilityZones: Array)
* connection\_draining\_policy (ConnectionDrainingPolicy: JSON)
* connection\_settings (ConnectionSettings: JSON)
* cross\_zone (CrossZone: Boolean)
* health\_check (HealthCheck: JSON)
* instances (Instances: Array)
* lb\_cookie\_stickiness\_policy (LBCookieStickinessPolicy: Array)
* listeners (Listeners: Array)
* load\_balancer\_name (LoadBalancerName: String)
* policies (Policies: Array)
* scheme (Scheme: String)
* security\_groups (SecurityGroups: Array)
* subnets (Subnets: Array)
* tags (Tags: Array)

### AWS::Elasticsearch::Domain

* access\_policies (AccessPolicies: JSON)
* advanced\_options (AdvancedOptions: JSON)
* domain\_name (DomainName: String)
* ebs\_options (EBSOptions: JSON)
* elasticsearch\_cluster\_config (ElasticsearchClusterConfig: JSON)
* snapshot\_options (SnapshotOptions: JSON)
* tags (Tags: Array)

### AWS::GameLift::Alias

* description (Description: String)
* name (Name: String)
* routing\_strategy (RoutingStrategy: JSON)

### AWS::GameLift::Build

* name (Name: String)
* storage\_location (StorageLocation: JSON)
* version (Version: String)

### AWS::GameLift::Fleet

* build\_id (BuildId: String)
* description (Description: String)
* desired\_ec2\_instances (DesiredEC2Instances: Integer)
* ec2\_inbound\_permissions (EC2InboundPermissions: Array)
* ec2\_instance\_type (EC2InstanceType: String)
* log\_paths (LogPaths: Array)
* name (Name: String)
* server\_launch\_parameters (ServerLaunchParameters: String)
* server\_launch\_path (ServerLaunchPath: String)

### AWS::IAM::AccessKey

* serial (Serial: Integer)
* status (Status: String)
* user\_name (UserName: String)

### AWS::IAM::Group

* managed\_policy\_arns (ManagedPolicyArns: Array)
* path (Path: String)
* policies (Policies: Array)

### AWS::IAM::InstanceProfile

* path (Path: String)
* roles (Roles: Array)

### AWS::IAM::ManagedPolicy

* description (Description: String)
* groups (Groups: Array)
* path (Path: String)
* policy\_document (PolicyDocument: JSON)
* roles (Roles: Array)
* users (Users: Array)

### AWS::IAM::Policy

* groups (Groups: Array)
* policy\_document (PolicyDocument: JSON)
* policy\_name (PolicyName: String)
* roles (Roles: Array)
* users (Users: Array)

### AWS::IAM::Role

* assume\_role\_policy\_document (AssumeRolePolicyDocument: JSON)
* managed\_policy\_arns (ManagedPolicyArns: Array)
* path (Path: String)
* policies (Policies: Array)

### AWS::IAM::User

* groups (Groups: Array)
* login\_profile (LoginProfile: JSON)
* managed\_policy\_arns (ManagedPolicyArns: Array)
* path (Path: String)
* policies (Policies: Array)

### AWS::IAM::UserToGroupAddition

* group\_name (GroupName: String)
* users (Users: Array)

### AWS::KMS::Key

* description (Description: String)
* enable\_key\_rotation (EnableKeyRotation: Boolean)
* enabled (Enabled: Boolean)
* key\_policy (KeyPolicy: JSON)

### AWS::Kinesis::Stream

* shard\_count (ShardCount: Integer)
* tags (Tags: Array)

### AWS::Lambda::Alias

* description (Description: String)
* function\_name (FunctionName: String)
* function\_version (FunctionVersion: String)
* name (Name: String)

### AWS::Lambda::EventSourceMapping

* batch\_size (BatchSize: Integer)
* enabled (Enabled: Boolean)
* event\_source\_arn (EventSourceArn: String)
* function\_name (FunctionName: String)
* starting\_position (StartingPosition: String)

### AWS::Lambda::Function

* code (Code: JSON)
* description (Description: String)
* function\_name (FunctionName: String)
* handler (Handler: String)
* memory\_size (MemorySize: Integer)
* role (Role: String)
* runtime (Runtime: String)
* timeout (Timeout: Integer)
* vpc\_config (VpcConfig: JSON)

### AWS::Lambda::Permission

* action (Action: String)
* function\_name (FunctionName: String)
* principal (Principal: String)
* source\_account (SourceAccount: String)
* source\_arn (SourceArn: String)

### AWS::Lambda::Version

* code\_sha256 (CodeSha256: String)
* description (Description: String)
* function\_name (FunctionName: String)

### AWS::Logs::Destination

* destination\_name (DestinationName: String)
* destination\_policy (DestinationPolicy: String)
* role\_arn (RoleArn: String)
* target\_arn (TargetArn: String)

### AWS::Logs::LogGroup

* retention\_in\_days (RetentionInDays: Integer)

### AWS::Logs::LogStream

* log\_group\_name (LogGroupName: String)
* log\_stream\_name (LogStreamName: String)

### AWS::Logs::MetricFilter

* filter\_pattern (FilterPattern: Array)
* log\_group\_name (LogGroupName: String)
* metric\_transformations (MetricTransformations: Array)

### AWS::Logs::SubscriptionFilter

* destination\_arn (DestinationArn: String)
* filter\_pattern (FilterPattern: String)
* log\_group\_name (LogGroupName: String)
* role\_arn (RoleArn: String)

### AWS::OpsWorks::App

* app\_source (AppSource: JSON)
* attributes (Attributes: JSON)
* description (Description: String)
* domains (Domains: Array)
* enable\_ssl (EnableSsl: Boolean)
* environment (Environment: Array)
* name (Name: String)
* shortname (Shortname: String)
* ssl\_configuration (SslConfiguration: JSON)
* stack\_id (StackId: String)
* type (Type: String)

### AWS::OpsWorks::ElasticLoadBalancerAttachment

* elastic\_load\_balancer\_name (ElasticLoadBalancerName: String)
* layer\_id (LayerId: String)

### AWS::OpsWorks::Instance

* ami\_id (AmiId: String)
* architecture (Architecture: String)
* auto\_scaling\_type (AutoScalingType: String)
* availability\_zone (AvailabilityZone: String)
* ebs\_optimized (EbsOptimized: Boolean)
* install\_updates\_on\_boot (InstallUpdatesOnBoot: Boolean)
* instance\_type (InstanceType: String)
* layer\_ids (LayerIds: Array)
* os (Os: String)
* root\_device\_type (RootDeviceType: String)
* ssh\_key\_name (SshKeyName: String)
* stack\_id (StackId: String)
* subnet\_id (SubnetId: String)
* time\_based\_auto\_scaling (TimeBasedAutoScaling: JSON)

### AWS::OpsWorks::Layer

* attributes (Attributes: JSON)
* auto\_assign\_elastic\_ips (AutoAssignElasticIps: Boolean)
* auto\_assign\_public\_ips (AutoAssignPublicIps: Boolean)
* custom\_instance\_profile\_arn (CustomInstanceProfileArn: String)
* custom\_recipes (CustomRecipes: JSON)
* custom\_security\_group\_ids (CustomSecurityGroupIds: Array)
* enable\_auto\_healing (EnableAutoHealing: Boolean)
* install\_updates\_on\_boot (InstallUpdatesOnBoot: Boolean)
* lifecycle\_event\_configuration (LifecycleEventConfiguration: JSON)
* load\_based\_auto\_scaling (LoadBasedAutoScaling: JSON)
* name (Name: String)
* packages (Packages: Array)
* shortname (Shortname: String)
* stack\_id (StackId: String)
* type (Type: String)
* volume\_configurations (VolumeConfigurations: Array)

### AWS::OpsWorks::Stack

* agent\_version (AgentVersion: String)
* attributes (Attributes: JSON)
* chef\_configuration (ChefConfiguration: JSON)
* configuration\_manager (ConfigurationManager: JSON)
* custom\_cookbooks\_source (CustomCookbooksSource: JSON)
* custom\_json (CustomJson: JSON)
* default\_availability\_zone (DefaultAvailabilityZone: String)
* default\_instance\_profile\_arn (DefaultInstanceProfileArn: String)
* default\_os (DefaultOs: String)
* default\_root\_device\_type (DefaultRootDeviceType: String)
* default\_ssh\_key\_name (DefaultSshKeyName: String)
* default\_subnet\_id (DefaultSubnetId: String)
* hostname\_theme (HostnameTheme: String)
* name (Name: String)
* service\_role\_arn (ServiceRoleArn: String)
* use\_custom\_cookbooks (UseCustomCookbooks: Boolean)
* use\_opsworks\_security\_groups (UseOpsworksSecurityGroups: Boolean)
* vpc\_id (VpcId: String)

### AWS::RDS::DBCluster

* availability\_zones (AvailabilityZones: Array)
* backup\_retention\_period (BackupRetentionPeriod: Integer)
* database\_name (DatabaseName: String)
* db\_cluster\_parameter\_group\_name (DBClusterParameterGroupName: String)
* db\_subnet\_group\_name (DBSubnetGroupName: String)
* engine (Engine: String)
* engine\_version (EngineVersion: String)
* kms\_key\_id (KmsKeyId: String)
* master\_user\_password (MasterUserPassword: String)
* master\_username (MasterUsername: String)
* port (Port: Integer)
* preferred\_backup\_window (PreferredBackupWindow: String)
* preferred\_maintenance\_window (PreferredMaintenanceWindow: String)
* snapshot\_identifier (SnapshotIdentifier: String)
* storage\_encrypted (StorageEncrypted: Boolean)
* tags (Tags: Array)
* vpc\_security\_group\_ids (VpcSecurityGroupIds: Array)

### AWS::RDS::DBClusterParameterGroup

* description (Description: String)
* family (Family: String)
* parameters (Parameters: JSON)
* tags (Tags: Array)

### AWS::RDS::DBInstance

* allocated\_storage (AllocatedStorage: String)
* allow\_major\_version\_upgrade (AllowMajorVersionUpgrade: Boolean)
* auto\_minor\_version\_upgrade (AutoMinorVersionUpgrade: Boolean)
* availability\_zone (AvailabilityZone: String)
* backup\_retention\_period (BackupRetentionPeriod: String)
* character\_set\_name (CharacterSetName: String)
* db\_cluster\_identifier (DBClusterIdentifier: String)
* db\_instance\_class (DBInstanceClass: String)
* db\_instance\_identifier (DBInstanceIdentifier: String)
* db\_name (DBName: String)
* db\_parameter\_group\_name (DBParameterGroupName: String)
* db\_security\_groups (DBSecurityGroups: Array)
* db\_snapshot\_identifier (DBSnapshotIdentifier: String)
* db\_subnet\_group\_name (DBSubnetGroupName: String)
* engine (Engine: String)
* engine\_version (EngineVersion: String)
* iops (Iops: JSON)
* kms\_key\_id (KmsKeyId: String)
* license\_model (LicenseModel: String)
* master\_user\_password (MasterUserPassword: String)
* master\_username (MasterUsername: String)
* multi\_az (MultiAZ: Boolean)
* option\_group\_name (OptionGroupName: String)
* port (Port: String)
* preferred\_backup\_window (PreferredBackupWindow: String)
* preferred\_maintenance\_window (PreferredMaintenanceWindow: String)
* publicly\_accessible (PubliclyAccessible: Boolean)
* source\_db\_instance\_identifier (SourceDBInstanceIdentifier: String)
* storage\_encrypted (StorageEncrypted: Boolean)
* storage\_type (StorageType: String)
* tags (Tags: Array)
* vpc\_security\_groups (VPCSecurityGroups: Array)

### AWS::RDS::DBParameterGroup

* description (Description: String)
* family (Family: String)
* parameters (Parameters: JSON)
* tags (Tags: Array)

### AWS::RDS::DBSecurityGroup

* db\_security\_group\_ingress (DBSecurityGroupIngress: Array)
* ec2\_vpc\_id (EC2VpcId: JSON)
* group\_description (GroupDescription: String)
* tags (Tags: Array)

### AWS::RDS::DBSubnetGroup

* db\_subnet\_group\_description (DBSubnetGroupDescription: String)
* subnet\_ids (SubnetIds: Array)
* tags (Tags: Array)

### AWS::RDS::EventSubscription

* enabled (Enabled: Boolean)
* event\_categories (EventCategories: Array)
* sns\_topic\_arn (SnsTopicArn: String)
* source\_ids (SourceIds: Array)
* source\_type (SourceType: String)

### AWS::RDS::OptionGroup

* engine\_name (EngineName: String)
* major\_engine\_version (MajorEngineVersion: String)
* option\_configurations (OptionConfigurations: Array)
* option\_group\_description (OptionGroupDescription: String)
* tags (Tags: Array)

### AWS::Redshift::Cluster

* allow\_version\_upgrade (AllowVersionUpgrade: Boolean)
* automated\_snapshot\_retention\_period (AutomatedSnapshotRetentionPeriod: Integer)
* availability\_zone (AvailabilityZone: String)
* cluster\_parameter\_group\_name (ClusterParameterGroupName: String)
* cluster\_security\_groups (ClusterSecurityGroups: Array)
* cluster\_subnet\_group\_name (ClusterSubnetGroupName: String)
* cluster\_type (ClusterType: String)
* cluster\_version (ClusterVersion: String)
* db\_name (DBName: String)
* elastic\_ip (ElasticIp: String)
* encrypted (Encrypted: Boolean)
* hsm\_client\_certificate\_identifier (HsmClientCertificateIdentifier: String)
* hsm\_configuration\_identifier (HsmConfigurationIdentifier: String)
* kms\_key\_id (KmsKeyId: String)
* master\_user\_password (MasterUserPassword: String)
* master\_username (MasterUsername: String)
* node\_type (NodeType: String)
* number\_of\_nodes (NumberOfNodes: Integer)
* owner\_account (OwnerAccount: String)
* port (Port: Integer)
* preferred\_maintenance\_window (PreferredMaintenanceWindow: String)
* publicly\_accessible (PubliclyAccessible: Boolean)
* snapshot\_cluster\_identifier (SnapshotClusterIdentifier: String)
* snapshot\_identifier (SnapshotIdentifier: String)
* vpc\_security\_group\_ids (VpcSecurityGroupIds: Array)

### AWS::Redshift::ClusterParameterGroup

* description (Description: String)
* parameter\_group\_family (ParameterGroupFamily: String)
* parameters (Parameters: Array)

### AWS::Redshift::ClusterSecurityGroup

* description (Description: String)

### AWS::Redshift::ClusterSecurityGroupIngress

* cidrip (CIDRIP: String)
* cluster\_security\_group\_name (ClusterSecurityGroupName: String)
* ec2\_security\_group\_name (EC2SecurityGroupName: String)
* ec2\_security\_group\_owner\_id (EC2SecurityGroupOwnerId: String)

### AWS::Redshift::ClusterSubnetGroup

* description (Description: String)
* subnet\_ids (SubnetIds: Array)

### AWS::Route53::HealthCheck

* health\_check\_config (HealthCheckConfig: JSON)
* health\_check\_tags (HealthCheckTags: Array)

### AWS::Route53::HostedZone

* hosted\_zone\_config (HostedZoneConfig: JSON)
* hosted\_zone\_tags (HostedZoneTags: Array)
* name (Name: String)
* vp\_cs (VPCs: Array)

### AWS::Route53::RecordSet

* alias\_target (AliasTarget: JSON)
* comment (Comment: String)
* failover (Failover: String)
* geo\_location (GeoLocation: JSON)
* health\_check\_id (HealthCheckId: String)
* hosted\_zone\_id (HostedZoneId: String)
* hosted\_zone\_name (HostedZoneName: String)
* name (Name: String)
* region (Region: String)
* resource\_records (ResourceRecords: Array)
* set\_identifier (SetIdentifier: String)
* ttl (TTL: String)
* type (Type: String)
* weight (Weight: Integer)

### AWS::Route53::RecordSetGroup

* comment (Comment: String)
* hosted\_zone\_id (HostedZoneId: String)
* hosted\_zone\_name (HostedZoneName: String)
* record\_sets (RecordSets: Array)

### AWS::S3::Bucket

* access\_control (AccessControl: String)
* bucket\_name (BucketName: String)
* cors\_configuration (CorsConfiguration: JSON)
* lifecycle\_configuration (LifecycleConfiguration: JSON)
* logging\_configuration (LoggingConfiguration: JSON)
* notification\_configuration (NotificationConfiguration: JSON)
* replication\_configuration (ReplicationConfiguration: JSON)
* tags (Tags: Array)
* versioning\_configuration (VersioningConfiguration: JSON)
* website\_configuration (WebsiteConfiguration: JSON)

### AWS::S3::BucketPolicy

* bucket (Bucket: String)
* policy\_document (PolicyDocument: JSON)

### AWS::SDB::Domain

* description (Description: JSON)

### AWS::SNS::Topic

* display\_name (DisplayName: String)
* subscription (Subscription: Array)
* topic\_name (TopicName: String)

### AWS::SNS::TopicPolicy

* policy\_document (PolicyDocument: JSON)
* topics (Topics: Array)

### AWS::SQS::Queue

* delay\_seconds (DelaySeconds: Integer)
* maximum\_message\_size (MaximumMessageSize: Integer)
* message\_retention\_period (MessageRetentionPeriod: Integer)
* queue\_name (QueueName: String)
* receive\_message\_wait\_time\_seconds (ReceiveMessageWaitTimeSeconds: Integer)
* redrive\_policy (RedrivePolicy: JSON)
* visibility\_timeout (VisibilityTimeout: Integer)

### AWS::SQS::QueuePolicy

* policy\_document (PolicyDocument: JSON)
* queues (Queues: Array)

### AWS::SSM::Document

* content (Content: JSON)

### AWS::WAF::ByteMatchSet

* byte\_match\_tuples (ByteMatchTuples: Array)
* name (Name: String)

### AWS::WAF::IPSet

* ip\_set\_descriptors (IPSetDescriptors: Array)
* name (Name: String)

### AWS::WAF::Rule

* metric\_name (MetricName: String)
* name (Name: String)
* predicates (Predicates: Array)

### AWS::WAF::SqlInjectionMatchSet

* name (Name: String)
* sql\_injection\_match\_tuples (SqlInjectionMatchTuples: Array)

### AWS::WAF::WebACL

* default\_action (DefaultAction: JSON)
* metric\_name (MetricName: String)
* name (Name: String)
* rules (Rules: Array)

### AWS::WorkSpaces::Workspace

* bundle\_id (BundleId: String)
* directory\_id (DirectoryId: String)
* root\_volume\_encryption\_enabled (RootVolumeEncryptionEnabled: Boolean)
* user\_name (UserName: String)
* user\_volume\_encryption\_enabled (UserVolumeEncryptionEnabled: Boolean)
* volume\_encryption\_key (VolumeEncryptionKey: String)

