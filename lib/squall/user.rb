module Squall
  class User < Base
    def list
      response = self.class.get('/users.json')
      response.collect { |user| user['user']}
    end
    
    def create(options = {})
      params.required(:login, :email, :password).validate!(options)
      self.class.post('/users.json', {:query => {:user => options}})
    end

    def show(id)
      response = self.class.get("/users/#{id}.json")
      raise NotFound if response.code == 404
      response.first[1]
    end
  end
end