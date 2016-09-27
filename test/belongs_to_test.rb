require File.expand_path('../helper', __FILE__)

class BelongsToTest < Minidoc::TestCase
  class Cat < Minidoc
    include Minidoc::Associations
    belongs_to :owner, class_name: "User"
  end

  class ::Dog < Minidoc
    include Minidoc::Associations
    belongs_to :user
  end

  class User < ::User
  end

  module Animal
    class Armadillo < Minidoc
      include Minidoc::Associations
      belongs_to :predator
    end

    class Predator < Minidoc
    end
  end

  def test_loading
    assert_nil Cat.new.owner
    user = User.create
    cat = Cat.new(owner_id: user.id)
    assert_equal user.id, cat.owner.id
    cat.save
    assert_equal user.id, cat.owner.id
  end

  def test_caching
    user = User.create(name: "Bryan")
    cat = Cat.create(owner_id: user.id)
    assert_equal "Bryan", cat.owner.name
    user.set(name: "Noah")
    assert_equal "Bryan", cat.owner.name # doesn't change
    assert_equal "Noah", cat.reload.owner.name # changes
  end

  def test_cache_expiry_on_field_update
    user = User.create(name: "Bryan")
    cat = Cat.create(owner_id: user.id)
    assert_equal "Bryan", cat.owner.name
    user.set(name: "Noah")
    assert_equal "Bryan", cat.owner.name # doesn't change
    cat.owner = user
    assert_equal "Noah", cat.owner.name # changes
  end

  def test_cache_expiry_on_id_update
    user = User.create(name: "Bryan")
    cat = Cat.create(owner_id: user.id)
    assert_equal "Bryan", cat.owner.name
    user.set(name: "Noah")
    assert_equal "Bryan", cat.owner.name # doesn't change
    cat.owner_id = user.id
    assert_equal "Noah", cat.owner.name # changes
  end

  def test_top_level_inferred_class_name
    assert_nil Dog.new.user
    user = User.create
    sam = Dog.new(user_id: user.id)
    assert_equal user.id, sam.user.id
    sam.save
    assert_equal user.id, sam.user.id
  end

  def test_nested_inferred_class_name
    assert_nil Animal::Armadillo.new.predator
    predator = Animal::Predator.create
    arnie = Animal::Armadillo.new(predator_id: predator.id)
    assert_equal predator.id, arnie.predator.id
    arnie.save
    assert_equal predator.id, arnie.predator.id
  end
end
