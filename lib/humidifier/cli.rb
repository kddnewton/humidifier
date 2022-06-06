# frozen_string_literal: true

module Humidifier
  # A CLI for running commands to manipulate the stacks that Humidifier knows
  # about.
  class CLI < Thor
    class_option :aws_profile, desc: "The AWS profile to authenticate with",
                               aliases: ["-p"]

    class_option :debug, desc: "Sets up debug mode", aliases: ["-d"]
    class_around :safe_execute

    desc "change [?stack]", "Create changesets for one or all stacks"
    def change(name = nil)
      authorize

      stack_names_from(name).each do |stack_name|
        directory = Directory.new(stack_name)

        puts "🛠 Creating a changeset for #{directory.stack_name}"
        directory.create_change_set
      end
    end

    desc "deploy [?stack] [*parameters]", "Update one or all stacks"
    option :wait, desc: "Wait for the stack to create/update",
                  type: :boolean, default: false
    option :prefix, desc: "The prefix to use for the stack"
    def deploy(name = nil, *parameters)
      authorize

      stack_names_from(name).each do |stack_name|
        directory = Directory.new(stack_name, prefix: options[:prefix])

        puts "🚀 Deploying #{directory.stack_name}"
        directory.deploy(options[:wait], parameters_from(parameters))
      end
    end

    desc "display [stack] [?pattern]",
         "Display the CloudFormation JSON for a given stack"
    def display(name, pattern = nil)
      directory = Directory.new(name, pattern: pattern && /#{pattern}/i)

      puts "📄 Displaying #{directory.stack_name}"
      puts directory.to_cf
    end

    desc "stacks", "List the stacks known to Humidifier"
    def stacks
      puts "🗒 Listing stacks"
      puts Humidifier.config.stack_names.sort.map { |name| "- #{name}" }
    end

    desc "upgrade", "Download the latest CloudFormation resource specification"
    def upgrade
      print "💾 Downloading..."

      version = Upgrade.perform
      puts " upgraded to v#{version}"
    end

    desc "upload [?stack]", "Upload one or all stacks to S3"
    def upload(name = nil)
      authorize

      stack_names_from(name).each do |stack_name|
        directory = Directory.new(stack_name)

        puts "📬 Uploading #{directory.stack_name}"
        directory.upload
      end
    end

    desc "validate [?stack]",
         "Validate that one or all stacks are valid with CloudFormation"
    def validate(name = nil)
      authorize

      print "🔍 Validating... "

      valid =
        stack_names_from(name).all? do |stack_name|
          Directory.new(stack_name).valid?
        end

      puts valid ? "Valid." : "Invalid."
    end

    no_commands do
      def authorize
        return unless options[:aws_profile]

        Aws.config[:credentials] =
          Aws::SharedCredentials.new(profile_name: options[:aws_profile])
      end

      def parameters_from(opts)
        opts.map do |opt|
          key, value = opt.split("=")
          { parameter_key: key, parameter_value: value }
        end
      end

      def prelude
        command = @_invocations.values.dig(0, 0)
        command = command ? "#{command} " : ""
        puts "\033[1mhumidifier #{command}v#{VERSION}\033[0m"
      end

      def safe_execute
        prelude
        start = Time.now.to_f
        yield
      rescue Error => error
        raise error if options[:debug]

        puts error.message
        exit 1
      else
        puts "✨ Done in %.2fs." % (Time.now.to_f - start)
      end

      def stack_names_from(name)
        name ? [name] : Humidifier.config.stack_names
      end
    end
  end
end
