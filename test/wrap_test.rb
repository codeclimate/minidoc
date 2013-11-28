require File.expand_path('../helper', __FILE__)

class WrapTest < Minidoc::TestCase
  def test_wrap_nil
    assert_equal nil, User.wrap(nil)
  end

  def test_wrap_one
    user = User.wrap(
      _id: BSON::ObjectId('529558aef9f6a52bdc000001'),
      name: "Bryan"
    )
    assert_equal BSON::ObjectId('529558aef9f6a52bdc000001'), user.id
    assert_equal "Bryan", user.name
  end

  def test_wrap_many
    attrs = {
      _id: BSON::ObjectId('529558aef9f6a52bdc000001'),
      name: "Bryan"
    }
    users = User.wrap([attrs])
    user = users.first
    assert_equal BSON::ObjectId('529558aef9f6a52bdc000001'), user.id
    assert_equal "Bryan", user.name
  end
end
