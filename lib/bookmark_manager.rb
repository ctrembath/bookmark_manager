require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require './app/helpers/application'
require './models/link'
require './models/tag'
require './models/user'
require_relative '../app/data_mapper_setup'


enable :sessions
set :session_secret, 'super secret'
use Rack::Flash
# env = ENV["RACK_ENV"] ||  "development"
set :views, Proc.new { File.join(root, '..', 'app/views') }

  # # However, the database tables don't exist yet. Let's tell datamapper to create them
  # DataMapper.auto_migrate!

 

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
    user = User.authenticate(email.password)
    if user 
      session[:user_id] = user.id
      redirect to('/')
    else
      flash[:errors] = ["The email or password is incorrect"]
      erb :"sessions/new"
    end
end




