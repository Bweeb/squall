module Squall
  class Role < Base
    def list
      response = request(:get, '/roles.json')
      response.collect { |role| role['role']}
    end

    def show(id)
      response = request(:get, "/roles/#{id}.json")
      response.first[1]
    end
  end
end