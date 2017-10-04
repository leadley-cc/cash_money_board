require "sinatra"
require_relative "../models/transaction"

get '/transactions/?' do
  @transactions = Transaction.all
  @url_params ||= "?"
  ["user", "tag", "merchant"].each do |column|
    if params[column] then
      @for_message ||= " for #{column.capitalize} \##{params[column]}"
      @url_params << "#{column}=#{params[column]}&"
      @transactions.select! do |transaction|
        transaction.send(column).id == params[column].to_i
      end
    end
  end
  @url_params.chomp
  @transactions.sort_by! {|transaction| transaction.date_time} if @transactions
  erb(:transaction_index)
end

get '/transactions/user/?' do
  @users = User.all
  @users.sort_by! {|user| user.id} if @users
  erb(:transaction_user)
end

get '/transactions/user/:user_id/?' do
  @user = User.find(params[:user_id])
  @transactions = @user.transactions
  @filter_tag = params["tag_id"].to_i if params["tag_id"]
  if @transactions then
    if @filter_tag
      @transactions.select! {|transaction| transaction.tag.id == @filter_tag}
    end
    @transactions.sort_by! {|transaction| transaction.date_time}
  end
  erb(:transaction_index)
end

get '/transactions/new(/:user_id)?/?' do
  @users = User.all
  @merchants = Merchant.all
  @user_id = params[:user_id].to_i if params[:user_id]
  erb(:transaction_new)
end

get '/transactions/:id/edit/?' do
  @transaction = Transaction.find(params[:id])
  @users = User.all
  @merchants = Merchant.all
  erb(:transaction_edit)
end

get '/transactions/:id/?' do
  @transaction = Transaction.find(params[:id])
  erb(:transaction_show)
end

post '/transactions/?' do
  Transaction.new(params).save
  redirect to "/transactions/user/#{params["user_id"]}"
end

post '/transactions/:id/?' do
  Transaction.new(params).save
  redirect to "/transactions/user/#{params["user_id"]}"
end

post '/transactions/:id/delete/?' do
  transaction = Transaction.find(params["id"])
  transaction.delete
  redirect to "/transactions/user/#{transaction.user_id}"
end
