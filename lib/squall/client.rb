module Squall
  class Client

    attr_reader :successful, :request, :response, :result, :message

    def initialize
      @default_options = {:accept => :json, :content_type => 'application/json'}
      @debug = false
    end

    def get(uri)
      RestClient.get("#{uri_with_auth}/#{uri}.json", @default_options) { |_response, _request, _result|
        handle_response _response, _request, _result
      }
    end

    def post(uri, params = {})
      RestClient.post("#{uri_with_auth}/#{uri}.json", params.to_json, @default_options) { |_response, _request, _result| 
        handle_response _response, _request, _result
      }
    end

    def put(uri, params = {})
      RestClient.put("#{uri_with_auth}/#{uri}.json", params.to_json, @default_options) { |_response, _request, _result| 
        handle_response _response, _request, _result
      }
    end

    def delete(uri)
      RestClient.delete("#{uri_with_auth}/#{uri}.json", @default_options) { |_response, _request, _result|
        handle_response _response, _request, _result
      }
    end

    def toggle_debug
      if @debug
        @debug = false
        RestClient.log = nil
      else
        @debug = true
        RestClient.log = STDERR
      end
    end

    private

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

    def uri_with_auth
      uri = Squall.api_endpoint
      protocol = uri.port == 443 ? 'https' : 'http'
      "#{protocol}://#{Squall.api_user}:#{Squall.api_password}@#{uri.host}#{uri.path}"
    end

    def handle_response(_response, _request, _result)
      @request    = _request
      @result     = _result
      @response   = _response
      @successful = (200..207).include?(_response.code)

      case _response.code
      when 404
        @message = "404 Not Found" 
      when 403
        @message = "Action is not permitted for that account"
      when 422
        @message = "Request Failed: #{@response}"
      else
        @message = (_response.strip.empty? ? _response : JSON.parse(_response))
        _response.return!
      end
      @successful
    end
  end
end
