module Squall
  class User < Base
    def list
      response = request(:get, '/users.json')
      response.collect { |user| user['user']}
    end

    def create(options = {})
      params.required(:login, :email, :password).accepts(:first_name, :last_name, :group_id).validate!(options)
      request(:post, '/users.json', default_params(options))
    end

    def show(id)
      response = request(:get, "/users/#{id}.json")
      response.first[1]
    end

    def generate_api_key(id)
      request(:post, "/users/#{id}/make_new_api_key.json")
    end

    def suspend(id)
      response = request(:get, "/users/#{id}/suspend.json")
      response.first[1]
    end

    def activate(id)
      response = request(:get, "/users/#{id}/activate_user.json")
      response.first[1]
    end
    alias_method :unsuspend, :activate

    def delete(id)
      response = request(:delete, "/users/#{id}.json")
      success
    end

    def stats(id)
      response = request(:get, "/users/#{id}/vm_stats.json")
      response.first['vm_stats']
    end

    def virtual_machines(id)
      response = request(:get, "/users/#{id}/virtual_machines.json")
      response.collect { |vm| vm['virtual_machine']}
    end

    def edit_role(id, *roles)
      request(:put, "/users/#{id}.json", default_params(:role_ids => roles))
    end
  end
end
