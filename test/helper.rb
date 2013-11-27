require 'test/unit'
require 'mongodoc'

class User < MongoDoc
  attribute :name, String
end

$mongo = Mongo::MongoClient.new
MongoDoc.connection = $mongo
MongoDoc.database_name = "mongodoc_test"

class MongoDoc::TestCase < Test::Unit::TestCase
  def setup
    MongoDoc.database.collections.each do |coll|
      next if coll.name.include?("system")
      coll.remove({})
    end
  end
end
