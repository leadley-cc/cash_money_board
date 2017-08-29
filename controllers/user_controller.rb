require "sinatra"
require "sinatra/contrib/all"
require_relative "../models/user"

get '/users/?' do
  @users = User.all
  @users.sort_by! {|user| user.id} if @users
  erb(:user_index)
end

get '/users/new/?' do
  erb(:user_new)
end

get '/users/:id/edit/?' do
  @user = User.find(params["id"])
  erb(:user_edit)
end

get '/users/:id/?' do
  @user = User.find(params["id"])
  erb(:user_show)
end

post '/users/?' do
  User.new(params).save
  redirect to "/users"
end

post '/users/:id/?' do
  User.new(params).save
  redirect to "/users/#{params["id"]}"
end

post '/users/:id/delete/?' do
  user = User.find(params["id"])
  user.delete
  redirect to "/users"
end
