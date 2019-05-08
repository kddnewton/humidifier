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
      stdout, =
        capture_io do
          Config::Directory.stub(:new, DirectoryDouble.new('alpha')) do
            execute('change')
          end
        end

      assert_equal "Creating a changeset for alpha\n" * 2, stdout
    end

    def test_deploy
      stdout, =
        capture_io do
          Config::Directory.stub(:new, DirectoryDouble.new('alpha')) do
            execute('deploy alpha ParameterOne=OneOne ParameterTwo=TwoTwo')
          end
        end

      assert_equal "Deploying alpha\n", stdout
    end

    def test_display
      stdout, = capture_io { execute('display alpha') }
      parsed = JSON.parse(stdout)

      assert_kind_of Hash, parsed
      assert_equal RESOURCE_NAMES, parsed['Resources'].keys
    end

    def test_display_with_pattern
      stdout, = capture_io { execute('display alpha User1') }
      parsed = JSON.parse(stdout)

      assert_kind_of Hash, parsed
      assert_equal %w[AlphaUser1], parsed['Resources'].keys
    end

    def test_upload
      stdout, =
        capture_io do
          Config::Directory.stub(:new, DirectoryDouble.new('alpha')) do
            execute('upload')
          end
        end

      assert_equal "Uploading alpha\n" * 2, stdout
    end

    def test_validate
      Config::Directory.stub(:new, DirectoryDouble.new('alpha', true)) do
        stdout, = capture_io { execute('validate alpha') }

        assert_equal "Validating... Valid.\n", stdout
      end
    end

    def test_validate_invalid
      Config::Directory.stub(:new, DirectoryDouble.new('alpha', false)) do
        stdout, = capture_io { execute('validate alpha') }
        assert_equal "Validating... Invalid.\n", stdout
      end
    end

    def test_authorize
      cli = CLI.new([], aws_profile: 'default')
      old_credentials = Aws.config[:credentials]

      begin
        cli.authorize
        assert_kind_of Aws::SharedCredentials, Aws.config[:credentials]
      ensure
        Aws.config[:credentials] = old_credentials
      end
    end

    def test_safe_execute_debug
      cli = CLI.new([], debug: true)

      cli.stub(:exit, nil) do
        assert_raises Error do
          cli.safe_execute { raise Error }
        end
      end
    end

    def test_safe_execute
      cli = CLI.new([])

      cli.stub(:exit, nil) do
        stdout, = capture_io { cli.safe_execute { raise Error, 'foobar' } }

        assert_equal "foobar\n", stdout
      end
    end

    private

    def execute(command)
      CLI.start(command.split)
    end
  end
end
