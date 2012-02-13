require 'spec_helper'

describe Squall::Params do
  before(:each) do 
    @params = Squall::Params.new
  end

  describe "#new" do
    it "sets @valid to {}" do
      @params.valid.should be_empty
    end

    it "sets @optional to {}" do
      @params.optional.should be_empty
    end
  end

  describe "#required" do
    it "stores keys in @valid with an Array" do
      params = [:one, :two]
      @params.required params
      @params.valid.size.should == 2
      @params.valid.should include(:one, :two)
    end

    it "stores uniq keys only" do
      @params.required :one, :one
      @params.valid.size.should == 1
      @params.valid.should include(:one)
    end

    it "adds @valid to @optional" do
      params = [:one, :two]
      @params.required params
      @params.valid.size.should == 2
      @params.optional.size.should == 2

      @params.valid.should include(:one, :two)
      @params.optional.should include(:one, :two)
    end

    it "returns self" do
      @params.required([:one, :two]).should be_a(Squall::Params)
    end

    it "resets @valid" do
      params = [:one, :two]
      @params.required params
      @params.valid.size.should == 2
      @params.valid.should include(:one, :two)

      params = [:three, :four]
      @params.required params
      @params.valid.size.should == 2
      @params.valid.should include(:three, :four)
    end
  end

  describe "#accepts" do
    it "stores keys in @optional with an Array" do
      params = [:one, :two]
      @params.accepts params
      @params.optional.size.should == 2
      @params.optional.should include(:one, :two)
    end

    it "stores uniq keys only" do
      @params.accepts :one, :one
      @params.optional.size.should == 1
      @params.optional.should include(:one)
    end

    it "doesn't reset @valid" do
      @params.required(:two)
      @params.accepts(:one)

      @params.optional.uniq.size.should be(2)
      @params.optional.uniq.should include(:one, :two)
    end


    it "returns self" do
      @params.accepts([:one, :two]).should be_a(Squall::Params)
    end

    it "resets @optional" do
      params = [:one, :two]
      @params.accepts params
      @params.optional.size.should == 2
      @params.optional.should include(:one, :two)

      params = [:three, :four]
      @params.accepts params
      @params.optional.size.should == 4
      @params.optional.should include(:three, :four)
    end
  end

  describe "#validate_required!" do
    describe "Array param input" do
      it "raises an error with missing options" do
        params = [:one, :two]
        @params.required params
        expect { @params.validate_required!(:three) }.to raise_error(ArgumentError)
      end

      it "does not raise an error with valid" do
        params = [:one, :two]
        @params.required params
        @params.validate_required!(:one, :two)
      end

      it "does not raise an error when empty" do
        @params.required []
        @params.validate_required! :whatever
      end
    end

    describe "Hash param input" do
      it "raises an error with missing options" do
        params = [:one, :two]
        @params.required params
        expect { @params.validate_required!({:three => 'three'}) }.to raise_error(ArgumentError)
      end

      it "does not raise an error with valid" do
        params = [:one, :two]
        @params.required params
        @params.validate_required!(:one => 1, :two => 2)
      end
    end

    describe "String param input" do
      it "raises an error with missing options" do
        params = [:one, :two]
        @params.required params
        expect { @params.validate_required!({'three' => 'three'}) }.to raise_error(ArgumentError)
      end

      it "does not raise an error with valid" do
        params = [:one, :two]
        @params.required params
        @params.validate_required!('one' => 1, 'two' => 2)
      end
    end

    describe "Chained execution" do
      it "raises an error with missing options" do
        params = [:one, :two]
        expect { @params.required(params).validate_required!({'three' => 'three'}) }.to raise_error(ArgumentError)
      end

      it "does not raise an error with valid" do
        params = [:one, :two]
        @params.required(params).validate_required!('one' => 1, 'two' => 2)
      end
    end
  end

  describe "#validate_optionals!" do
    it "raises an error with unknown params" do
      @params.accepts :one, :two
      expect { @params.validate_optionals!({:three => 3}) }.to raise_error(ArgumentError)
    end

    it "allows a known param" do
      @params.accepts :one
      @params.validate_optionals!({:one => 1}).should be_true
    end

    it "allows multiple known param" do
      @params.accepts :one, :two
      @params.validate_optionals!({:one => 1, :two => 2}).should be_true
    end

    it "allows 2 of 3 known param" do
      @params.accepts :one, :two, :three
      @params.validate_optionals!({:one => 1, :two => 2}).should be_true
    end
  end

  describe "#validate!" do
    it "calls #validate_required!" do
      @params.valid = [:one, :two]
      @params.should_receive(:validate_required!).with(:one, :two)
      @params.validate!(:one, :two) 
    end

    it "calls #validate_optionals!" do
      @params.optional = [:one, :two]
      @params.should_receive(:validate_optionals!).with(:one, :two)
      @params.validate!(:one, :two) 
    end
  end
end
