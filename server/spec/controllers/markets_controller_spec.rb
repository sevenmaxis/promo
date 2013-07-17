require 'spec_helper'

describe MarketsController do

	def app; MarketsController; end

	let(:valid_attributes) { {
			:email => "ben.fresh@gmail.com", 
    	:mobile => "+38077777777777", 
    	:first_name => "vasia", 
    	:last_name => "ivanov",
    	:permission_type => "one-time",
    	:channel => "email",
    	:company_name => "melkisoft"
  } }

	it "#get" do
		market = Market.create valid_attributes
		get "/markets/#{market.id}"
		last_response.status.should == 200
		result = JSON.parse last_response.body
		result['_id'].should match market.id
	end

	it "#post" do
		post "/markets", :market => valid_attributes
		last_response.status.should == 200
		Market.where(:email => valid_attributes[:email]).should be
	end

	it "#put" do
		market = Market.create valid_attributes
		put "/markets/#{market.id}", :market => {:permission_type => "permanent"}
		last_response.status.should == 200
		market = Market.find(market.id)
		market.permission_type.should == "permanent"
	end
end