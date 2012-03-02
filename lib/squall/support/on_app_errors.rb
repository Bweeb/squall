module Faraday
  class Response::OnAppErrors < Response::Middleware

    def on_complete(env)
      # https://help.onapp.com/manual.php?m=2#p29
      case env[:status]
      when 403
        raise OnApp::ForbiddenError, response_values(env)
      when 404
        raise OnApp::NotFoundError, response_values(env)
      when 422
        raise OnApp::ClientError, response_values(env)
      when 500
        raise OnApp::ServerError, response_values(env)
      end
    end

    def response_values(env)
      {:status => env[:status], :headers => env[:response_headers], :body => env[:body]}
    end

  end
end