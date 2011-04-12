module Squall
	class User < Base
		def list
			response = self.class.get('/users.json')
			response.collect { |user| user['user']}
		end
		
		def create(options = {})
			params.required(:login, :email, :password).validate!(options)
			self.class.post('/users.json', options)
		end
	end
end