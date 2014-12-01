require 'bcrypt'
require 'rest-client'

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

  def send_message
    RestClient.post "https://api:key-4b349f00da30f09770c893a4eb961287",
    "@api.postmaster@sandbox688a59fc15ff4cd0ac6f9c4e95d70c39.mailgun.org/messages>",
    :from => "Mailgun Sandboz <postmaster@sandbox688a59fc15ff4cd0ac6f9c4e95d70c39.mailgun.org>",
    :to => "Clare Trembath <claretrembath@ymail.com>",
    :text => "Hello #{self.email}. Please follow this link to change your password, the link is only available for one hour: #{BOOKMARK_URL}/users/change_password/#{self.password_token}."
  end

end