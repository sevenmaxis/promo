class OptinsController < Rack::API

	get 'markets/:id' do
		optin = Optin.where(:email => params["email"]).first
		if optin 
			optin 
		else 
			self.instance_variable_set(:@status, 404)
			"optin with given #{params["email"]} email is not found"
		end
	end

	post 'markets' do
		optin = Optin.create(params[:params])
		if optin.valid? 
			optin 
		else
			self.instance_variable_set(:@status, 422)
			optin.errors.first.join(' ')
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
				optin.errors.first.join(' ')
			end
		else
			self.instance_variable_set(:@status, 404)
			"optin with given #{params["email"]} email is not found"
		end
	end
end