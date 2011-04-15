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

    def edit(id, options = {})
      # params.required(:label, :permission).validate!(options)
      response = request(:put, "/roles/#{id}.json", default_params(options))
    end

    def delete(id)
      request(:delete, "/roles/#{id}.json")
    end
  end
end
