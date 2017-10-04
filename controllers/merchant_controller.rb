require "sinatra"
require_relative "../models/merchant"

get '/merchants/?' do
  @merchants = Merchant.all
  if params["tag"]
    @merchants.select! {|merchant| merchant.tag.id == params["tag"].to_i}
    @for_message = " for Tag \##{params["tag"]}"
  end
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
  @merchant = Merchant.find(params["id"])
  erb(:merchant_show)
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
