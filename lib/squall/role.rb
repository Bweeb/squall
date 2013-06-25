module Squall
  # OnApp Role
  class Role < Base
    # Public: Lists all roles.
    #
    # Returns an Array.
    def list
      response = request(:get, '/roles.json')
      response.collect { |role| role['role']}
    end

    # Public: Show info for the given role.
    #
    # id - ID of the role
    #
    # Returns a Hash.
    def show(id)
      response = request(:get, "/roles/#{id}.json")
      response["role"]
    end

    # Public: Create a new Role
    #
    # options - Params for creating the roles:
    #           :label          - Label for the role
    #           :permission_ids - An array of permission ids granted to the role.
    #
    # Example
    #
    #     create label: 'Admin'
    def create(options = {})
      request(:post, '/roles.json', default_params(options))
    end

    # Public: Edit a Role.
    #
    # id      - ID of the role
    # options - Params for editing the roles, see `#create`
    #
    # Example
    #
    #     edit 1, label: 'myrole', permission_ids: [1, 3]
    #
    # Returns a Hash.
    def edit(id, options = {})
      request(:put, "/roles/#{id}.json", default_params(options))
    end

    # Public: Delete a Role.
    #
    # id - ID of the role
    #
    # Returns a Hash.
    def delete(id)
      request(:delete, "/roles/#{id}.json")
    end

    # Public: Lists all permissions available.
    #
    # Returns an Array.
    def permissions
      response = request(:get, '/permissions.json')
      response.collect { |perm| perm['permission'] }
    end
  end
end
