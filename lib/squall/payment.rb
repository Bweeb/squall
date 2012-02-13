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
    # ==== Options
    #
    # * +options+ - Params for creating the User
    #
    # ==== Example
    #
    #   create :amount                 => 500,
    #          :invoice_number         => "01234",
    def create(user_id, options={})
      params.required(:amount).accepts(:invoice_number).validate!(options)
      request(:post, "/users/#{user_id}/payments.json", default_params(options))
    end

  end
end
