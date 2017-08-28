require "sinatra"
require "sinatra/contrib/all"
require_relative "../models/user"
require_relative "../models/transaction"

get '/users/:user_id/transactions' do
  @transactions = Transaction.select("user_id", params[:user_id])
  erb(:transaction_index)
end

get '/transactions/:id' do
  @transaction = Transaction.find(params[:id])
  erb(:transaction_show)
end
