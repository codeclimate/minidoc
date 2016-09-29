require File.expand_path("../helper", __FILE__)

class ReadOnlyTest < Minidoc::TestCase
  class ReadOnlyUser < Minidoc::ReadOnly
    self.collection_name = "users"
    attribute :name, String
  end

  def test_read_only
    assert_raises NoMethodError do
      ReadOnlyUser.create(name: "Bryan")
    end

    rw_user = User.create(name: "Bryan")
    user = ReadOnlyUser.first
    assert_equal "Bryan", user.name
    assert_equal rw_user.id, user.id
    assert_equal user, user.as_value

    assert_raises NoMethodError do
      user.name = "Noah"
    end
  end

  def test_value
    user = User.new(name: "Bryan")
    user.name = "Noah"
    user = user.as_value

    assert_raises NoMethodError do
      user.name = "Noah"
    end
  end
end
