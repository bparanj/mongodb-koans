
require 'mongo'
require_relative 'edgecase'

class AboutDBConnect < EdgeCase::Koan
  include Mongo
  
  def setup
    @mongo = Connection.new
    @db = @mongo.db('hack0318')
  end
  
  def teardown
    @db.collections.each do |collection|
      @db.drop_collection(collection.name) unless collection.name =~ /indexes$/
    end
  end
  
  def test_connection
    assert_not_nil @mongo, "MongoDB is not connected"
    assert_instance_of Mongo::Connection, @mongo
  end
  
  def test_database_exist
    assert @db, "DB not available"
    assert_instance_of Mongo::DB, @db
  end

end