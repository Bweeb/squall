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
    it "200-207 returns success" do
      (200..207).each do |i|
        mock_request(:get, "/#{i}", :status => [i, "OK"])
        base = Squall::Base.new
        base.request(:get, "/#{i}")
        base.success.should be_true
      end
    end

    it "raises NotFound for 404s" do
      mock_request(:get, '/404', :status => [404, "NotFound"])
      base = Squall::Base.new
      expect { base.request(:get, '/404') }.to raise_error(Squall::NotFound)
      base.success.should be_false
    end

    it "raises ServerError on errors" do
      mock_request(:get, '/500', :status => [500, "Internal Server Error"])
      base = Squall::Base.new
      expect { base.request(:get, '/500') }.to raise_error(Squall::ServerError)
      base.success.should be_false
    end

    it "raises RequestError on errors" do
      mock_request(:get, '/422', :status => [422, "Unprocessable"])
      base = Squall::Base.new
      expect { base.request(:get, '/422') }.to raise_error(Squall::RequestError)
      base.success.should be_false
    end
  end

  describe "#errors" do
    it "is empty on success" do
      mock_request(:get, '/200_errors', :status => [200, "OK"], :body => '"{\"something\":[\"OK\"]}"')
      base = Squall::Base.new
      base.request(:get, '/200_errors')
      base.errors.should be_empty
    end

    it "returns an error hash" do
      mock_request(:get, '/500_errors', :status => [500, "Internal Server Error"], :body => '"{\"something\":[\"errors\"]}"')
      base = Squall::Base.new
      expect { base.request(:get, '/500_errors') }.to raise_error(Squall::ServerError)
      base.errors.should_not be_empty
    end
  end

  describe "#params" do
    it "returns Params.new" do
      base = Squall::Base.new
      base.params.should be_a(Params)
    end
  end
end