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
      response = request(:post, "/users/#{id}/make_new_api_key.json")
      response["user"]
    end

    # Suspend a User
    def suspend(id)
      response = request(:get, "/users/#{id}/suspend.json")
      response["user"]
    end

    # Activate a user
    def activate(id)
      response = request(:get, "/users/#{id}/activate_user.json")
      response["user"]
    end
    alias_method :unsuspend, :activate

    # Delete a user
    #
    # Note: this does not delete remove a user from the database.  First, their status will be set to "Deleted."  If you call this method again, the user will be completely removed.
    def delete(id)
      request(:delete, "/users/#{id}.json")
    end

    # Get the stats for each of a User's VirtualMachines
    def stats(id)
      request(:get, "/users/#{id}/vm_stats.json")
    end

    # Return a list of VirtualMachines for a User
    def virtual_machines(id)
      response = request(:get, "/users/#{id}/virtual_machines.json")
      response.collect { |vm| vm['virtual_machine']}
    end
    
    # Return a list of Hypervisors for a User's VirtualMachines
    def hypervisors(id)
      response = request(:get, "/users/#{id}/hypervisors.json")
      response.collect { |vm| vm['hypervisor']}
    end

  end
end
