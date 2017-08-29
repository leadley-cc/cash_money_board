require "sinatra"
require "sinatra/contrib/all"
require_relative "../models/merchant"

get '/merchants/?' do
  @merchants = Merchant.all
  @merchants.sort_by! {|merchant| merchant.id} if @merchants
  erb(:merchant_index)
end

get '/merchants/new/?' do
  @tags = Tag.all
  erb(:merchant_new)
end

get '/merchants/:id/edit/?' do
  @merchant = Merchant.find(params["id"])
  @tags = Tag.all
  erb(:merchant_edit)
end

get '/merchants/:id/?' do
  redirect to "/merchants/#{params["id"]}/edit"
end

post '/merchants/?' do
  Merchant.new(params).save
  redirect to "/merchants"
end

post '/merchants/:id/?' do
  Merchant.new(params).save
  redirect to "/merchants"
end

post '/merchants/:id/delete/?' do
  merchant = Merchant.find(params["id"])
  merchant.delete
  redirect to "/merchants"
end
