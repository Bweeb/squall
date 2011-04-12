require 'spec_helper'

describe Squall::User do
	before(:each) do
		default_config
		@user = Squall::User.new
	end

	describe "#create" do
		it "requires login" do
			# requires_attr(:login) { @user.create }
		end 
	end
end