module Squall
  # Holds the configuration for Squall
  class Config
    attr_accessor :config

    def initialize
      @config = {}
    end

    def [](v)
      @config[v]
    end

    def base_uri(value)
      @config[:base_uri]  = value
    end

    def username(value)
      @config[:username] = value
    end

    def password(value)
      @config[:password] = value
    end
  end
end
