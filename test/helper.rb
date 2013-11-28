require 'test/unit'
require 'minidoc'

class User < Minidoc
  attribute :name, String
end

$mongo = Mongo::MongoClient.new
Minidoc.connection = $mongo
Minidoc.database_name = "minidoc_test"

class Minidoc::TestCase < Test::Unit::TestCase
  def setup
    Minidoc.database.collections.each do |coll|
      next if coll.name.include?("system")
      coll.remove({})
    end
  end
end
