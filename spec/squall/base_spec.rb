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

	describe "#params" do
		it "returns Params.new" do
			base = Squall::Base.new
			base.params.should be_a(Params)
		end
	end
end