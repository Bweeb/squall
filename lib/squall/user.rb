module Squall
  class User < Base
    def list
      response = request(:get, '/users.json')
      response.collect { |user| user['user']}
    end
    
    def create(options = {})
      params.required(:login, :email, :password).validate!(options)
      request(:post, '/users.json', default_options(options))
    end

    def show(id)
      response = request(:get, "/users/#{id}.json")
      response.first[1]
    end

    def generate_api_key(id)
      request(:post, "/users/#{id}/make_new_api_key.json")
    end

    def default_options(*options)
      options.empty? ? {} : {:query => {:user => options.first}}
    end
  end
end