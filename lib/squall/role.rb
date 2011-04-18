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
      params.accepts(:label, :permission).validate!(options)
      response = request(:put, "/roles/#{id}.json", default_params(options))
    end

    def delete(id)
      request(:delete, "/roles/#{id}.json")
    end

    def permissions
      response = request(:get, '/permissions.json')
      response.collect { |perm| perm['permission'] }
    end

    def create(options = {})
      params.required(:label, :identifier).validate!(options)
      response = request(:post, '/roles.json', default_params(options))
      response.first[1]
    end
  end
end
