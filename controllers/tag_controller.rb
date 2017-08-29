require "sinatra"
require "sinatra/contrib/all"
require_relative "../models/tag"

get '/tags' do
  @tags = Tag.all
  @tags.sort_by! {|tag| tag.id} if @tags
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
  redirect to "/tags/#{params["id"]}/edit"
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
