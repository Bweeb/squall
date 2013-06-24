require 'spec_helper'

class CamelTest < Squall::Base;end;
class Nocamel < Squall::Base;end;
module Subclass
  class Test < Squall::Base;end;
  class CamelTest < Squall::Base;end;
end

describe Squall::Base do
  before(:each) do
    @base = Squall::Base.new
  end

  describe "#request" do
    it "200-207 returns success" do
      (200..207).each do |i|
        mock_request(:get, "/#{i}", status: [i, "OK"], body: "{\"something\":[\"OK\"]}")
        base = Squall::Base.new
        base.request(:get, "/#{i}")
        base.success.should be_true
      end
    end

    it "raises NotFound for 404s" do
      mock_request(:get, '/404', status: [404, "NotFound"], body: "{\"errors\":[\"Resource not found\"]}")
      @base.request(:get, '/404')

      @base.success.should be_false
      @base.result.should == { "errors" => ["Resource not found"] }
    end

    it "raises ServerError on errors" do
      mock_request(:get, '/500', status: [500, "Internal Server Error"], body: "{\"errors\":[\"Internal Server Error\"]}")
      @base.request(:get, '/500')

      @base.success.should be_false
      @base.result.should == { "errors" => ["Internal Server Error"] }
    end

    it "raises RequestError on errors" do
      mock_request(:get, '/422', status: [422, "Unprocessable"], body: "{\"errors\":[\"Unprocessable\"]}")
      @base.request(:get, '/422')

      @base.success.should be_false
      @base.result.should == { "errors" => ["Unprocessable"] }
    end

    it "is a sad panda when the config hasn't been specified" do
      Squall.reset_config
      expect { @base.request(:get, '/money') }.to raise_error(Squall::NoConfig, "Squall.config must be specified")
    end
  end

  describe "#default_params" do
    it "sets the default options" do
      @base.default_params.should == {}
    end

    it "merges the query in" do
      expected = {
        query: {
          base: {one: 1, two: 2}
        }
      }
      @base.default_params(one: 1, two: 2).should include(expected)
    end

    it "uses the subclass name as the key" do
      base_test = CamelTest.new
      base_test.default_params.should == {}
      expected = {
        query: {
          camel_test: {one: 1, two: 2}
        }
      }
      base_test.default_params(one: 1, two: 2).should include(expected)
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
