require File.expand_path('../helper', __FILE__)

class AliasTest < Minidoc::TestCase
  class User < ::User
    include Aliasing
    short_attribute :n, :name
  end

  def test_alias
    User.collection << { n: "Bryan" }
    assert_equal "Bryan", User.first.name
  end

  def test_regular
    User.collection << { name: "Bryan" }
    assert_equal "Bryan", User.first.name
  end

  def test_saving
    user = User.new(name: "Bryan")
    assert_equal "Bryan", user.attributes[:n]
    user.save
    doc = User.collection.find_one({})
    assert_equal "Bryan", doc["n"]
    assert_equal "Bryan", User.first.name
  end

  def test_precendence
    User.collection << { n: "Short", name: "Long" }
    assert_equal "Short", User.first.name
  end
end
