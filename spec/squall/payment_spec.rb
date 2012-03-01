require 'spec_helper'

describe Squall::Payment do
  before(:each) do
    @keys = ["amount", "invoice_number"]
    @payment = Squall::Payment.new
    @valid = {:amount => 500}
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
  
  describe "#create" do
    use_vcr_cassette "payment/create"
    it "requires amount" do
      invalid = @valid.reject{|k,v| k == :amount }
      requires_attr(:amount) { @payment.create(1, invalid) }
    end
    
    it "allows all optional params" do
      optional = [:invoice_number]
      @payment.should_receive(:request).exactly(optional.size).times.and_return Hash.new("payment" => {})
      optional.each do |param|
        @payment.create(1, @valid.merge(param => "test"))
      end
    end
    
    it "raises error on unknown params" do
      expect { @payment.create(1, @valid.merge(:what => 'what')) }.to raise_error(ArgumentError, 'Unknown params: what')
    end
    
    it "raises an error for an invalid user id" do
      expect { @payment.create(404, @valid) }.to raise_error(Faraday::Error::ResourceNotFound)
    end

    it "creates a payment for a user" do
      user = @payment.create(1, @valid)
      @payment.success.should be_true
    end
  end
  
  describe "#edit" do
    use_vcr_cassette "payment/edit"
    
    it "allows select params" do
      optional = [:amount, :invoice_number]
      @payment.should_receive(:request).exactly(optional.size).times.and_return Hash.new()
      optional.each do |param|
        @payment.edit(1, 1, param => "test")
      end
    end
    
    it "raises error on unknown params" do
      expect { @payment.edit(1, 1, :what => 'what') }.to raise_error(ArgumentError, 'Unknown params: what')
    end

    it "edits a payment" do
      user = @payment.edit(1, 1, :amount => 100)
      @payment.success.should be_true
    end
    
    it "raises an error for an invalid payment id" do
      expect { @payment.edit(1, 404, @valid) }.to raise_error(Faraday::Error::ResourceNotFound)
    end
  end
  
  describe "#delete" do
    use_vcr_cassette "payment/delete"
    it "requires an id" do
      expect { @payment.delete }.to raise_error(ArgumentError)
    end

    it "deletes a payment" do
      @payment.delete(1, 1)
      @payment.success.should be_true
    end

    it "returns NotFound for missing user" do
      expect { @payment.delete(1, 404) }.to raise_error(Faraday::Error::ResourceNotFound)
    end
  end

end