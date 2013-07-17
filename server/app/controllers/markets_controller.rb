class MarketsController < Rack::API

	get 'markets/:id' do
		Market.find(params[:id])
	end

	post 'markets' do
		Market.create(params[:market])
	end

	put 'markets/:id' do
		market = Market.find(params[:id])
		market.update_attributes(params[:market])
	end
end