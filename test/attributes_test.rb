require File.expand_path('../helper', __FILE__)

class AttributesTest < Minidoc::TestCase
  def test_initialization
    user = User.new(name: "Bryan")
    assert_equal "Bryan", user.name
  end

  def test_updates
    user = User.new(name: "Bryan")
    user.name = "Noah"
    assert_equal "Noah", user.name
  end
end
