require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require './app/helpers/application'
require './models/link'
require './models/tag'
require './models/user'
require_relative '../app/data_mapper_setup'

env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

enable :sessions
set :session_secret, 'super secret'
use Rack::Flash
use Rack::MethodOverride
set :views, Proc.new { File.join(root, '..', 'app/views') }


get '/' do
  @links = Link.all
  erb :index
end

post '/links' do
  url = params["url"]
  title = params["title"]
  tags = params["tags"].split(" ").map do |tag|
  Tag.first_or_create(:text => tag)
  end
  Link.create(:url => url, :title => title, :tags => tags)
  redirect to('/')
end

get '/tags/:text' do
  tag = Tag.first(:text => params[:text])
  @links = tag ? tag.links : []
  erb :index
end

get '/users/new' do
  @user = User.new
  erb :"users/new"
end

post '/users' do
  @user = User.new(:email => params[:email],
              :password => params[:password],
              :password_confirmation => params[:password_confirmation])
  if @user.save
    session[:user_id] = @user.id
    redirect to('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

get '/sessions/new' do
  erb :"sessions/new"
end

post '/sessions' do
  email, password = params[:email], params[:password]
  user = User.authenticate(email, password)
  if user 
    session[:user_id] = user.id
    redirect to('/')
  else
    flash[:errors] = ["The email or password is incorrect"]
    erb :"sessions/new"
  end
end

  delete '/sessions' do
    session.clear
    flash[:notice] = ["Good bye!"]
    redirect '/'
  end

  get '/users/reset_password' do
    erb :"users/reset_password"
  end

  post '/users/forgot_password' do
   user= User.first(email: params[:email])
   user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
   user.save
   'check your email'
  end

  get'/users/reset_password/:token' do
    @token = params[:token]
    user = User.first(password_token: @token)    
    erb :'users/new_password'
  end

  post "/users/reset_password" do
  
    user = User.first(password_token: params[:password_token])
    user.update(password: params[:password], password_confirmation: params[:password_confirmation])
    'password updated'    

  end





