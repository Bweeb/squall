require 'spec_helper'

describe Squall::Payment do
  before(:each) do
    @keys = ["amount", "invoice_number"]
    @payment = Squall::Payment.new
    @valid = {amount: 500}
  end

  describe "#list" do
    use_vcr_cassette "payment/list"

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

    it "allows all optional params" do
      optional = [:invoice_number]
      @payment.should_receive(:request).exactly(optional.size).times.and_return Hash.new("payment" => {})
      optional.each do |param|
        @payment.create(1, @valid.merge(param => "test"))
      end
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

    it "edits a payment" do
      user = @payment.edit(1, 1, amount: 100)
      @payment.success.should be_true
    end
  end

  describe "#delete" do
    use_vcr_cassette "payment/delete"

    it "deletes a payment" do
      @payment.delete(1, 1)
      @payment.success.should be_true
    end
  end
end