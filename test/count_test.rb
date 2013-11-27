require File.expand_path('../helper', __FILE__)

class CountTest < MongoDoc::TestCase
  def test_count_all
    User.collection << { name: "Joe" }
    User.collection << { name: "Bryan" }
    assert_equal 2, User.count
  end

  def test_count_query
    User.collection << { name: "Joe" }
    User.collection << { name: "Bryan" }
    assert_equal 1, User.count(name: "Bryan")
  end
end
