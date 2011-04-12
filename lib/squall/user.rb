module Squall
	class User < Base
		def list
			self.class.get('/users.json')
		end
		
		def create(options = {})
						# {user:{login:'theone', email:'theone@onapp.com',
# password_confirmation:'H7YgiU6B', first_name:'Joe', last_name:'Doe',
# password:'H7YgiU6B', group_id:10 }}

			self.class.post('/users.json', options)
		end
	end
end