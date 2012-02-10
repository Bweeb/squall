module Squall
  # OnApp User
  class User < Base
    # Return a list of all users
    def list
      response = request(:get, '/users.json')
      response.collect { |user| user['user'] }
    end


    # Create a new User
    #
    # ==== Options
    #
    # * +options+ - Params for creating the User
    #
    # ==== Example
    #
    #   create :login                 => 'bob',
    #          :email                 => 'something@example.com',
    #          :password              => 'secret',
    #          :password_confirmation => 'secret'
    #          :first_name            => 'Bob',
    #          :last_name             => 'Smith'
    def create(options = {})
      params.required(:login, :email,:first_name, :last_name, :password, :password_confirmation).accepts(:role, :time_zone, :locale, :status, :billing_plan_id, :role_ids, :suspend_after_hours, :suspend_at).validate!(options)
      request(:post, '/users.json', default_params(options))
    end
    
    # Edit a user
    #
    # ==== Options
    # 
    # * +options+ - Params for editing the User.  Note that OnApp only honors select attributes for editing: email, password (and password_confirmation), first_name, last_name, user_group_id, billing_plan_id, role_ids, suspend_at
    def edit(id, options={})
      params.accepts(:email, :password, :password_confirmation, :first_name, :last_name, :user_group_id, :billing_plan_id, :role_ids, :suspend_at).validate!(options)
      request(:put, "/users/#{id}.json", default_params(options))
    end

    # Return a Hash of the given User
    def show(id)
      response = request(:get, "/users/#{id}.json")
      response["user"]
    end

    # Create a new API Key for a User
    def generate_api_key(id)
      request(:post, "/users/#{id}/make_new_api_key.json")
    end

    # Suspend a User
    def suspend(id)
      response = request(:get, "/users/#{id}/suspend.json")
      response.first[1]
    end

    # Activate a user
    def activate(id)
      response = request(:get, "/users/#{id}/activate_user.json")
      response.first[1]
    end
    alias_method :unsuspend, :activate

    # Delete a user
    def delete(id)
      response = request(:delete, "/users/#{id}.json")
      success
    end

    # Get the stats for a User
    def stats(id)
      response = request(:get, "/users/#{id}/vm_stats.json")
      response.first['vm_stats']
    end

    # Return a list of VirtualMachines for a User
    def virtual_machines(id)
      response = request(:get, "/users/#{id}/virtual_machines.json")
      response.collect { |vm| vm['virtual_machine']}
    end

  end
end
