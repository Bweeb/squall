module Squall
  # Config missing
  class NoConfig < StandardError;end
end

module OnApp
  # HTTP 404 not found
  class NotFoundError < StandardError;end

  # HTTP 500 error
  class ServerError < StandardError;end

  # HTTP 422
  class ClientError < StandardError;end
end