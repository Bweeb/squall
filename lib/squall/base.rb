module Squall
  class Base
    attr_reader :params, :success
    include HTTParty

    def initialize
      self.class.base_uri Squall::config[:base_uri]
      self.class.basic_auth Squall::config[:username], Squall::config[:password]
      self.class.format :json
      self.class.headers 'Content-Type' => 'application/json'
      # self.class.debug_output
    end

    def params
      @params ||= Squall::Params.new
    end

    def default_params(*options)
      options.empty? ? {} : {:query => { key_for_class => options.first}}
    end

    def errors
      return [] if @success
      err = {}
      @result.each do |k,v|
        err[k] ||= []
        err[k].push v.respond_to?(:first) ? v.first : v
      end
      err
    end

    def request(request_method, path, options = {})
      check_config
      @result  = self.class.send(request_method, path, options)
      @success = (200..207).include?(@result.code)
      case @result.code
      when (200..207)
        @result
      when 404
        raise NotFound, @result
      when 422
        raise RequestError, @result
      else
        raise ServerError, @result
      end
    end

    def check_config
      raise NoConfig, "Squall.config must be specified" if Squall.config.empty?
    end

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
