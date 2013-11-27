require File.expand_path('../helper', __FILE__)

class FindTest < MongoDoc::TestCase
  def test_first
    assert_equal nil, User.first
    user = User.create(name: "Bryan")
    assert_equal "Bryan", User.first.name
    assert_equal user, User.first
  end

  def test_find
    user = User.create(name: "Bryan")
    assert_equal [user], User.find({})
    assert_equal [], User.find(name: "Noah")
  end

  def test_find_one
    user = User.create(name: "Bryan")
    assert_equal user, User.find_one({})
    assert_equal nil, User.find_one(name: "Noah")
  end
end
