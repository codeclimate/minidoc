require File.expand_path("../helper", __FILE__)

class UniquenessValidatorTest < Minidoc::TestCase
  class User < ::User
    validates :name, uniqueness: true
  end

  class InsensitiveUser < ::User
    attribute :insensitive, String
    validates :insensitive, uniqueness: { case_sensitive: false }
  end

  class ScopedUser < ::User
    attribute :country_id, Integer
    attribute :tax_id_number, Integer
    validates :tax_id_number, uniqueness: { scope: :country_id }
  end

  def test_invalid_with_existing_value
    User.create!(name: "same name")
    user = User.new(name: "same name")
    assert_equal false, user.valid?
    assert_equal ["has already been taken"], user.errors[:name]
  end

  def test_case_sensitive_by_default
    User.create!(name: "different case")
    user = User.new(name: "DIFFERENT CASE")
    assert_equal true, user.valid?
  end

  def test_unique_persisted_record_is_valid
    user = User.create!(name: "lonely")
    assert_equal true, user.valid?
  end

  def test_case_insensitive
    InsensitiveUser.create!(insensitive: "equivalent")
    user = InsensitiveUser.new(insensitive: "EquivALENT")
    assert_equal false, user.valid?
    assert_equal ["has already been taken"], user.errors[:insensitive]
  end

  def test_same_value_within_scope
    ScopedUser.create!(country_id: 1, tax_id_number: 1)
    user = ScopedUser.new(country_id: 1, tax_id_number: 1)
    assert_equal false, user.valid?
    assert_equal ["has already been taken"], user.errors[:tax_id_number]
  end

  def test_different_value_within_scope
    ScopedUser.create!(country_id: 1, tax_id_number: 1)
    user = ScopedUser.new(country_id: 1, tax_id_number: 2)
    assert_equal true, user.valid?
  end

  def test_same_value_outside_scope
    ScopedUser.create!(country_id: 1, tax_id_number: 1)
    user = ScopedUser.new(country_id: 2, tax_id_number: 1)
    assert_equal true, user.valid?
  end

  def test_same_value_outside_scope
    ScopedUser.create!(country_id: 1, tax_id_number: 1)
    user = ScopedUser.new(country_id: 2, tax_id_number: 2)
    assert_equal true, user.valid?
  end
end
