module Squall
  class Transaction < Base
    def list
      response = request :get, '/transactions.json'
      response.collect { |t| t['transaction'] }
    end

    def show(id)
      response = request :get, "/transactions/#{id}.json"
      response['transaction']
    end
  end
end
