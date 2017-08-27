require "sinatra"
require "sinatra/contrib/all"
require_relative "../models/user"

get '/users' do
  @users = User.all
  erb(:user_index)
end

get '/users/:id' do
  @user = User.find(params["id"])
  erb(:user_show)
end
