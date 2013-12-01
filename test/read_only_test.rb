require File.expand_path('../helper', __FILE__)

class ReadOnlyTest < Minidoc::TestCase
  class ReadOnlyUser < Minidoc::ReadOnly
    self.collection_name = "users"
    attribute :name, String
  end

  def test_read_only
    assert_raises NoMethodError do
      ReadOnlyUser.create(name: "Bryan")
    end

    User.create(name: "Bryan")
    user = ReadOnlyUser.first
    assert_equal "Bryan", user.name

    assert_raises NoMethodError do
      user.name = "Noah"
    end
  end
end
