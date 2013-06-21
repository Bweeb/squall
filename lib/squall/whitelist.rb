module Squall
  # OnApp Whitelist
  class Whitelist < Base
    # Public: Lists all whitelists.
    #
    # user_id - ID of the user to display whitelists for
    #
    # Returns an Array.
    def list(user_id)
      response = request(:get, "/users/#{user_id}/user_white_lists.json")
      response.collect { |user| user['user_white_list'] }
    end

    # Public: Get the details for a whitelist.
    #
    # user_id - ID of the user
    # id      - ID of the whitelist
    #
    # Returns a Hash.
    def show(user_id, id)
      response = request(:get, "/users/#{user_id}/user_white_lists/#{id}.json")
      response['user_white_list']
    end

    # Public: Create a whitelist for a user.
    #
    # user_id - ID of the user
    # options - Params for creating the whitelist:
    #           :ip          - IP to be whitelisted
    #           :description - Description of the whitelist
    #
    # Example
    #
    #     create ip:          192.168.1.1,
    #            description: "Computer that someone I trust uses"
    #
    # Returns a Hash.
    def create(user_id, options = {})
      request(:post, "/users/#{user_id}/user_white_lists.json", query: { user_white_list: options })
    end

    # Public: Edit a whitelist.
    #
    # user_id - ID of the user
    # id      - ID of whitelist
    # options - Params for editing the whitelist, see `#create`
    #
    # Returns a Hash.
    def edit(user_id, id, options = {})
      request(:put, "/users/#{user_id}/user_white_lists/#{id}.json", query: { user_white_list: options })
    end

    # Public: Delete a whitelist.
    #
    # user_id - ID of the user
    # id      - ID of whitelist
    #
    # Returns a Hash.
    def delete(user_id, id)
      request(:delete, "/users/#{user_id}/user_white_lists/#{id}.json")
    end
  end
end
