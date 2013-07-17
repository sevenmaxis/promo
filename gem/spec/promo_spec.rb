require 'spec_helper'
require 'webmock/rspec'
require 'json'

describe Promo do

	before :each do
		Promo::Optin.setup("http://localhost:9292/")
	end

	let(:email) { 'test@test.com' }
	let(:mobile) { '+380555555555' }
	let(:first_name) { "John" }
	let(:last_name) { "Michael" }
	let(:permission_type) { 'one-time' }
	let(:channel) { "sms" }
	let(:company_name) { "melkisoft" }

	describe "#get" do
		it "gets optin" do
			response = {
        email: email, mobile: mobile, first_name: first_name, last_name: last_name, 
        permission_type: permission_type, channel: channel, company_name: company_name 
      }.to_json
			
			stub_request(:get, "http://localhost:9292/markets/1?email=test@test.com")
				.to_return(:body => response, :status => 200)

			optin = Promo::Optin.get(email)
			optin.status.should == 'success'
			optin.email.should == email
			optin.mobile.should == mobile
			optin.first_name.should == first_name
			optin.last_name.should == last_name
			optin.permission_type.should == permission_type
			optin.channel.should == channel
			optin.company_name.should == company_name
		end
	end

	describe "#create" do
		let(:url) { "http://localhost:9292/markets" }

		it "creates optin" do
			email = 'second@test.com'
			
			request = { params: {
				email: email, mobile: mobile, first_name: first_name, 
				last_name: last_name, permission_type: permission_type, channel: channel, 
				company_name: company_name
			}}

      stub_request(:post, url)
      	.with(:body => request)
				.to_return(:body => request[:params].to_json, :status => 201)

			optin = Promo::Optin.create(email, mobile, first_name, last_name, permission_type, channel, company_name) 
			
			optin.status.should == 'success'
			optin.email.should == email
			optin.mobile.should == mobile
			optin.first_name.should == first_name
			optin.last_name.should == last_name
			optin.permission_type.should == permission_type
			optin.channel.should == channel
			optin.company_name.should == company_name
		end

		it "doesn't create optin" do
			email = 'not valid email'
			
			request = { params: {
				email: email, mobile: mobile, first_name: first_name, 
				last_name: last_name, permission_type: permission_type, channel: channel, 
				company_name: company_name
			}}
			
			stub_request(:post, "http://localhost:9292/markets")
      	.with(:body => request)
				.to_return(:body => "email is not valid", :status => 422)

			optin = Promo::Optin.create(email, mobile, first_name, last_name, permission_type, channel, company_name)
			
			optin.status.should == 'error'
			optin.message.should match(/email is not valid/)
		end
	end

	describe "#update" do
		let(:url) { "http://localhost:9292/markets/1" }
		let(:url_email) { "http://localhost:9292/markets/1?email=test@test.com" }
		
		it "updates optin" do
			email = 'test@test.com'

			response = {
        email: email, mobile: mobile, first_name: first_name, last_name: last_name, 
        permission_type: permission_type, channel: channel, company_name: company_name 
      }.to_json

			stub_request(:get, url_email)
				.to_return(:body => response, :status => 200)

			optin = Promo::Optin.get(email)

			company_name = "apple"

			optin.company_name.should_not == company_name

			stub_request(:put, url)
				.with(:body => {params: {email: email, params:{company_name: company_name}}})
				.to_return(:body => response, :status => 200)

			optin.update(:company_name => company_name)
			
			optin.status.should == 'success'
			optin.company_name.should == company_name
		end

		it "doesn't update optin" do
			email = 'test@test.com'

			response = {
        email: email, mobile: mobile, first_name: first_name, last_name: last_name, 
        permission_type: permission_type, channel: channel, company_name: company_name 
      }.to_json

      stub_request(:get, url_email)
				.to_return(:body => response, :status => 200)

			optin = Promo::Optin.get(email)

			company_name = ""

			optin.company_name.should_not == company_name

			stub_request(:put, url)
				.with(:body => {params: {email: email, params:{company_name: company_name}}})
				.to_return(:body => "company_name can't be blank", :status => 422)

			optin.update(:company_name => "")

			optin.status.should == 'error'
			optin.message.should match /can't be blank/
		end
	end
end