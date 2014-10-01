require File.expand_path('../helper', __FILE__)

class QueryTest < Minidoc::TestCase
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

  def test_exists
    User.collection << { name: "Joe" }
    assert User.exists?(name: "Joe")
    refute User.exists?(name: "Bryan")
  end

  def test_first
    assert_equal nil, User.first
    user = User.create(name: "Bryan")
    assert_equal "Bryan", User.first.name
    assert_equal user, User.first
  end

  def test_find
    user = User.create(name: "Bryan")
    assert_equal [user], User.find({}).to_a
    assert_equal [], User.find(name: "Noah").to_a
  end

  def test_find_with_pagination
    a, b, c = %w(a b c).map{ |name| User.create(name: name) }
    assert_equal [a,b], User.find({}, { sort: "name", page: 1, per_page: 2 }).to_a
    assert_equal [c], User.find({}, { sort: "name", page: 2, per_page: 2 }).to_a
    assert_equal [], User.find({}, { sort: "name", page: 2, per_page: 3 }).to_a
  end

  def test_find_one
    user = User.create(name: "Bryan")
    assert_equal user, User.find_one({})
    assert_equal nil, User.find_one(name: "Noah")
  end
end
