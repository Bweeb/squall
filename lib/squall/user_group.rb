module Squall
  # OnApp UserGroup
  class UserGroup < Base
    # Public: List all user groups.
    #
    # Returns an Array.
    def list
      response = request(:get, "/user_groups.json")
      response.collect { |user_group| user_group['user_group'] }
    end

    # Public: Create a user group.
    #
    # options - Params for creating the user groups:
    #           :label - Label for the user group
    #
    # Example
    #
    #     create label: "My new user group"
    def create(options = {})
      request(:post, "/user_groups.json", default_params(options))
    end

    # Public: Edit a user group.
    #
    # id      - ID of the user group
    # options - Params for editing the user group, see `#create`
    #
    # Returns a Hash.
    def edit(id, options = {})
      request(:put, "/user_groups/#{id}.json", default_params(options))
    end

    # Public: Delete a user group.
    #
    # id - ID of the user group
    #
    # Returns a Hash.
    def delete(id)
      request(:delete, "/user_groups/#{id}.json")
    end
  end
end
