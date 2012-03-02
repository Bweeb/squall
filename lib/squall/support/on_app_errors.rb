module Faraday
  class Response::OnAppErrors < Response::Middleware

    def on_complete(env)
      # https://help.onapp.com/manual.php?m=2#p29
      case env[:status]
      when 403
        raise Squall::ForbiddenError, response_values(env)
      when 404
        raise Squall::NotFoundError, response_values(env)
      when 422
        raise Squall::ClientError, response_values(env)
      when 500
        raise Squall::ServerError, response_values(env)
      end
    end

    def response_values(env)
      {:status => env[:status], :headers => env[:response_headers], :body => env[:body]}
    end

  end
end