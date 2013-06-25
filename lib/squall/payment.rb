module Squall
  # OnApp Payment
  class Payment < Base
    # Public: Lists all payments.
    #
    # Returns an Array.
    def list(user_id)
      response = request(:get, "/users/#{user_id}/payments.json")
      response.collect { |user| user['payment'] }
    end

    # Public: Create a payment for a user.
    #
    # user_id - ID of the user
    # options - Params for creating the User:
    #           :amount         - Amount of the payment
    #           :invoice_number - Number of the invoice
    #
    # Example
    #
    #     create amount: 500, invoice_number: "01234"
    #
    # Returns a Hash.
    def create(user_id, options = {})
      request(:post, "/users/#{user_id}/payments.json", default_params(options))
    end

    # Public: Edit a payment
    #
    # user_id - ID of the user
    # id      - ID of the payment
    # options - Params for editing the payment, see `#create`
    #
    # Returns a Hash.
    def edit(user_id, id, options = {})
      request(:put, "/users/#{user_id}/payments/#{id}.json", default_params(options))
    end

    # Public: Delete a payment
    #
    # user_id - ID of the user
    # id      - ID of the payment
    #
    # Returns a Hash.
    def delete(user_id, id)
      request(:delete, "/users/#{user_id}/payments/#{id}.json")
    end
  end
end
