# require 'data_mapper'
# This class corresponds to a table in the database
# We can use it to manipulate the data
require_relative 'tag'
class Link

    # this makes the instances of this class datamapper resources
    include DataMapper::Resource

    has n, :tags, :through => Resource
    # This block describes what resources our model will have
    property :id, Serial # Serial means that it will be auto-incredmented for every record
    property :title, String
    property :url, String

end