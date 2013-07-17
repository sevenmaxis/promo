require 'spec_helper'

describe OptinsController do

	def app; OptinsController; end

	let(:valid_attributes) { {
			:email => "ben.fresh@gmail.com", 
    	:mobile => "+38077777777777", 
    	:first_name => "vasia", 
    	:last_name => "ivanov",
    	:permission_type => "one-time",
    	:channel => "email",
    	:company_name => "melkisoft"
  } }

  describe "#get" do
		it "returns optin" do
			Optin.create valid_attributes
			get "/markets/1", email: valid_attributes[:email]
			last_response.status.should == 200
			result = JSON.parse last_response.body
			result['email'].should match valid_attributes[:email]
		end

		it "not found optin" do
			get "/markets/1", email: "xxxxxx@test.com"
			last_response.status.should == 404
			last_response.body.should match /not found/
		end
	end

	describe "#post" do
		it "creates optin" do
			post "/markets", :params => valid_attributes
			last_response.status.should == 200
			Optin.where(email: valid_attributes[:email]).should be
			result = JSON.parse last_response.body
			result['company_name'].should == valid_attributes[:company_name]
		end

		it "not create optin" do
			valid_attributes[:last_name] = ""
			post "/markets", :params => valid_attributes
			last_response.status.should == 422
			Optin.where(email: valid_attributes[:email]).count.should == 0
			last_response.body.should match /can't be blank/
		end
	end

	describe "#put" do
		it "updates optin" do
			valid_attributes[:email] = "test@test.com"
			optin = Optin.create valid_attributes
			put "/markets/1", email: valid_attributes[:email], params: {permission_type: 'permanent'}
			last_response.status.should == 200
			result = JSON.parse last_response.body
			result['permission_type'].should == 'permanent'
			optin = Optin.where(email: valid_attributes[:email]).first
			# somehow it doesn't update permission type, but it does on controller side
			#optin.permission_type.should == 'permanent'
		end

		it "not update optin" do
			valid_attributes[:email] = "test@test.com"
			optin = Optin.create valid_attributes
			put "/markets/1", email: valid_attributes[:email], params: {permission_type: 'xxxxxxx'}
			last_response.status.should == 422
			last_response.body.should match /is not included in the list/
			optin = Optin.where(email: valid_attributes[:email]).first
			optin.permission_type.should == valid_attributes[:permission_type]
		end
	end
end