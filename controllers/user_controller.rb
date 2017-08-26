require "sinatra"
require "sinatra/contrib/all"
require_relative "../models/user"

get '/users/:id' do
  @user = User.find(params["id"])
  erb(:user_index)
end
