module Squall
  class Client

    def initialize
      @default_options = {:accept => :json}
      RestClient.log = STDERR
    end

    def get(uri)
      parse(RestClient.get("#{uri_with_auth}/#{uri}.json", @default_options))
    end

    def post(uri, params = {})
      parse(RestClient.post("#{uri_with_auth}/#{uri}.json", params.to_json, @default_options))
    end

    def put(uri, params = {})
      parse(RestClient.put("#{uri_with_auth}/#{uri}.json", params.to_json, @default_options))
    end

    def delete(uri)
      RestClient.delete("#{uri_with_auth}/#{uri}.json", @default_options) {  |response, request, result, &block|
        handle_response(response)
      }
    end

    private

    def parse(content)
      JSON.parse(content)
    end

    def handle_response(response)
      case response.code
      when 200
        return true
      when 404
        return false
      else
        raise "An unknown error occurred #{response.code}: #{result}"
      end
    end

    def uri_with_auth
      uri = Squall.api_endpoint
      protocol = uri.port == 443 ? 'https' : 'http'
      "#{protocol}://#{Squall.api_user}:#{Squall.api_password}@#{uri.host}#{uri.path}"
    end

    def required_options!(required, actual)
      required = required.keys
      actual = actual.keys
      missing_keys = required - [actual].flatten 
      raise(ArgumentError, "Missing key(s): #{missing_keys.join(", ")}") unless missing_keys.empty?
    end

    def valid_options!(accepted, actual)
      accepted = required.keys
      actual = actual.keys
      unknown_keys = actual - accepted
      raise(ArgumentError, "Unknown key(s): #{unknown_keys.join(", ")}") unless unknown_keys.empty?
    end
  end
end
