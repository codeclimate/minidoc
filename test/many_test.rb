require File.expand_path('../helper', __FILE__)

class ManyTest < Minidoc::TestCase
  class Cat < Minidoc
    include Minidoc::Associations
    belongs_to :owner, class_name: "User"
  end

  class User < ::User
    include Minidoc::Associations
    many :cats, class_name: "ManyTest::Cat", foreign_key: "owner_id"
  end

  def test_loading
    assert_nil Cat.new.owner
    user = User.create
    cat = Cat.new(owner_id: user.id)
    assert_equal user.id, cat.owner.id
    cat.save
    assert_equal cat.id, user.cats.first.id
  end

  def test_cursors_are_not_cached_but_empty_collections_are
    user1 = User.create(name: "Bryan")
    user2 = User.create(name: "Noah")

    cat = Cat.create(owner_id: user1.id)
    assert_equal 1, user1.cats.to_a.size
    assert_equal 0, user2.cats.to_a.size

    cat.set(owner_id: user2.id)
    assert_equal 0, user1.cats.to_a.size # changes
    assert_equal 0, user2.cats.to_a.size # doesn't change :(

    assert_equal 1, user2.reload.cats.to_a.size # changes
  end
end
