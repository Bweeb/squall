module Squall
  # OnApp Role
  class Role < Base
    # Return a list of Roles
    def list
      response = request(:get, '/roles.json')
      response.collect { |role| role['role']}
    end

    # Returns a Hash of the given Role
    def show(id)
      response = request(:get, "/roles/#{id}.json")
      response["role"]
    end

    # Edit a Role
    #
    # ==== Options
    #
    # * +options+ - Params for editing the Role
    # ==== Example
    #
    #   edit 1, :label => 'myrole', :permission_ids => [1,3]
    def edit(id, options = {})
      params.accepts(:label, :permission_ids).validate!(options)
      response = request(:put, "/roles/#{id}.json", default_params(options))
    end

    # Delete a Role
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
    # ==== Options
    #
    # * +options+ - Params for creating the Role
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
