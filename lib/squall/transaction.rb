module Squall
  # OnApp Transaction
  class Transaction < Base
    # Returns a list of all Transactions.
    def list
      response = request :get, '/transactions.json'
      response.collect { |t| t['transaction'] }
    end

    # Return a Hash for the given Transaction
    def show(id)
      response = request :get, "/transactions/#{id}.json"
      response['transaction']
    end
  end
end
