require File.expand_path('../helper', __FILE__)

class ConnectionTest < MongoDoc::TestCase
  def test_collection_name
    assert_equal "users", User.collection_name
  end

  def test_collection
    assert_equal "users", User.collection.name
  end

  def test_database
    assert_equal "mongodoc_test", User.database.name
  end
end
