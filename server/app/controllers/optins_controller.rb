class OptinsController < Rack::API

	get 'markets/:id' do
		optin = Optin.where(:email => params["email"]).first
		if optin 
			optin 
		else 
			self.instance_variable_set(:@status, 404)
			message = "optin with given #{params["email"]} email is not found"
			message.tap { |x| puts x }
		end
	end

	post 'markets' do
		optin = Optin.create(params[:params])
		if optin.valid? 
			self.instance_variable_set(:@status, 200)
			optin 
		else
			self.instance_variable_set(:@status, 422)
			optin.errors.first.join(' ').tap { |x| puts x }
		end
	end

	put 'markets/:id' do
		optin = Optin.where(:email => params["email"]).first
		if optin
			params['params'].each do |method, value| 
				optin.send("#{method}=", value)
			end
			if optin.valid?
				optin
			else
				self.instance_variable_set(:@status, 422)
				optin.errors.first.join(' ').tap { |x| puts x }
			end
		else
			self.instance_variable_set(:@status, 404)
			message = "optin with given #{params["email"]} email is not found"
			message.tap { |x| puts x }
		end
	end
end