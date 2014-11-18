require 'sinatra'
require 'data_mapper'
require './models/link'
require './models/tag'
require './lib/user'
require './app/helpers/application'
# require_relative 'data_mapper_setup'


env = ENV["RACK_ENV"] ||  "development"
set :views, Proc.new { File.join(root, '..', 'app/views') }

enable :sessions
set :session_secret, 'super secret'

  # we're telling datamapper to use postgres database on localhost. The name will be "bookmark_manager"
  DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

  require './models/link' # this needs to be done after datamapper is initialised

  # After declaring your models you should finalise them
  DataMapper.finalize

  # However, the database tables don't exist yet. Let's tell datamapper to create them
  DataMapper.auto_upgrade!
  
  # start the server if ruby file executed directly
 

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
    #this will either find this tag or create
    #it if it doesn't exist already
    Link.create(:url => url, :title => title, :tags => tags)
    redirect to('/')
  end

  get '/tags/:text' do
    tag = Tag.first(:text => params[:text])
    @links = tag ? tag.links : []
    erb :index
  end

  get '/users/new' do
    erb :"users/new"
  end

  post '/users' do
    User.create(:email => params[:email],
                :password => params[:password])
    session[:user_id] = user.id
    redirect to('/')
  end



