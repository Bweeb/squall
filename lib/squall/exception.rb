module Squall
  # HTTP 404 not found
  class NotFound < StandardError;end

  # HTTP 500 error
  class RequestError < StandardError;end

  # HTTP 422
  class ServerError < StandardError;end

  # Config missing
  class NoConfig < StandardError;end
end
