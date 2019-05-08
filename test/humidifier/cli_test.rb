# frozen_string_literal: true

require 'test_helper'

module Humidifier
  class CLITest < Minitest::Test
    DirectoryDouble =
      Struct.new(:stack_name, :valid?) do
        def create_change_set; end

        def deploy(*); end

        def upload; end
      end

    def test_change
      Directory.stub(:new, DirectoryDouble.new('alpha')) do
        assert_includes execute('change'), 'Creating a changeset for alpha'
      end
    end

    def test_deploy
      Directory.stub(:new, DirectoryDouble.new('alpha')) do
        stdout = execute('deploy alpha ParameterOne=OneOne ParameterTwo=TwoTwo')

        assert_includes stdout, 'Deploying alpha'
      end
    end

    def test_display
      parsed = parse_display(execute('display alpha'))

      assert_kind_of Hash, parsed
      assert_equal RESOURCE_NAMES, parsed['Resources'].keys
    end

    def test_display_with_pattern
      parsed = parse_display(execute('display alpha User1'))

      assert_kind_of Hash, parsed
      assert_equal %w[AlphaUser1], parsed['Resources'].keys
    end

    def test_stacks
      stdout = execute('stacks')

      assert_includes stdout, 'alpha'
      assert_includes stdout, 'beta'
    end

    def test_upload
      Directory.stub(:new, DirectoryDouble.new('alpha')) do
        assert_includes execute('upload'), 'Uploading alpha'
      end
    end

    def test_validate
      Directory.stub(:new, DirectoryDouble.new('alpha', true)) do
        assert_includes execute('validate alpha'), 'Validating... Valid'
      end
    end

    def test_validate_invalid
      Directory.stub(:new, DirectoryDouble.new('alpha', false)) do
        assert_includes execute('validate alpha'), 'Validating... Invalid.'
      end
    end

    def test_authorize
      cli = CLI.new([], aws_profile: 'default')

      begin
        cli.authorize
        assert_kind_of Aws::SharedCredentials, Aws.config[:credentials]
      ensure
        Aws.config.delete(:credentials)
      end
    end

    def test_safe_execute_debug
      cli = CLI.new([], debug: true)

      cli.stub(:exit, nil) do
        assert_raises Error do
          capture_io { cli.safe_execute { raise Error } }
        end
      end
    end

    def test_safe_execute
      cli = CLI.new([])

      cli.stub(:exit, nil) do
        stdout, = capture_io { cli.safe_execute { raise Error, 'foobar' } }

        assert_includes stdout, 'foobar'
      end
    end

    private

    def execute(command)
      stdout, = capture_io { CLI.start(command.split) }
      stdout
    end

    def parse_display(stdout)
      lines = stdout.split("\n")

      first = lines.index { |line| line.chomp == '{' }
      last = lines.rindex { |line| line.chomp == '}' }

      JSON.parse(lines[first..last].join)
    end
  end
end
