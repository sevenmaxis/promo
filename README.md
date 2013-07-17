# Promo

## Installation

### Intalling MongoDB

		sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
		echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/10gen.list
		sudo apt-get update
		sudo apt-get install mongodb-10gen

### Installing gem

		git clone https://github.com/sevenmaxis/promo.git
		cd promo
		gem install --local gem/promo-0.0.1.gem
		irb # run pry or irb
		require 'promo'  # should be true
		Promo::Optin.setup("http://localhost:9292/")

### Running promo server
		
		rackup server/config.ru

### Playing with promo

		email = 'test53@test.com'
		mobile = '+380555555555'
		first_name = "John"
		last_name = "Michael"
		permission_type = 'one-time'
		channel = "sms"
		company_name = "melkisoft"

		optin = Promo::Optin.create(email, mobile, first_name, last_name, permission_type, channel, company_name) 
		optin.status # should be 'success'

		optin.update(:first_name => "Kennedy")
		optin.first_name # should "Kennedy"

## Usage

Promo

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
