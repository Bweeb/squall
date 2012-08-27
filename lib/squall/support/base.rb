module Squall
  # All OnApp API classes subclass Base to get access to
  # HTTParty methods and other convenience methods
  class Base
    # Params instance
    attr_reader :params

    # Returns true/false for successful/unsuccessful requests
    attr_reader :success

    # HTTPart request result
    attr_reader :result

    # Returns a Params.new
    def params
      @params = Squall::Params.new
    end

    # Sets the default URL params for requests and merges +options+
    #
    # ==== Options
    #
    # * +options+
    #
    # ==== Example
    #
    #   default_params(:something => 1)
    def default_params(*options)
      options.empty? ? {} : {:query => { key_for_class => options.first}}
    end

    # Peforms an HTTP Request
    #
    # ==== Options
    # * +request_method+ - The HTTP verb for the #request. (:get/:post/:delete etc)
    # * +path+ - URL path
    # * +options+ - HTTP query params
    #
    # ==== Example
    #
    #   request :get, '/something.json' # GET /seomthing.json
    #   request :put, '/something.json', :something => 1 # PUT /something.json?something=1
    def request(request_method, path, options = {})
      check_config

      conn = Faraday.new(:url => Squall.config[:base_uri]) do |c|
        c.basic_auth Squall.config[:username], Squall.config[:password]
        c.params = (options[:query] || {})
        c.request :url_encoded
        c.response :json
        c.adapter :net_http
        if Squall.config[:debug]
         c.use Faraday::Response::Logger
        end
      end

      response = conn.send(request_method, path)

      @success = (200..207).include?(response.env[:status])
      @result  = response.body
    end

    # Raises an error if a request is made without first calling Squall.config
    def check_config
      raise NoConfig, "Squall.config must be specified" if Squall.config.empty?
    end

    # Sets the default param container for request. It is derived from the
    # class name. Given the class name *Sandwich* and a param *bread* the
    # resulting params would be 'bob[bread]=wheat'
    def key_for_class
      word = self.class.name.split("::").last.to_s.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word.to_sym
    end
  end
end
