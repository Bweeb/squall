require 'spec_helper'

describe Squall::Base do
  before(:each) do
    default_config
  end

  describe "#initialize" do
    it "sets the base_uri" do
      base = Squall::Base.new
      base.class.base_uri.should == 'http://www.example.com'
    end

    it "sets credentials" do
      base = Squall::Base.new
      base.class.default_options[:basic_auth].should include(:username => 'user', :password => 'pass')
    end

    it "uses JSON" do
      base = Squall::Base.new
      base.class.default_options[:format].should == :json
    end

    it "sets JSON headers" do
      base = Squall::Base.new
      base.class.default_options[:headers].should include('Content-Type' => 'application/json')
    end
  end

  describe "#request" do
    it "raises NotFound for 404s" do
      mock_request(:get, '/404', :status => [404, "NotFound"])
      base = Squall::Base.new
      expect { base.request(:get, '/404') }.to raise_error(Squall::NotFound)
    end

    it "raises RequestError on errors" do
      mock_request(:get, '/500', :status => [500, "Internal Server Error"])
      base = Squall::Base.new
      expect { base.request(:get, '/500') }.to raise_error(Squall::RequestError)
    end
  end

  describe "#params" do
    it "returns Params.new" do
      base = Squall::Base.new
      base.params.should be_a(Params)
    end
  end
end