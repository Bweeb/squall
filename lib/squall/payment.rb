module Squall
  # OnApp Payment
  class Payment < Base

    # Return a list of all payments
    def list(user_id)
      response = request(:get, "/users/#{user_id}/payments.json")
      response.collect { |user| user['payment'] }
    end

    # Create a payment for a user
    #
    # ==== Params
    #
    # * +user_id*+ - ID of the user
    # * +options+ - Params for creating the User
    #
    # ==== Options
    #
    # * +amount*+ - Amount of the payment
    # * +invoice_number+ - Number of the invoice
    #
    # ==== Example
    #
    #   create :amount                 => 500,
    #          :invoice_number         => "01234",
    def create(user_id, options={})
      request(:post, "/users/#{user_id}/payments.json", default_params(options))
    end

    # Edit a payment
    #
    # ==== Params
    #
    # * +user_id*+ - ID of the user
    # * +id*+ - ID of the payment
    # * +options+ - Params for editing the payment
    #
    # ==== Options
    #
    # See #create
    def edit(user_id, id, options={})
      request(:put, "/users/#{user_id}/payments/#{id}.json", default_params(options))
    end

    # Delete a payment
    #
    # ==== Params
    #
    # * +user_id*+ - ID of the user
    # * +id*+ - ID of the payment
    def delete(user_id, id)
      request(:delete, "/users/#{user_id}/payments/#{id}.json")
    end
  end
end
