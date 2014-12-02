require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require './app/helpers/application'
require 'rest_client'
require 'mailgun'

require_relative 'models/link'
require_relative 'models/tag'
require_relative 'models/user'
require_relative 'data_mapper_setup'

require_relative 'controllers/users'
require_relative 'controllers/sessions'
require_relative 'controllers/links'
require_relative 'controllers/tags'
require_relative 'controllers/application'
require_relative 'controllers/password_reset'


env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

enable :sessions
set :session_secret, 'super secret'
use Rack::Flash
use Rack::MethodOverride
set :views, Proc.new { File.join(root, '..', 'app/views') }







