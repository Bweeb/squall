module Squall
  class User < Base
    def list
      response = request(:get, '/users.json')
      response.collect { |user| user['user']}
    end
    
    def create(options = {})
      params.required(:login, :email, :password).validate!(options)
      request(:post, '/users.json', {:query => {:user => options}})
    end

    def show(id)
      response = request(:get, "/users/#{id}.json")
      response.first[1]
    end
  end
end