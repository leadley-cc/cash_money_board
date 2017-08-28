require "sinatra"
require "sinatra/contrib/all"
require_relative "../models/merchant"

get '/merchants' do
  @merchants = Merchant.all
  erb(:merchant_index)
end

get '/merchants/:id' do
  @merchant = Merchant.find(params[:id])
  erb(:merchant_show)
end
