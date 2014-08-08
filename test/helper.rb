require 'minidoc'
require 'minitest/autorun'

I18n.enforce_available_locales = false
I18n.load_path << File.expand_path("../locale/en.yml", __FILE__)

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
