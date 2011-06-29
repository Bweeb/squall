module Squall
  class CLI::Group
    attr_reader :commands

    def initialize(name)
      @name     = name
      @commands = []
    end

    def driver(driver = nil)
      @driver = driver || @driver
    end

    def help(help = nil)
      @help = help || @help
    end

    def command(name, &block)
      command = CLI::Command.new(name)
      command.instance_eval(&block) if block_given?
      @commands << [name, command]
      command
    end

    def run_command(cmd, argv = [])
      if commands.assoc(cmd)
        driver.send(cmd, argv)
      end
    end
  end
end
