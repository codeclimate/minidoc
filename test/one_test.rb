require File.expand_path('../helper', __FILE__)

class OneTest < Minidoc::TestCase
  class Cat < Minidoc
    include Minidoc::Associations
    belongs_to :owner, class_name: "User"
  end

  class User < ::User
    include Minidoc::Associations
    one :cat, class_name: "OneTest::Cat", foreign_id: "owner_id"
  end

  def test_loading
    assert_nil Cat.new.owner
    user = User.create
    cat = Cat.new(owner_id: user.id)
    assert_equal user.id, cat.owner.id
    cat.save
    assert_equal cat.id, user.cat.id
  end

  def test_caching
    user1 = User.create(name: "Bryan")
    user2 = User.create(name: "Noah")

    cat = Cat.create(owner_id: user1.id)
    assert_equal cat, user1.cat
    assert_nil user2.cat

    cat.set(owner_id: user2.id)
    assert_equal cat, user1.cat
    assert_equal cat, user2.cat

    assert_nil user1.reload.cat
  end
end
