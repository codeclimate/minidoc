require 'test/unit'
require 'mongodoc'

class User < MongoDoc
  attribute :name, String
end

$mongo = Mongo::MongoClient.new
MongoDoc.connection = $mongo
MongoDoc.database_name = "mongodoc_test"

class MongoDoc::TestCase < Test::Unit::TestCase
end
