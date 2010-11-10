module Squall
  class Client

    attr_reader :successful, :response

    def initialize
      @default_options = {:accept => :json, :content_type => 'application/json'}
      # RestClient.log = STDERR
    end

    def get(uri)
      parse RestClient.get("#{uri_with_auth}/#{uri}.json", @default_options)
    end

    def post(uri, params = {})
      RestClient.post("#{uri_with_auth}/#{uri}.json", params.to_json, @default_options)
    end

    def put(uri, params = {})
      parse RestClient.put("#{uri_with_auth}/#{uri}.json", params.to_json, @default_options)
    end

    def delete(uri)
      parse RestClient.delete("#{uri_with_auth}/#{uri}.json", @default_options)
    end

    private

    def uri_with_auth
      uri = Squall.api_endpoint
      protocol = uri.port == 443 ? 'https' : 'http'
      "#{protocol}://#{Squall.api_user}:#{Squall.api_password}@#{uri.host}#{uri.path}"
    end

    def parse(result, code = 200)
      @response = (result.strip.empty? ? result : JSON.parse(result))
      @successful = (code == result.code)
    end

    def required_options!(required, actual)
      required = required.keys
      actual = actual.keys
      missing_keys = required - [actual].flatten 
      raise(ArgumentError, "Missing key(s): #{missing_keys.join(", ")}") unless missing_keys.empty?
    end

    def valid_options!(accepted, actual)
      unknown_keys = actual.keys - accepted
      raise(ArgumentError, "Unknown key(s): #{unknown_keys.join(", ")}") unless unknown_keys.empty?
    end
  end
end
