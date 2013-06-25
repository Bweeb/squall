module Squall
  # Holds the configuration for Squall
  class Config
    # Public: A Hash that stores configuration info.
    attr_accessor :config

    def initialize
      @config = {}
    end

    # Public: Hash accessor, delegates to `@config`.
    #
    # Returns the value from `@config`.
    def [](v)
      @config[v]
    end

    # Public: Sets the URL of your OnApp instance.
    #
    # value - The String URL
    #
    # Returns value.
    def base_uri(value)
      @config[:base_uri] = value
    end

    # Public: Sets the API username.
    #
    # value - The String username
    #
    # Returns value.
    def username(value)
      @config[:username] = value
    end

    # Public: Sets the API Password>
    #
    # value - The String password
    #
    # Returns value.
    def password(value)
      @config[:password] = value
    end

    # Public: Set to true to enable HTTP logging.
    #
    # value - A Boolean
    #
    # Returns value.
    def debug(value)
      @config[:debug] = value
    end
  end
end
