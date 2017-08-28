require "sinatra"
require "sinatra/contrib/all"
require_relative "../models/tag"

get '/tags' do
  @tags = Tag.all
  erb(:tag_index)
end

get '/tags/:id' do
  @tag = Tag.find(params[:id])
  erb(:tag_show)
end
