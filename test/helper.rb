require 'test/unit'
require 'mongodoc'

class User < MongoDoc
  attribute :name, String
end

class MongoDoc::TestCase < Test::Unit::TestCase
end
