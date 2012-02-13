module Squall
  # OnApp UserGroup
  class UserGroup < Base

    # Return a list of all user groups
    def list
      response = request(:get, "/user_groups.json")
      response.collect { |user_group| user_group['user_group'] }
    end
    
    # Create a user group
    #
    # ==== Options
    #
    # * +options+ - Params for creating the user groups
    #
    # ==== Example
    #
    #   create :label => "My new user group"
    def create(options={})
      params.required(:label).validate!(options)
      request(:post, "/user_groups.json", default_params(options))
    end
    
    # Edit a user group
    #
    # ==== Options
    # 
    # * +options+ - Params for editing the user group.
    def edit(id, options={})
      params.accepts(:label).validate!(options)
      request(:put, "/user_groups/#{id}.json", default_params(options))
    end
    
    # Delete a user group
    def delete(id)
      request(:delete, "/user_groups/#{id}.json")
    end

  end
end
