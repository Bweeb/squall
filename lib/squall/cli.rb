require 'optparse'
module Squall
  class CLI
    autoload :Group,   'squall/cli/group'
    autoload :Command, 'squall/cli/command'

    class << self
      def groups
        @groups ||= []
      end

      def group(name, &block)
        unless groups.assoc(name)
          group = Group.new(name)
          groups << [name, group]
          group.instance_eval(&block) if block_given?
        end
      end
    end

    attr_reader :parser

    def initialize(argv = [])
      @command    = argv.shift
      @subcommand = argv.shift unless argv.first.to_s.match(/^--/)
      @argv       = argv
      @parser     = OptionParser.new do |o|
        o.program_name = "squall #{@command} #{@subcommand}".strip
      end
    end

    def help
      help = %{Usage: squall [command]

        Command list:
                virtual_machine             Manage virtual machines

        Help:
                --version                   Show Squall version
                --help                      Show this message

        See 'squall [command] --help' for more information on a specific command.}
      help.gsub(/^        /, '')
    end

    # Dispatches the CLI
    #
    # Looks for a CLI group named @command, then
    # tries to run @subcommand using the CLI group's #driver
    # method
    def dispatch!
      group_name   = @command && @command.to_sym
      command_name = @subcommand && @subcommand.to_sym
      if group_name && group = self.class.groups.assoc(group_name)
        group = group[1]
        if command_name && command = group.commands.assoc(command_name)
          command = command[1]
          command.build_parser(@parser)
        else
          if command_name && command_name != '--help'
            puts "Error: invalid command #{command_name}"
            exit_code = -1
          else
            exit_code = 0
          end
          puts group.help
          exit(exit_code)
        end
      else
        if group_name && group_name != '--help'
          puts "Error: invalid command #{group_name}"
          exit_code = -1
        else
          exit_code = 0
        end
        puts help
        exit(-1)
      end

      # case @command
      # when 'virtual_machine'
      #   virtual_machine
      # when '--version', '-v'
      #   require 'squall/version'
      #   puts "Squall v#{Squall::VERSION} by Site5 LLC"
      #   exit(0)
      # else

      #   if %w[-h --help].include?(@command) || @command.nil?
      #     msg = "HELP"
      #   else
      #     msg = "Error: Invalid command #{@command}\\nHELP"
      #   end
      #   @parser.banner = msg
      #   puts @parser.to_s
      #   exit(-1)
      # end

      # puts @argv
      @parser.parse!(@argv)
      # puts @parser.to_s
    end

    def virtual_machine
      case @subcommand
      when 'create'
        print_help_if_argv_empty

        @parser.separator "\nRequired parameters:\n"
        @parser.on('--template-id ID', 'Template ID', Integer) do |id|

        end

        @parser.separator "\nOptional parameters:\n"
      else
        print_help_if_argv_empty
      end
    end

    def print_help_if_argv_empty
      @argv << '--help' if @argv.empty?
    end
  end
end

require 'squall/cli/commands/virtual_machine'
