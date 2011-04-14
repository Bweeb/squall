module Squall
  class Base
    attr_reader :params, :success
    include HTTParty

    def initialize
      self.class.base_uri Squall::config[:base_uri]
      self.class.basic_auth Squall::config[:username], Squall::config[:password]
      self.class.format :json
      self.class.headers 'Content-Type' => 'application/json'
      # debug_output
    end

    def params
      @params ||= Params.new
    end

    def errors
      err = {}
      @result.each do |k,v|
        err[k] ||= []
        err[k].push v.first
      end
      err
    end

    def request(request_method, path, options = {})
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
  end
end