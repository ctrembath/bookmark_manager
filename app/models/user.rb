require 'bcrypt'
require 'rest-client'
require 'mailgun'

class User

  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation

  property :id, Serial
  property :email, String, :unique => true, :message => "This email is already taken"
  property :password_digest, Text
  property :password_token, Text
  property :password_token_timestamp, Time


  validates_confirmation_of :password
  # validates_uniqueness_of :email
  MAILGUN_API = ENV['MAILGUN_API']
  BOOKMARK_URL = ENV['BOOKMARK_URL']


  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = first(:email => email)
    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
  end

  # def send_message(email, token)
  #   RestClient.post "https://api:key-1a15cf6167de1edd52ebcecc5ae6fce0",
  #   "@api.mailgun.net/v2/v2/app31831016.mailgun.org",
  #   :from => "Mailgun Sandbox <postmaster@sandbox688a59fc15ff4cd0ac6f9c4e95d70c39.mailgun.org>",
  #   :to => email,
  #   :subject => "Mailgun test",
  #   :text => "Please follow this link to change your password, the link is only available for one hour: #{BOOKMARK_URL}/users/change_password/#{token}."
  # end

end