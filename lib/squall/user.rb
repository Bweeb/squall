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
    # ==== Params
    #
    # * +options+ - Params for creating the User
    #
    # ==== Options
    #
    # * +login*+ - Login name
    # * +email*+ - Email address
    # * +first_name*+ - First name
    # * +last_name*+ - Last name
    # * +password*+ - Password
    # * +passwor_confirmation*+ - Password
    # * +role+ - Role to be assigned to user
    # * +time_zone+ - Time zone for user.  If not provided it will be set automatically.
    # * +locale+ - Locale for user.  If not provided it will be set automatically.
    # * +status+ - User's status: +active+, +suspended+, +deleted+
    # * +billing_plan_id+ - ID of billing plan to be applied to user's account
    # * +role_ids+ - Array of IDs of roles to be assigned to the user
    # * +suspend_after_hours+ - Number of hours after which the account will be automatically suspended
    # * +suspend_at+ - Time after which the account will automatically be suspended, formatted as +YYYYMMDD ThhmmssZ+
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
    # ==== Params
    #
    # * +id*+ - ID of user
    # * +options+ - Params for creating the user
    #
    # ==== Options
    #
    # See #create
    def edit(id, options={})
      params.accepts(:email, :password, :password_confirmation, :first_name, :last_name, :user_group_id, :billing_plan_id, :role_ids, :suspend_at).validate!(options)
      request(:put, "/users/#{id}.json", default_params(options))
    end

    # Return a Hash of the given user
    #
    # ==== Params
    #
    # * +id*+ - ID of user
    def show(id)
      response = request(:get, "/users/#{id}.json")
      response["user"]
    end

    # Create a new API Key for a user
    #
    # ==== Params
    #
    # * +id*+ - ID of user
    def generate_api_key(id)
      response = request(:post, "/users/#{id}/make_new_api_key.json")
      response["user"]
    end

    # Suspend a user
    #
    # ==== Params
    #
    # * +id*+ - ID of user
    def suspend(id)
      response = request(:get, "/users/#{id}/suspend.json")
      response["user"]
    end

    # Activate a user
    #
    # ==== Params
    #
    # * +id*+ - ID of user
    def activate(id)
      response = request(:get, "/users/#{id}/activate_user.json")
      response["user"]
    end
    alias_method :unsuspend, :activate

    # Delete a user
    #
    # ==== Params
    #
    # * +id*+ - ID of user
    #
    # Note: this does not delete remove a user from the database.  First, their status will be set to "Deleted."  If you call this method again, the user will be completely removed.
    def delete(id)
      request(:delete, "/users/#{id}.json")
    end

    # Get the stats for each of a User's VirtualMachines
    #
    # ==== Params
    #
    # * +id*+ - ID of user
    def stats(id)
      request(:get, "/users/#{id}/vm_stats.json")
    end

    # Get a list of bills for the User
    #
    # ==== Params
    #
    # * +id*+ - ID of user
    def monthly_bills(id)
      response = request(:get, "/users/#{id}/monthly_bills.json")
    end

    # Return a list of VirtualMachines for a User
    #
    # ==== Params
    #
    # * +id*+ - ID of user
    def virtual_machines(id)
      response = request(:get, "/users/#{id}/virtual_machines.json")
      response.collect { |vm| vm['virtual_machine']}
    end

    # Return a list of Hypervisors for a User's VirtualMachines
    #
    # ==== Params
    #
    # * +id*+ - ID of user
    def hypervisors(id)
      response = request(:get, "/users/#{id}/hypervisors.json")
      response.collect { |vm| vm['hypervisor']}
    end

    # Return a list of data store zones associated with user
    #
    # ==== Params
    #
    # * +id*+ - ID of user
    def data_store_zones(id)
      response = request(:get, "/users/#{id}/data_store_zones.json")
      response.collect { |vm| vm['data-store-group']}
    end

    # Return a list of network zones associated with user
    #
    # ==== Params
    #
    # * +id*+ - ID of user
    def network_zones(id)
      response = request(:get, "/users/#{id}/network_zones.json")
      response.collect { |vm| vm['network_group']}
    end

    # Return a description of resources available to a user for creating a virtual machine
    #
    # ==== Params
    #
    # * +id*+ - ID of user
    def limits(id)
      response = request(:get, "/users/#{id}/limits.json")
      response["limits"]
    end

  end
end
