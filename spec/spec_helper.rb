require "simplecov"
require "simplecov_json_formatter"
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.start do
  add_filter "/test/"
end

require "minidoc"
require "minidoc/test_helpers"

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

uri = Mongo::URI.new(ENV["MONGODB_URI"] || "mongodb://localhost:27017")

$mongo = Mongo::Client.new(uri.servers, uri.client_options)
$mongo.logger.level = Logger::FATAL

Minidoc.connection = $mongo
Minidoc.database_name = $mongo.database.name

options = uri.options.merge(database: "#{uri.database}_2")
$alt_mongo = Mongo::Client.new(uri.servers, options)

RSpec.configure do |config|
  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  config.order = :random

  Kernel.srand config.seed

  config.before(:each) do
    Minidoc::TestHelpers.clear_databases([$mongo, $alt_mongo])
  end
end
