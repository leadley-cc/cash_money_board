require "sinatra"
require "sinatra/contrib/all"
require_relative "controllers/user_controller"
require_relative "controllers/transaction_controller"
also_reload "models/*"

get '/' do
  erb(:index)
end
