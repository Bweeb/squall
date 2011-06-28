require 'optparse'
module Squall
  class CLI
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

    def dispatch!
      case @command
      when 'virtual_machine'
        virtual_machine
      when '--version', '-v'
        require 'squall/version'
        puts "Squall v#{Squall::VERSION} by Site5 LLC"
        exit(0)
      else

        if %w[-h --help].include?(@command) || @command.nil?
          msg = help
        else
          msg = "Error: Invalid command #{@command}\n#{help}"
        end
        @parser.banner = msg
        puts @parser.to_s
        exit(-1)
      end

      @parser.parse!(@argv)
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
