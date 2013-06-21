module Squall
  # OnApp Transaction
  class Transaction < Base
    # Public: Lists all transactions.
    #
    # Returns an Array.
    def list
      response = request :get, '/transactions.json'
      response.collect { |t| t['transaction'] }
    end

    # Public: Get info for the given transaction.
    #
    # id - ID of transaction
    #
    # Returns a Hash.
    def show(id)
      response = request :get, "/transactions/#{id}.json"
      response['transaction']
    end
  end
end
