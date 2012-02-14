module Squall
  # OnApp Role
  class Role < Base
    # Return a list of roles
    def list
      response = request(:get, '/roles.json')
      response.collect { |role| role['role']}
    end

    # Returns a Hash of the given roles
    #
    # ==== Params
    # 
    # * +id*+ - ID of the role
    def show(id)
      response = request(:get, "/roles/#{id}.json")
      response["role"]
    end

    # Edit a Role
    #
    # ==== Params
    # 
    # * +id*+ - ID of the role
    # * +options+ - Params for editing the roles
    #
    # ==== Options
    #
    # See #create
    #
    # ==== Example
    #
    #   edit 1, :label => 'myrole', :permission_ids => [1,3]
    def edit(id, options = {})
      params.accepts(:label, :permission_ids).validate!(options)
      response = request(:put, "/roles/#{id}.json", default_params(options))
    end

    # Delete a Role
    #
    # ==== Params
    # 
    # * +id*+ - ID of the role
    def delete(id)
      request(:delete, "/roles/#{id}.json")
    end

    # Returns a list of permissions available
    def permissions
      response = request(:get, '/permissions.json')
      response.collect { |perm| perm['permission'] }
    end

    # Create a new Role
    #
    # ==== Params
    #
    # * +options+ - Params for creating the roles
    #
    # ==== Options
    #
    # * +label*+ - Label for the role
    # * +permission_ids+ - An array of permission ids granted to the role.
    #
    # ==== Example
    #
    #   create :label => 'Admin'
    def create(options = {})
      params.required(:label).accepts(:permission_ids).validate!(options)
      response = request(:post, '/roles.json', default_params(options))
    end
  end
end
