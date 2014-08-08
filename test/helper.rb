require 'minidoc'
require 'minitest/autorun'

class User < Minidoc
  attribute :name, String
end

$mongo = Mongo::MongoClient.new
Minidoc.connection = $mongo
Minidoc.database_name = "minidoc_test"

class Minidoc::TestCase < Minitest::Test
  def setup
    Minidoc.database.collections.each do |coll|
      next if coll.name.include?("system")
      coll.remove({})
      coll.drop_indexes
    end
  end
end
