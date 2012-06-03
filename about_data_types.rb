require 'mongo'
require 'date'

require_relative 'edgecase'

class AboutDataTypes < EdgeCase::Koan
  include Mongo
  
  def setup
    @mongo = Connection.new
    @db = @mongo.db('hack0318')
    @col = @db["stuff"]
    @col.remove
  end
  
  def teardown
    @db.collections.each do |collection|
      @db.drop_collection(collection.name) unless collection.name =~ /indexes$/
    end
  end
  
  def test_int
    @col.insert({:value => 123})
    assert_instance_of Fixnum, @col.find_one['value']
  end
  def test_float
    @col.insert({:value => 123.4})
    assert_instance_of Float, @col.find_one['value']
  end
  def test_string
    @col.insert({:value => 'abc'})
    assert_instance_of String, @col.find_one['value']
  end
  def test_time
    @col.insert({:value => Time.new})
    assert_instance_of Time, @col.find_one['value']
  end
  def test_date
    assert_raises(BSON::InvalidDocument)  { @col.insert({:value => Date.new}) }
  end 
  def test_datetime
    assert_raises(BSON::InvalidDocument)  { @col.insert({:value => DateTime.new}) }
  end 
  def test_boolean_false
    @col.insert({:value => false})
    assert_instance_of FalseClass, @col.find_one['value']
  end
  def test_boolean_true
    @col.insert({:value => true})
    assert_instance_of TrueClass, @col.find_one['value']
  end
  def test_nil
    @col.insert({:value => nil})
    assert_instance_of NilClass, @col.find_one['value']
  end
  def test_not_attribute
    @col.insert({:value => true})
    assert_instance_of NilClass, @col.find_one['xyz']
  end
  def test_array
    @col.insert({:value => [1,2]})
    assert_instance_of Array, @col.find_one['value']
  end
  def test_id
    @col.insert({:value => 123})
    assert_instance_of BSON::ObjectId, @col.find_one['_id']
  end
  def test_regex
    @col.insert({:value => /^123$/i})
    assert_instance_of Regexp, @col.find_one['value']
    assert_equal "(?i-mx:^123$)", @col.find_one['value'].to_s
  end

  def test_the_rest
    assert "MongoDB also has data types binary, cstr, code, object"
  end
end
