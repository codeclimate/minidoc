require File.expand_path('../helper', __FILE__)

class SetTest < Minidoc::TestCase
  def test_class_set
    user = User.create(name: "Bryan")
    User.set(user.id, name: "Noah")
    assert_equal "Bryan", user.name # Class set can't trigger update
    assert_equal "Noah", user.reload.name
    assert_equal "Noah", User.first.name

    User.set(user.id.to_s, name: "Mike")
    assert_equal "Mike", user.reload.name
    assert_equal "Mike", User.first.name
  end

  def test_instance_set
    user = User.create(name: "Bryan")
    user.set(name: "Noah")
    assert_equal "Noah", user.name
    assert_equal "Noah", user.reload.name
    assert_equal "Noah", User.first.name

    user = User.create(name: "Bryan")
    user.set("name" => "Noah")
    assert_equal "Noah", user.name
    assert_equal "Noah", user.reload.name
  end

  def test_class_unset
    user = User.create(name: "Bryan")
    User.unset(user.id, :name)
    assert_equal "Bryan", user.name # Class set can't trigger update
    assert_equal nil, user.reload.name
    assert_equal nil, User.first.name

    User.unset(user.id.to_s, :name)
    assert_equal nil, user.reload.name
    assert_equal nil, User.first.name
  end

  def test_instance_unset
    user = User.create(name: "Bryan")
    user.unset(:name)
    assert_equal nil, user.name
    assert_equal nil, user.reload.name
    assert_equal nil, User.first.name

    user = User.create(name: "Bryan")
    user.unset("name")
    assert_equal nil, user.name
    assert_equal nil, user.reload.name
  end
end
