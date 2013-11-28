require File.expand_path('../helper', __FILE__)

class ActiveModelTest < Minidoc::TestCase
  def test_model_name
    assert_equal "User", User.model_name.to_s
  end

  def test_to_model
    user = User.new
    assert_equal user, user.to_model
  end

  def test_to_key
    user = User.new
    user.id = BSON::ObjectId('52955618f9f6a52444000001')
    assert_equal ["52955618f9f6a52444000001"], user.to_key
  end

  def test_to_param
    user = User.new
    user.id = BSON::ObjectId('52955618f9f6a52444000001')
    assert_equal "52955618f9f6a52444000001", user.to_param
  end

  def test_to_path
    assert_equal "users/user", User.new.to_partial_path
  end
end
