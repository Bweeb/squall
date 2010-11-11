module Squall
  class Client

    attr_reader :successful, :request, :response, :result

    def initialize
      @default_options = {:accept => :json, :content_type => 'application/json'}
      # RestClient.log = STDERR
    end

    def get(uri)
      RestClient.get("#{uri_with_auth}/#{uri}.json", @default_options) { |_response, _request, _result|
        setup_attributes _response, _request, _result
      }
    end

    def post(uri, params = {})
      RestClient.post("#{uri_with_auth}/#{uri}.json", params.to_json, @default_options) { |_response, _request, _result| 
        setup_attributes _response, _request, _result
      }
    end

    def put(uri, params = {})
      RestClient.put("#{uri_with_auth}/#{uri}.json", params.to_json, @default_options) { |_response, _request, _result| 
        setup_attributes _response, _request, _result
      }
    end

    def delete(uri)
      RestClient.delete("#{uri_with_auth}/#{uri}.json", @default_options) { |_response, _request, _result|
        setup_attributes _response, _request, _result
      }
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

    def setup_attributes(_response, _request, _result)
      @request  = _request
      @result   = _result
      @response = parse(_response)
    end

    def valid_options!(accepted, actual)
      unknown_keys = actual.keys - accepted
      raise(ArgumentError, "Unknown key(s): #{unknown_keys.join(", ")}") unless unknown_keys.empty?
    end
  end
end
