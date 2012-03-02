module Squall
  # Config missing
  class NoConfig < StandardError;end
  
  # HTTP 404 not found
  class NotFoundError < StandardError;end

  # HTTP 422
  class ClientError < StandardError;end
  
  # HTTP 500 error
  class ServerError < StandardError;end
end