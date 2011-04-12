require 'spec_helper'

describe Params do
	before(:each) do 
		@params = Params.new
	end

	describe "#new" do
		it "sets @valid to {}" do
			@params.valid.should be_empty
		end
	end

	describe "#required" do
		it "stores keys in @valid with an Array" do
			params = [:one, :two]
			@params.required params
			@params.valid.size.should == 2
			@params.valid.should include(:one, :two)
		end

		it "returns self" do
			@params.required([:one, :two]).should be_a(Params)
		end
	end

	describe "#validate!" do
		describe "Array param input" do
			it "raises an error with missing options" do
				params = [:one, :two]
				@params.required params
				expect { @params.validate!(:three) }.to raise_error(ArgumentError)
			end

			it "does not raise an error with valid" do
				params = [:one, :two]
				@params.required params
				@params.validate!(:one, :two)
			end

			it "does not raise an error when empty" do
				@params.required []
				@params.validate! :whatever
			end
		end

		describe "Hash param input" do
			it "raises an error with missing options" do
				params = [:one, :two]
				@params.required params
				expect { @params.validate!({:three => 'three'}) }.to raise_error(ArgumentError)
			end

			it "does not raise an error with valid" do
				params = [:one, :two]
				@params.required params
				@params.validate!(:one => 1, :two => 2)
			end
		end

		describe "String param input" do
			it "raises an error with missing options" do
				params = [:one, :two]
				@params.required params
				expect { @params.validate!({'three' => 'three'}) }.to raise_error(ArgumentError)
			end

			it "does not raise an error with valid" do
				params = [:one, :two]
				@params.required params
				@params.validate!('one' => 1, 'two' => 2)
			end
		end

		describe "Chained execution" do
			it "raises an error with missing options" do
				params = [:one, :two]
				expect { @params.required(params).validate!({'three' => 'three'}) }.to raise_error(ArgumentError)
			end

			it "does not raise an error with valid" do
				params = [:one, :two]
				@params.required(params).validate!('one' => 1, 'two' => 2)
			end
		end
	end
end