require 'spec_helper'

describe Squall::Payment do
  before(:each) do
    @keys = []
    @payment = Squall::Payment.new
    @valid = {}
  end

  describe "#list" do
    use_vcr_cassette "payment/list"
    
    it "requires user id" do
      expect { @payment.list }.to raise_error(ArgumentError)
    end
    
    it "returns a user list" do
      payments = @payment.list(1)
      payments.should be_an(Array)
    end

    it "contains first payment's data" do
      payment = @payment.list(1).first
      payment.should be_a(Hash)
    end
  end

end