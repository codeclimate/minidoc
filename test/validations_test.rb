require File.expand_path('../helper', __FILE__)

class ValidationsTest < MongoDoc::TestCase
  class User < ::User
    validates :name, presence: true
  end

  def test_valid
    user = User.new
    assert_equal false, user.valid?
  end

  def test_errors
    user = User.new
    user.valid?
    assert_equal ["can't be blank"], user.errors[:name]
  end
end
