module Squall
  module CLI
    class Base
      def self.run(argv)
        argv << 'help' if argv.empty?

        command = argv.shift
        new(command, argv).run!
      end

    end
  end
end
