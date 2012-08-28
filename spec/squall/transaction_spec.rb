require 'spec_helper'

describe Squall::Transaction do
  before(:each) do
    @transaction = Squall::Transaction.new
    @keys = ["pid", "created_at", "updated_at", "actor", "priority",
      "parent_type", "action", "id", "user_id", "dependent_transaction_id",
      "allowed_cancel", "parent_id", "params", "log_output", "status", "identifier"
    ]
  end

  describe "#list" do
    use_vcr_cassette 'transaction/list'

    it "lists transactions" do
      list = @transaction.list
      list.size.should be(3)

      first = list.first
      first.keys.should include(*@keys)
    end
  end

  describe "#show" do
    use_vcr_cassette "transaction/show"

    it "returns a transaction" do
      transaction = @transaction.show(1)
      transaction.keys.should include(*@keys)

      transaction['pid'].should == 2180
    end
  end

end
