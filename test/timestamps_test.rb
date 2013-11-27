require File.expand_path('../helper', __FILE__)

class TimestampsTest < MongoDoc::TestCase
  class User < ::User
    timestamps!
  end

  def test_create
    user = User.create
    assert user.created_at
    assert_equal user.created_at, user.updated_at
  end

  def test_update
    user = User.create
    sleep 0.001
    refute_equal user.created_at, user.updated_at
  end
end
