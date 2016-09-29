require "simplecov"
SimpleCov.start do
  add_filter "/test/"
end

require "minidoc"
require "minidoc/test_helpers"
require "minitest/autorun"
require "mocha/mini_test"

I18n.enforce_available_locales = false
I18n.load_path << File.expand_path("../locale/en.yml", __FILE__)

class User < Minidoc
  self.collection_name = "users"

  attribute :name, String
  attribute :age, Integer
end

class SecondUser < Minidoc
  self.collection_name = "users"

  attribute :age, Integer
end

$mongo = Mongo::MongoClient.from_uri(ENV["MONGODB_URI"] || "mongodb://localhost")
Minidoc.connection = $mongo
Minidoc.database_name = "minidoc_test"

class Minidoc::TestCase < Minitest::Test
  def setup
    Minidoc::TestHelpers.clear_database
  end
end
