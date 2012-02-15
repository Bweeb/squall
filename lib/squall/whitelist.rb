module Squall
  # OnApp Whitelist
  class Whitelist < Base

    # Return a list of all whitelists
    #
    # ==== Params
    #
    # * +user_id*+ - ID of the user to display whitelists for
    def list(user_id)
      response = request(:get, "/users/#{user_id}/user_white_lists.json")
      response.collect { |user| user['user_white_list'] }
    end

    # Get the details for a whitelist
    #
    # ==== Params
    #
    # * +user_id*+ - ID of the user
    # * +id*+ - ID of the whitelist
    def show(user_id, id)
      response = request(:get, "/users/#{user_id}/user_white_lists/#{id}.json")
      response['user_white_list']
    end

    # Create a whitelist for a user
    #
    # ==== Params
    #
    # * +user_id*+ - ID of the user
    # * +options+ - Params for creating the whitelist
    #
    # ==== Options
    #
    # * +ip*+ - IP to be whitelisted
    # * +description+ - Description of the whitelist
    #
    # ==== Example
    #
    #   create :ip          => 192.168.1.1,
    #          :description => "Computer that someone I trust uses"
    def create(user_id, options={})
      params.required(:ip).accepts(:description).validate!(options)
      request(:post, "/users/#{user_id}/user_white_lists.json", :query => {:user_white_list => options})
    end

    # Edit a whitelist
    #
    # ==== Params
    #
    # * +user_id*+ - ID of the user
    # * +id*+ - ID of whitelist
    # * +options+ - Params for editing the whitelist
    #
    # ==== Options
    #
    # See #create
    def edit(user_id, id, options={})
      params.accepts(:ip, :description).validate!(options)
      request(:put, "/users/#{user_id}/user_white_lists/#{id}.json", :query => {:user_white_list => options})
    end

    # Delete a whitelist
    #
    # ==== Params
    #
    # * +user_id*+ - ID of the user
    # * +id*+ - ID of whitelist
    def delete(user_id, id)
      request(:delete, "/users/#{user_id}/user_white_lists/#{id}.json")
    end

  end
end
