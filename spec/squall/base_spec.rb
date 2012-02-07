require 'spec_helper'

class CamelTest < Squall::Base;end;
class Nocamel < Squall::Base;end;
module Subclass
  class Test < Squall::Base;end;
  class CamelTest < Squall::Base;end;
end

describe Squall::Base do
  before(:each) do
    default_config
    @base = Squall::Base.new
  end

  describe "#initialize" do
    it "sets the base_uri" do
      @base.class.base_uri.should == 'http://www.example.com'
    end

    it "sets credentials" do
      @base.class.default_options[:basic_auth].should include(:username => 'user', :password => 'pass')
    end

    it "uses JSON" do
      @base.class.default_options[:format].should == :json
    end

    it "sets JSON headers" do
      @base.class.default_options[:headers].should include('Content-Type' => 'application/json')
    end
  end

  describe "#request" do
    it "200-207 returns success" do
      (200..207).each do |i|
        mock_request(:get, "/#{i}", :status => [i, "OK"], :body => "{\"something\":[\"OK\"]}")
        base = Squall::Base.new
        base.request(:get, "/#{i}")
        base.success.should be_true
      end
    end

    it "raises NotFound for 404s" do
      mock_request(:get, '/404', :status => [404, "NotFound"])
      expect { @base.request(:get, '/404') }.to raise_error(Squall::NotFound)
      @base.success.should be_false
    end

    it "raises ServerError on errors" do
      mock_request(:get, '/500', :status => [500, "Internal Server Error"])
      expect { @base.request(:get, '/500') }.to raise_error(Squall::ServerError)
      @base.success.should be_false
    end

    it "raises RequestError on errors" do
      mock_request(:get, '/422', :status => [422, "Unprocessable"])
      expect { @base.request(:get, '/422') }.to raise_error(Squall::RequestError)
      @base.success.should be_false
    end

    it "is a sad panda when the config hasn't been specified" do
      Squall.reset_config
      expect { @base.request(:get, '/money') }.to raise_error(Squall::NoConfig, "Squall.config must be specified")
    end
  end

  describe "#errors" do
    it "is empty on success" do
      mock_request(:get, '/200_errors', :status => [200, "OK"], :body => "{\"something\":[\"errors\"]}")
      @base.request(:get, '/200_errors')
      @base.errors.should be_empty
    end

    it "returns an error hash" do
      mock_request(:get, '/500_errors', :status => [500, "Internal Server Error"], :body => "{\"something\":[\"errors\"]}")
      expect { @base.request(:get, '/500_errors') }.to raise_error(Squall::ServerError)
      @base.errors.should_not be_empty
    end
  end

  describe "#params" do
    it "returns Params.new" do
      @base.params.should be_a(Squall::Params)
    end
  end

  describe "#default_params" do
    it "sets the default options" do
      @base.default_params.should == {}
    end

    it "merges the query in" do
      expected = {
        :query => { 
          :base => {:one => 1, :two => 2}
        }
      }
      @base.default_params(:one => 1, :two => 2).should include(expected)
    end

    it "uses the subclass name as the key" do
      base_test = CamelTest.new
      base_test.default_params.should == {}
      expected = {
        :query => { 
          :camel_test => {:one => 1, :two => 2}
        }
      }
      base_test.default_params(:one => 1, :two => 2).should include(expected)
    end
  end

  describe "#key_for_class" do
    it "converts CamelTest to :camel_test" do
      camel_test = CamelTest.new
      camel_test.key_for_class.should == :camel_test
    end

    it "converts Nocamel to :nocamel" do
      nocamel = Nocamel.new
      nocamel.key_for_class.should == :nocamel
    end

    it "converts Subclass::Test to :test" do
      sub_class = Subclass::Test.new
      sub_class.key_for_class.should == :test
    end 

    it "converts Subclass::CamelTest to :camel_test" do
      camel_test = Subclass::CamelTest.new
      camel_test.key_for_class.should == :camel_test
    end 
  end
end
