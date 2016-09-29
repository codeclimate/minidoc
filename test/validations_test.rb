require File.expand_path("../helper", __FILE__)

class ValidationsTest < Minidoc::TestCase
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

  def test_create_bang
    assert_raises Minidoc::RecordInvalid do
      User.create!
    end
  end

  def test_invalid_save
    user = User.new
    assert_equal false, user.save
    assert_equal true, user.new_record?
  end

  def test_save_bang
    assert_raises Minidoc::RecordInvalid do
      User.new.save!
    end
  end
end
