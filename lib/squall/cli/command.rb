module Squall
  class CLI::Command

    attr_reader :required_params
    attr_reader :optional_params

    def initialize(name)
      @name            = name
      @required_params = []
      @optional_params = []
      @options         = {}
    end

    def description(desc = nil)
      @description = desc if desc
      @description
    end

    def build_parser(option_parser)
      if @required_params.size > 0
        option_parser.separator "\nRequired parameters:\n"
        @required_params.each do |p|
          p[:type] = String unless p[:type]
          option_parser.on(p[:flag], p[:label], p[:type], p[:proc])
        end
      end
    end
  end
end
