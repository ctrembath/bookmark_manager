require 'sinatra/base'
require 'data_mapper'


class Bookmark_manager < Sinatra::Base

  env = ENV["RACK_ENV"] ||  "development"

  # we're telling datamapper to use postgres database on localhost. The name will be "bookmark_manager"
  DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

  require './lib/link' # this needs to be done after datamapper is initialised

  # After declaring your models you should finalise them
  DataMapper.finalize

  # However, the database tables don't exist yet. Let's tell datamapper to create them
  DataMapper.auto_upgrade!
  
 get '/' do
    'Hello bookmark_manager!'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0

  
end