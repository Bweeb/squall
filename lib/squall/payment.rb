module Squall
  # OnApp Payment
  class Payment < Base

    # Return a list of all payments
    def list(user_id)
      response = request(:get, "/users/#{user_id}/payments.json")
      response.collect { |user| user['payment'] }
    end

  end
end
