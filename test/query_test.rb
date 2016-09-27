require File.expand_path('../helper', __FILE__)

class QueryTest < Minidoc::TestCase
  def test_all
    User.collection << { name: "Joe" }
    User.collection << { name: "Bryan" }
    users = User.all
    assert_equal %w[Bryan Joe], users.map(&:name).sort
  end

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

  def test_find_one
    user = User.create(name: "Bryan")
    assert_equal user, User.find_one({})
    assert_equal nil, User.find_one(name: "Noah")
  end

  def test_find_one!
    user = User.create(name: "Bryan")
    assert_equal user, User.find_one!(name: "Bryan")
    assert_raises(Minidoc::DocumentNotFoundError) { User.find_one!(name: "Noah") }
  end

  def test_find_one_or_initialize
    user = User.create(name: "Bryan", age: 1)
    assert user == User.find_one_or_initialize(name: "Bryan")
    assert User.find_one_or_initialize(name: "Noah").is_a?(User)
    assert User.find_one_or_initialize(name: "Noah").new_record?
    user = User.create(name: "Noah", age: 1)
    assert user == User.find_one_or_initialize({ age: 1 }, { sort: { name: -1 } })
    assert_raises(ArgumentError) { User.find_one_or_initialize("foo") }
  end

end
