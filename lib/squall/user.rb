module Squall
  # OnApp User
  class User < Base
    # Public: Lists all users.
    #
    # Returns an Array.
    def list
      response = request(:get, '/users.json')
      response.collect { |user| user['user'] }
    end

    # Public: Create a new User
    #
    # options - Params for creating the User:
    #           :login                - Login name
    #           :email                - Email address
    #           :first_name           - First name
    #           :last_name            - Last name
    #           :password             - Password
    #           :passwor_confirmation - Password
    #           :role                 - Role to be assigned to user
    #           :time_zone            - Time zone for user. If not provided it
    #                                   will be set automatically.
    #           :locale               - Locale for user. If not provided it will
    #                                   be set automatically.
    #           :status               - User's status: `active`, `suspended`,
    #                                   `deleted`
    #           :billing_plan_id      - ID of billing plan to be applied to
    #                                   user's account
    #           :role_ids             - Array of IDs of roles to be assigned to
    #                                   the user
    #           :suspend_after_hours  - Number of hours after which the account
    #                                   will be automatically suspended
    #           :suspend_at           - Time after which the account will
    #                                   automatically be suspended, formatted
    #                                   as +YYYYMMDD ThhmmssZ+
    #
    # Example
    #
    #     create login:                 'bob',
    #            email:                 'something@example.com',
    #            password:              'secret',
    #            password_confirmation: 'secret'
    #            first_name:            'Bob',
    #            last_name:             'Smith'
    #
    # Returns a Hash.
    def create(options = {})
      request(:post, '/users.json', default_params(options))
    end

    # Public: Edit a user
    #
    # id      - ID of user
    # options - Params for creating the user, see `#create`
    #
    # Returns a Hash.
    def edit(id, options = {})
      request(:put, "/users/#{id}.json", default_params(options))
    end

    # Public: Get info for a user.
    #
    # id - ID of user
    #
    # Returns a Hash.
    def show(id)
      response = request(:get, "/users/#{id}.json")
      response["user"]
    end

    # Public: Create a new API Key for a user.
    #
    # id - ID of user
    #
    # Return a Hash.
    def generate_api_key(id)
      response = request(:post, "/users/#{id}/make_new_api_key.json")
      response["user"]
    end

    # Public: Suspend a user.
    #
    # id - ID of user
    #
    # Return a Hash.
    def suspend(id)
      response = request(:get, "/users/#{id}/suspend.json")
      response["user"]
    end

    # Public: Activate a user.
    #
    # id - ID of user
    #
    # Return a Hash.
    def activate(id)
      response = request(:get, "/users/#{id}/activate_user.json")
      response["user"]
    end
    alias_method :unsuspend, :activate

    # Public: Delete a user.
    #
    # id - ID of user
    #
    # Note: this does not delete remove a user from the database.  First,
    # their status will be set to "Deleted."  If you call this method again,
    # the user will be completely removed.
    #
    # Return a Hash.
    def delete(id)
      request(:delete, "/users/#{id}.json")
    end

    # Public: Get the stats for each of a User's VirtualMachines
    #
    # id - ID of user
    #
    # Return a Hash.
    def stats(id)
      request(:get, "/users/#{id}/vm_stats.json")
    end

    # Public: List a User's bills.
    #
    # id - ID of user
    #
    # Return a Hash.
    def monthly_bills(id)
      request(:get, "/users/#{id}/monthly_bills.json")
    end

    # Public: List User's VirtualMachines.
    #
    # id - ID of user
    #
    # Return a Hash.
    def virtual_machines(id)
      response = request(:get, "/users/#{id}/virtual_machines.json")
      response.collect { |vm| vm['virtual_machine']}
    end

    # Public: List Hypervisors for a User's VirtualMachines.
    #
    # id - ID of user
    #
    # Return a Hash.
    def hypervisors(id)
      response = request(:get, "/users/#{id}/hypervisors.json")
      response.collect { |vm| vm['hypervisor']}
    end

    # Public: List data store zones associated with user.
    #
    # id - ID of user
    #
    # Return a Hash.
    def data_store_zones(id)
      response = request(:get, "/users/#{id}/data_store_zones.json")
      response.collect { |vm| vm['data-store-group']}
    end

    # Public: List network zones associated with user.
    #
    # id - ID of user
    #
    # Return a Hash.
    def network_zones(id)
      response = request(:get, "/users/#{id}/network_zones.json")
      response.collect { |vm| vm['network_group']}
    end

    # Public: Show resources available to a user for creating a virtual machine.
    #
    # id - ID of user
    #
    # Returns a Hash.
    def limits(id)
      response = request(:get, "/users/#{id}/limits.json")
      response["limits"]
    end
  end
end
