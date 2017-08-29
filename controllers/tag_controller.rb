require "sinatra"
require "sinatra/contrib/all"
require_relative "../models/tag"

get '/tags' do
  @tags = Tag.all
  erb(:tag_index)
end

get '/tags/new' do
  erb(:tag_new)
end

get '/tags/:id/edit' do
  @tag = Tag.find(params["id"])
  erb(:tag_edit)
end

get '/tags/:id' do
  @tag = Tag.find(params[:id])
  erb(:tag_show)
end

post '/tags' do
  Tag.new(params).save
  redirect to "/tags"
end

post '/tags/:id' do
  Tag.new(params).save
  redirect to "/tags"
end

post '/tags/:id/delete' do
  tag = Tag.find(params["id"])
  tag.delete
  redirect to "/tags"
end
