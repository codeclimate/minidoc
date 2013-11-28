require File.expand_path('../helper', __FILE__)

class ConnectionTest < Minidoc::TestCase
  class Company < Minidoc
    self.collection_name = "accounts"
  end

  def test_collection_name
    assert_equal "users", User.collection_name
    assert_equal "accounts", Company.collection_name
  end

  def test_collection
    assert_equal "users", User.collection.name
  end

  def test_database
    assert_equal "minidoc_test", User.database.name
  end
end
